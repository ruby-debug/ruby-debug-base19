#!/usr/bin/env ruby
require_relative 'debug_test_base'

# Test catchpoint in C ruby_debug extension.
  
class TestRubyDebugCatchpoint < DebugTestBase
  # test current_context
  def test_catchpoints
    assert_raise(RuntimeError) {Debugger.catchpoints}
    Debugger.start_
    assert_equal({}, Debugger.catchpoints)
    Debugger.add_catchpoint('ZeroDivisionError')
    assert_equal({'ZeroDivisionError' => 0}, Debugger.catchpoints)
    Debugger.add_catchpoint('RuntimeError')
    assert_equal(['RuntimeError', 'ZeroDivisionError'], 
                 Debugger.catchpoints.keys.sort)
  ensure
    Debugger.stop
  end

end

