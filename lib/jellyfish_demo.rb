require 'rails'

require 'jellyfish_demo/engine'

module JellyfishDemo
end

class ActiveSupport::TestCase
  # self.fixture_path = JellyfishDemo::Engine.root.join('test', 'fixtures')
  self.fixture_path = Rails.root.parent + './fixtures'
end
