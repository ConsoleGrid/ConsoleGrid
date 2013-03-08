require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "should get top_picture" do
    get :top_picture
    assert_response :success
  end

end
