
task :default => :test

task :run do 
  exec "qmake plugin.pro && make && qmlscene ./app.qml"
end

task :test do 
  exec "qmake plugin.pro && make && qmltestrunner"
end
