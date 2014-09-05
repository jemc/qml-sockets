
require 'qt/commander'

task :default => :test

task :android do
  Qt::Commander::Creator.profiles.select(&:android?).each do |profile|
    profile.toolchain.env do
      system "#{profile.version.qmake} *.pro -spec android-g++" and
      system "make"
    end
  end
end

task :install do
  system "qmake *.pro && make"
end

task :test => :install do
  system "qmltestrunner"
end

task :clean do
  `make clean && rm Makefile`
end

task :cleantest => [:clean, :test]
