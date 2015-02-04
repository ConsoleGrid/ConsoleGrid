require 'test_helper'

class Api::V1::ApiControllerTest < ActionController::TestCase
  test "should get top_picture" do
    get :top_picture, :console => "NES", :game => "Zelda"
    assert_response :success
  end
end
