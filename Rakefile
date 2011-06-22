#!/usr/bin/env rake
# -*- Ruby -*-
require 'rubygems'

require 'bundler/gem_tasks'
require 'rake/rdoctask'
require 'rake/testtask'

BASE_TEST_FILE_LIST = Dir['test/**/*_test.rb']

task :default => [:test_base]

desc "Create the core ruby-debug shared library extension"
task :lib do
  Dir.chdir("ext/ruby_debug") do
    system("#{Gem.ruby} extconf.rb && make")
  end
end

desc "Test ruby-debug-base."
task :test_base => :lib do 
  Rake::TestTask.new(:test_base) do |t|
    t.libs += ['./ext/ruby_debug', './lib']
    t.test_files = FileList[BASE_TEST_FILE_LIST]
    t.verbose = true
  end
end
