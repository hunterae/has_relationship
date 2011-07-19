begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "has-relationship"
    gemspec.summary = "has_relationship is an easy way to instantly create an association between any two database tables"
    gemspec.description = "With has_relationship, you can instantly create an association between any two database tables."
    gemspec.email = "hunterae@gmail.com"
    gemspec.homepage = "http://github.com/hunterae/has_relationship"
    gemspec.authors = ["Andrew Hunter"]
    gemspec.files =  FileList["[A-Z]*", "{lib,spec,rails}/**/*"] - FileList["**/*.log"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end