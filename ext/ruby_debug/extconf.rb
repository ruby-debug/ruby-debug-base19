require "mkmf"
require "ruby_core_source"

hdrs = proc {
  iseqs = %w[vm_core.h iseq.h]
  begin
    have_struct_member("rb_method_entry_t", "called_id", "method.h") or
    have_struct_member("rb_control_frame_t", "method_id", "method.h")
  end and
  have_header("vm_core.h") and have_header("iseq.h", "vm_core.h") and have_header("insns.inc") and
  have_header("insns_info.inc") and have_header("eval_intern.h") or break
  have_type("struct iseq_line_info_entry", iseqs) or
  have_type("struct iseq_insn_info_entry", iseqs) or
  break
  if checking_for(checking_message("if rb_iseq_compile_with_option was added an argument filepath")) do
      try_compile(<<SRC)
#include <ruby.h>
#include "vm_core.h"
extern VALUE rb_iseq_new_main(NODE *node, VALUE filename, VALUE filepath);
SRC
    end
    $defs << '-DRB_ISEQ_COMPILE_5ARGS'
  end
}

dir_config("ruby")
name = "ruby_debug"
if (ENV['rvm_ruby_string'])
  dest_dir = Config::CONFIG["rubyhdrdir"]
  with_cppflags("-I" + dest_dir) {
    if hdrs.call
      create_makefile(name)
      exit 0
    end
  }
end
if !Ruby_core_source::create_makefile_with_core(hdrs, name)
  STDERR.print("Makefile creation failed\n")
  STDERR.print("*************************************************************\n\n")
  STDERR.print("  NOTE: For Ruby 1.9 installation instructions, please see:\n\n")
  STDERR.print("     http://wiki.github.com/mark-moseley/ruby-debug\n\n")
  STDERR.print("*************************************************************\n\n")
  exit(1)
end
