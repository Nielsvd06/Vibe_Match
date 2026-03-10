require "test_helper"

class CurrentVibesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get current_vibes_index_url
    assert_response :success
  end
end
