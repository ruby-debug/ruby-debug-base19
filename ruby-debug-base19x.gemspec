RUBY_DEBUG_VERSION = open("ext/ruby_debug/ruby_debug.c") do |f|
  f.grep(/^#define DEBUG_VERSION/).first[/"(.+)"/,1]
end unless defined? RUBY_DEBUG_VERSION

unless defined? FILES
  FILES = [
    'AUTHORS',
    'CHANGES',
    'LICENSE',
    'README',
    'Rakefile',
    'ext/ruby_debug/breakpoint.c',
    'ext/ruby_debug/extconf.rb',
    'ext/ruby_debug/ruby_debug.c',
    'ext/ruby_debug/ruby_debug.h',
  ]
  FILES.push(*Dir['lib/**/*'])
end

Gem::Specification.new do |spec|
  spec.name = "ruby-debug-base19x"

  spec.homepage = "https://github.com/JetBrains/ruby-debug-base19"
  spec.summary = "Fast Ruby debugger - core component"
  spec.description = <<-EOF
ruby-debug is a fast implementation of the standard Ruby debugger debug.rb.
It is implemented by utilizing a new Ruby C API hook. The core component
provides support that front-ends can build on. It provides breakpoint
handling, bindings for stack frames among other things.
EOF

  spec.version = RUBY_DEBUG_VERSION

  spec.author = "Kent Sibilev, Mark Moseley"
  spec.email = "ksibilev@yahoo.com"
  spec.platform = Gem::Platform::RUBY
  spec.require_path = "lib"
  spec.extensions = ["ext/ruby_debug/extconf.rb"]
  spec.files = FILES

  spec.required_ruby_version = '>= 1.9'
  spec.date = Time.now
  spec.rubyforge_project = 'ruby-debug19'
  spec.add_dependency('ruby_core_source', [">= 0.1.4"])
  spec.add_dependency("rake", ">= 0.8.1")

  # rdoc
  spec.has_rdoc = true
  spec.extra_rdoc_files = ['README', 'ext/ruby_debug/ruby_debug.c']
end