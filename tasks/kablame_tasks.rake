namespace :kablame do
  
  desc 'KABLAME anything: DIRS="app lib"'
  task :svn => :environment do
    require 'kablame'
    GeneralKablame.send(:include, Svn)
    GeneralKablame.new(ENV['DIRS'], ENV['FORMATS']).kablame
  end
  namespace :svn do
    desc "KABLAME tests! See how much test code SVN says is yours"
    task :tests => :environment do
      require 'kablame'
      TestKablame.send(:include, Svn)
      TestKablame.new.kablame
    end
  
    desc "KABLAME specs! See how much of the specs SVN says is yours"
    task :specs => :environment do
      require 'kablame'
      SpecKablame.send(:include, Svn)
      SpecKablame.new.kablame
    end    
  end
  
  
  desc 'KABLAME anything: DIRS="app lib"'
  task :git => :environment do
    require 'kablame'
    GeneralKablame.send(:include, Git)
    GeneralKablame.new(ENV['DIRS'], ENV['FORMATS']).kablame
  end  
  namespace :git do
    desc "KABLAME tests! See how much test code GIT says is yours"
    task :tests => :environment do
      require 'kablame'
      TestKablame.send(:include, Git)
      TestKablame.new.kablame
    end
  
    desc "KABLAME specs! See how much of the specs GIT says is yours"
    task :specs => :environment do
      require 'kablame'
      SpecKablame.send(:include, Git)
      SpecKablame.new.kablame
    end    
  end   
end