class Kablame

  def initialize()
    @users = {}
  end
  
  def kablame
    folders.each do |directory|
      if File.exists?(directory) 
        puts "\nKablaming #{directory}"
        Dir.glob(directory+"/**/*").grep(file_format_regex).each do |filename|
          process_file(filename)
        end
      else
        puts "#{directory} not found. Skipping it!"
      end
    end
    unless(@users.empty?)
      print_results 
    else
      puts "No results.  Write some #{type}!"
    end
  end 
  
  def process_file(filename)
    print '.'
    STDOUT.flush
    get_blame_lines(filename).each do |line|
      next if line.match(blank_line_regex)
      name = line.match(name_match_regex)[1]  
      (@users[name] ? @users[name].increment : @users[name] = KablameUser.new(name)) unless name.nil?
    end
  end
  
  def print_results
    puts "\n\n++++++++++++TOTALS++++++++++++"
    puts "**WINNER** #{@users.values.sort.first.name} **WINNER**"
    @users.values.sort.each do |user|
      puts user.to_s
    end 
    puts "**LOSER** #{@users.values.sort.last.name} **LOSER**"
    puts @info if @info
  end
    
  
  def folders
    raise "this should be overridden by a subclass" 
  end
  
  def file_format_regex
    raise "this should be overridden by a subclass" 
  end 
  
  def type
    raise "this should be overridden by a subclass" 
  end  
end

module Svn
  def blank_line_regex; /\d+[\ ]+(\w+)+(\s+)$/; end
  
  def name_match_regex; /\d+[\ ]+(\w+)/; end
 
  def get_blame_lines(filename)
    `svn blame #{filename}`.split("\n")
  end

  def version_control; 'svn'; end
end

module Git 
  def blank_line_regex; /\(.+[\+-]\d{4}\s+\d+\)(\s*)$/; end
  
  def name_match_regex; /\((\w+)\s/; end
  
  def get_blame_lines(filename)
    `git blame #{filename}`.split("\n")
  end
  
  def version_control; 'git'; end
end

class TestKablame < Kablame
  def folders
    ['test/unit','test/functional', 'test/integration']
  end
  
  def file_format_regex
    /\.rb/ 
  end
  
  def type; "tests"; end
end

class SpecKablame < Kablame
  def folders
    ['spec/models','spec/controllers','spec/views','spec/helpers']
  end
  
  def file_format_regex
    /\.rb/ 
  end
  
  def type; "specs"; end
end

class GeneralKablame < Kablame 
  
  def initialize(dirs, formats)
    @folders = dirs ? dirs.split : %w{app lib}
    @formats = formats ? formats.split : %w{rb r?html}
    @info = "To get more detailed information use kablame:svn
  Specify a set of directories and/or file formats
  rake kablame:#{version_control}  DIRS='app config' FORMATS='html xml'"  
    
    super()
  end
  
   def folders 
     @folders
   end
   
   def file_format_regex
     %r{\.(#{@formats.join('|')})}
   end
   
   def type; "stuff"; end
end

class KablameUser
  attr_accessor :line_count
  attr_accessor :name

  def initialize(name)   
    @line_count = 1
    @name = name
  end

  def <=>(other)
    other.line_count <=> @line_count
  end

  def to_s
    "#{@name.ljust(20)} ==> #{@line_count.to_s.rjust(4)}"
  end

  def increment
    @line_count = @line_count.next
  end
end 