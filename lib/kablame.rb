class Kablame

  def initialize()
    @users = {}
  end
  
  def kablame
    folders.each do |directory|
      if File.exists?(directory) 
        puts "Processing #{directory}"
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
      puts "No results.  Write some #{type.pluralize}!"
    end
  end
  
  def process_file(filename)
    lines = (`svn blame #{filename}`).split("\n")
    puts "\t #{filename} -- #{lines.length} lines"
    lines.each do |line|
      name = line.match(/\d+[\ ]+(\w+)/)[1]
      @users[name] ? @users[name].increment : @users[name] = User.new(name) unless name.nil?
    end
  end
  
  def print_results
    puts "++++++++++++TOTALS++++++++++++"
    puts "**WINNER** #{@users.values.sort.first.name} **WINNER**"
    @users.values.sort.each do |user|
      puts user.to_s
    end 
    puts "**LOSER** #{@users.values.sort.last.name} **LOSER**"   
  end
    
  
  def folders
    raise "this should be overridden by a subclass" 
  end
  
  def file_format_regex
    raise "this should be overridden by a subclass" 
  end
    
  class User
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
      "#{@name}#{' '*(20 - @name.length)} ==> #{@line_count}"
    end
    
    def increment
      @line_count = @line_count.next
    end
  end
end

class TestKablame < Kablame
  def folders
    ['test/unit','test/functional', 'test/integration']
  end
  
  def file_format_regex
    /\.rb/ 
  end
  
  def type; "test"; end
  
end

class SpecKablame < Kablame
  def folders
    ['spec/models','spec/controllers','spec/views','spec/helpers']
  end
  
  def file_format_regex
    /\.rb/ 
  end
  
  def type; "spec"; end
end