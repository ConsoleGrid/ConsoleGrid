require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  setup do
    @game = games(:mock_gameboy_1)
  end

  test "should get index" do
    get :index, :q => "Zelda"
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game" do
    assert_difference('Game.count') do
      post :create, :game => { :name => @game.name }
    end

    assert_redirected_to game_path(assigns(:game))
  end

  test "should show game" do
    get :show, :id => @game
    assert_response :success
  end

  test "should destroy game" do
    assert_difference('Game.count', -1) do
      delete :destroy, :id => @game
    end

    assert_redirected_to games_path
  end
end
