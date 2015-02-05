require 'test_helper'

class Api::V2::GamesControllerTest < ActionController::TestCase
  setup do
    # Index the Game fixtures for testing
    Game.reindex
  end

  test "search with no query returns error" do
    get :search
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_not_nil response_data['error']
    assert_instance_of String, response_data['error']
  end

  test "search with query returns non-duplicate results" do
    get :search, :q => "Zelda"
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_nil response_data['error']
    assert_include response_data, 'games'
    # There are 4 non-duplicate Zelda games in the fixtures
    assert_equal 4, response_data['games'].length
  end

  test "search without a per_page naturally limits page length to Game.per_page" do
    get :search, :q => "Mock Gameboy"
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_nil response_data['error']
    assert_equal Game.per_page, response_data['games'].length
  end

  test "search results are paginated" do
    get :search, :q => "Mock Gameboy", :per_page => 5
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_nil response_data['error']
    assert_equal 5, response_data['games'].length
    # There are 50 'Mock Gameboy' fixtures, so 10 pages of 5 per page
    assert_equal 10, response_data['total_pages']
  end

  test "show with a bogus id returns an error" do
    get :show, :id => 10000 # We should have less than 10000 game fixtures
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_not_nil response_data['error']
    assert_instance_of String, response_data['error']
  end

  test "show data includes id, console_id, name, and pictures" do
    oot = games(:zelda_ocarina_of_time)
    get :show, :id => oot.id
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_nil response_data['error']
    game = response_data['game']
    assert_equal oot.id, game['id']
    assert_equal oot.console_id, game['console_id']
    assert_equal oot.name, game['name']
    assert_equal oot.pictures.length, game['pictures'].length
    # Test that the picture data includes score and url
    picture = game['pictures'].first
    assert_include picture, 'score'
    assert_include picture, 'url'
  end

  test "top_rated_picture with a bogus id returns an error" do
    get :top_rated_picture, :id => 10000 # We should have less than 10000 game fixtures
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_not_nil response_data['error']
    assert_instance_of String, response_data['error']
  end

  test "top_rated_picture data is just a url" do
    get :top_rated_picture, :id => games(:zelda_ocarina_of_time).id
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_nil response_data['error']
    assert_includes response_data, 'url'
  end

end
