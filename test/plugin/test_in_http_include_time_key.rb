require "helper"
require "fluent/plugin/in_http_include_time_key.rb"

class HttpIncludeTimeKeyInputTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
  end

  test "failure" do
    flunk
  end

  private

  def create_driver(conf)
    Fluent::Test::Driver::Input.new(Fluent::Plugin::HttpIncludeTimeKeyInput).configure(conf)
  end
end
