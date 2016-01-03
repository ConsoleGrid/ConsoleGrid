require 'test_helper'

class Api::V1::ApiControllerTest < ActionController::TestCase
  setup do
    # Since we have a single endpoint for searching both consoles and games,
    # we need to reindex them both before running a test
    Console.reindex
    Game.reindex
  end

  test "should return no content when missing game" do
    # Zelda is in the fixtures, but only N64/Gamecube games
    get :top_picture, :console => "NES", :game => "Zelda"
    assert_response(204)
  end

  test "should return an image link when found a game" do
    get :top_picture, :console => "N64", :game => "Ocarina"
    assert_response(200)
    assert_equal @response.body, pictures(:oot_picture_one).image_url
  end

  test "should return an empty string when game has no pictures" do
    get :top_picture, :console => "N64", :game => "Majora"
    assert_response(200)
    assert_equal @response.body, ""
  end
end
