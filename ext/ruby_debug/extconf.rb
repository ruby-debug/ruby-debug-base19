# autodetect ruby headers
unless ARGV.any? {|arg| arg.include?('--with-ruby-include') }
  require 'rbconfig'
  bindir = RbConfig::CONFIG['bindir']
  if bindir =~ %r{(^.*/\.rbenv/versions)/([^/]+)/bin$}
    ruby_include = "#{$1}/#{$2}/include/ruby-1.9.1/ruby-#{$2}"
    ARGV << "--with-ruby-include=#{ruby_include}"
  elsif bindir =~ %r{(^.*/\.rvm/rubies)/([^/]+)/bin$}
    ruby_include = "#{$1}/#{$2}/include/ruby-1.9.1/#{$2}"
    ruby_include = "#{ENV['rvm_path']}/src/#{$2}" unless File.exist?(ruby_include)
    ARGV << "--with-ruby-include=#{ruby_include}"
  end
end

require "mkmf"
require "debugger/ruby_core_source"

hdrs = proc {
  begin
    have_struct_member("rb_method_entry_t", "called_id", "method.h") or
    have_struct_member("rb_control_frame_t", "method_id", "method.h")
  end and
  begin
    have_func("rb_method_entry", "method.h") or
    have_func("rb_method_node", "node.h")
  end and
  have_header("vm_core.h") and have_header("iseq.h") and have_header("insns.inc") and
  have_header("insns_info.inc") and have_header("eval_intern.h")
  have_func("rb_iseq_new_main", "vm_core.h")
  have_func("rb_iseq_compile_on_base", "vm_core.h")
  have_struct_member("rb_iseq_t", "location", "vm_core.h") or have_struct_member("rb_iseq_t", "filename", "vm_core.h")
  have_struct_member("rb_iseq_t", "line_info_size", "vm_core.h") or have_struct_member("rb_iseq_t", "insn_info_size", "vm_core.h")
  have_struct_member("rb_control_frame_t", "ep", "vm_core.h") or 
    have_struct_member("rb_control_frame_t", "dfp", "vm_core.h")
  have_struct_member("rb_control_frame_t", "bp", "vm_core.h")
  true
}

$defs << "-O0"

dir_config("ruby")
if !Debugger::RubyCoreSource.create_makefile_with_core(hdrs, "ruby_debug")
  STDERR.print("Makefile creation failed\n")
  STDERR.print("*************************************************************\n\n")
  STDERR.print("  NOTE: If your headers were not found, try passing\n")
  STDERR.print("        --with-ruby-include=PATH_TO_HEADERS      \n\n")
  STDERR.print("*************************************************************\n\n")
  exit(1)
end
