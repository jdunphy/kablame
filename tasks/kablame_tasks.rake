
namespace :kablame do
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