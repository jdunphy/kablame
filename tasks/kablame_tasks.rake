
namespace :kablame do
  desc "KABLAME tests! See how much test code SVN says is yours"
  task :tests => :environment do
    require 'kablame'
    TestKablame.new.kablame
  end
  
  desc "KABLAME specs! See how much of the specs SVN says is yours"
  task :specs => :environment do
    require 'kablame'
    SpecKablame.new.kablame
  end  
end