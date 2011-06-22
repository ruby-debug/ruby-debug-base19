#!/usr/bin/env ruby

require_relative 'debug_test_base'

# Test binding_n command
class TestBinding < DebugTestBase
  def test_basic
    def inside_fn
      s = 'some other string'
      b2 = Kernel::binding_n(1)
      y2 = eval('s', b2)
      assert_equal('this is a test', y2)
    end
    s = 'this is a test'
    Debugger.start
    b = Kernel::binding_n(0)
    y = eval('s', b)
    assert_equal(y, s)
    inside_fn
  ensure
    Debugger.stop
  end
end
