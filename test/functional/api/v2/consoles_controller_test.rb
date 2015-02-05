require 'test_helper'

class Api::V2::ConsolesControllerTest < ActionController::TestCase
  setup do
    # Index the Console fixtures for testing
    Console.reindex
  end

  test "list should return all consoles" do
    get :list
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_nil response_data['error']
    consoles = response_data['consoles']
    assert_not_nil consoles
    # There are 10 consoles in my fixtures
    assert_equal 10, consoles.length
  end

  test "list results are ordered by name" do
    get :list
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_nil response_data['error']
    consoles = response_data['consoles']
    # N64 is the first alphabetically
    assert_equal consoles(:n64).id, consoles.first['id']
    # And Super Nintendo is last
    assert_equal consoles(:snes).id, consoles.last['id']
  end

  test "hitting list with q parameter acts as search" do
    get :list, :q => "Nintendo"
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_nil response_data['error']
    consoles = response_data['consoles']
    assert_not_nil consoles
    assert consoles.length < 10, "Not EVERY console is a relevant search result"
    assert consoles.length > 0, "But at least SOME are"
  end

  test "search with no query returns error" do
    get :search
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_not_nil response_data['error']
    assert_instance_of String, response_data['error']
  end

  test "search with query returns results" do
    get :search, :q => "Nintendo"
    # Exactly the same as the list redirect test
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_nil response_data['error']
    consoles = response_data['consoles']
    assert_not_nil consoles
    assert consoles.length < 10, "Not EVERY console is a relevant search result"
    assert consoles.length > 0, "But at least SOME are"
  end

  test "search results are paginated" do
    get :search, :q => "Sony", :per_page => 1
    # Exactly the same as the list redirect test
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_nil response_data['error']
    # We set 'per_page' to 1, so we should only get one result
    assert_equal 1, response_data['consoles'].length
    # But there are 2 Sony console fixtures, so 'total_pages' should be 2
    assert_equal 2, response_data['total_pages']
  end

  test "show with a bogus console id returns an error" do
    get :show, :id => 10000 # I'm assuming I dont have 10000 console fixtures
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_not_nil response_data['error']
    assert_instance_of String, response_data['error']
  end

  test "show displays information about the console" do
    gameboy = consoles(:gameboy)
    get :show, :id => gameboy.id
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_nil response_data['error']
    returned_console = response_data['console']
    assert_not_nil returned_console
    assert_equal returned_console['id'], gameboy.id
    assert_equal returned_console['name'], gameboy.name
    assert_equal returned_console['shortname'], gameboy.shortname
  end

  test "games with a bogus console id returns an error" do
    get :games, :id => 10000 # I'm assuming I dont have 10000 console fixtures
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_not_nil response_data['error']
    assert_instance_of String, response_data['error']
  end

  test "games returns list of non-duplicate games" do
    n64 = consoles(:n64)
    get :games, :id => n64.id
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_nil response_data['error']
    assert_equal response_data['total_pages'], 1
    # There are only two non-duplicate games for N64
    assert_equal response_data['games'].length, 2
  end

  test "games results are paginated" do
    gameboy = consoles(:gameboy)
    get :games, :id => gameboy.id, :per_page => 5
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_nil response_data['error']
    # There are 50 gameboy games in the fixtures
    assert_equal response_data['total_pages'], 10
    assert_equal response_data['games'].length, 5
  end

  test "games naturally limits page length to Game.per_page when per_page is missing" do
    gameboy = consoles(:gameboy)
    get :games, :id => gameboy.id
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_nil response_data['error']
    assert_equal response_data['games'].length, Game.per_page
  end

  test "games results are ordered by name" do
    n64 = consoles(:n64)
    get :games, :id => n64.id
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_nil response_data['error']
    games = response_data['games']
    assert_equal games[0]['id'], games(:zelda_majoras_mask).id
    assert_equal games[1]['id'], games(:zelda_ocarina_of_time).id
  end

  test "game results includes id, name, and top picture url" do
    n64 = consoles(:n64)
    get :games, :id => n64.id
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_nil response_data['error']
    game = response_data['games'].first
    assert_includes game, 'id'
    assert_includes game, 'name'
    assert_includes game, 'top_picture_url'
  end
end
