#!/usr/bin/env rake
# -*- Ruby -*-
require 'rubygems'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require 'rake/extensiontask'

Rake::ExtensionTask.new('ruby_debug')

SO_NAME = "ruby_debug.so"

# ------- Default Package ----------
RUBY_DEBUG_VERSION = open("ext/ruby_debug/ruby_debug.c") do |f| 
  f.grep(/^#define DEBUG_VERSION/).first[/"(.+)"/,1]
end

COMMON_FILES = FileList[
  'AUTHORS',
  'CHANGES',
  'LICENSE',
  'README',
  'Rakefile',
]                        

BASE_TEST_FILE_LIST = %w(
  test/base/base.rb 
  test/base/binding.rb 
  test/base/catchpoint.rb)
BASE_FILES = COMMON_FILES + FileList[
  'ext/ruby_debug/breakpoint.c',
  'ext/ruby_debug/extconf.rb',
  'ext/ruby_debug/ruby_debug.c',
  'ext/ruby_debug/ruby_debug.h',
  'ext/win32/*',
  'lib/**/*',
  BASE_TEST_FILE_LIST,
]

# Base GEM Specification
base_spec = Gem::Specification.new do |spec|
  spec.name = "ruby-debug-base19"
  
  spec.homepage = "http://rubyforge.org/projects/ruby-debug/"
  spec.summary = "Fast Ruby debugger - core component"
  spec.description = <<-EOF
ruby-debug is a fast implementation of the standard Ruby debugger debug.rb.
It is implemented by utilizing a new Ruby C API hook. The core component 
provides support that front-ends can build on. It provides breakpoint 
handling, bindings for stack frames among other things.
EOF

  spec.version = RUBY_DEBUG_VERSION

  spec.author = "Kent Sibilev"
  spec.email = "ksibilev@yahoo.com"
  spec.platform = Gem::Platform::RUBY
  spec.require_path = "lib"
  spec.extensions = ["ext/ruby_debug/extconf.rb"]
  spec.files = BASE_FILES.to_a  

  spec.required_ruby_version = '>= 1.8.2'
  spec.date = Time.now
  spec.rubyforge_project = 'ruby-debug19'
  s.add_dependency('columnize', [">= 0.3.1"])
  s.add_dependency('ruby_core_source', [">= 0.1.4"])
  s.add_dependency('linecache19', [">= 0.5.11"])
  
  spec.test_files = FileList[BASE_TEST_FILE_LIST]
  
  # rdoc
  spec.has_rdoc = true
  spec.extra_rdoc_files = ['README', 'ext/ruby_debug/ruby_debug.c']
end


# Rake task to build the default package
Rake::GemPackageTask.new(base_spec) do |pkg|
  pkg.need_tar = true
end

task :default => [:package]

# Windows specification
win_spec = base_spec.clone
win_spec.extensions = []
## win_spec.platform = Gem::Platform::WIN32 # deprecated
win_spec.platform = 'mswin32'
win_spec.files += ["lib/#{SO_NAME}"]

desc "Create Windows Gem"
task :win32_gem do
  # Copy the win32 extension the top level directory
  current_dir = File.expand_path(File.dirname(__FILE__))
  source = File.join(current_dir, "ext", "win32", SO_NAME)
  target = File.join(current_dir, "lib", SO_NAME)
  cp(source, target)

  # Create the gem, then move it to pkg.
  Gem::Builder.new(win_spec).build
  gem_file = "#{win_spec.name}-#{win_spec.version}-#{win_spec.platform}.gem"
  mv(gem_file, "pkg/#{gem_file}")

  # Remove win extension from top level directory.
  rm(target)
end

desc "Publish ruby-debug to RubyForge."
task :publish do 
  require 'rake/contrib/sshpublisher'
  
  # Get ruby-debug path.
  ruby_debug_path = File.expand_path(File.dirname(__FILE__))

  Rake::SshDirPublisher.new("kent@rubyforge.org",
        "/var/www/gforge-projects/ruby-debug", ruby_debug_path)
end

desc "Remove built files"
task :clean do
  cd "ext" do
    if File.exists?("Makefile")
      sh "make clean"
      rm  "Makefile"
    end
    derived_files = Dir.glob(".o") + Dir.glob("*.so")
    rm derived_files unless derived_files.empty?
  end
end

