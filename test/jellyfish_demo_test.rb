require 'test_helper'

class JellyfishDemoTest < ActiveSupport::TestCase
  self.fixture_path = JellyfishDemo::Engine.root.join('test', 'fixtures')
  test "truth" do
    assert_kind_of Module, JellyfishDemo
  end
end
