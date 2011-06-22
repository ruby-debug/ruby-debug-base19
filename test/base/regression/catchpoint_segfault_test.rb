require_relative '../debug_test_base'

class CatchpointSegfaultTest < DebugTestBase
  # test current_context
  def test_catchpoints
    Debugger.handler=FakeHandler.new
    Debugger.start_
    Debugger.add_catchpoint('ZeroDivisionError')
    err
  ensure
    Debugger.stop
  end

  def err
    begin
      5/0
    rescue
    end
  end
end

class FakeHandler
  def method_missing(meth, *args, &block)
  end
end