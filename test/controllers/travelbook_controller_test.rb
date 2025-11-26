require "test_helper"

class TravelbookControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get travelbook_index_url
    assert_response :success
  end
end
