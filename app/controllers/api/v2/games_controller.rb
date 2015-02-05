class Api::V2::GamesController < Api::V2::BaseApiController
  # Searches for games with names matching the query parameter `q`. Results
  # are paginated, and are ordered by relevance.
  #
  # Parameters:
  # q         - The query string to match games against
  # page      - The page of results to display, for pagination. If no page is
  #             specified then it defaults to 1
  # per_page  - The number of results to display per page, to be used in
  #             conjunction with the page parameter. Functionally equivalent
  #             to a 'limit' when page is 1
  def search
    raise Exceptions::APIError, "Missing search query. Did you forget to pass 'q='?" unless params.include? :q

    games = Game.easy_search(params[:q], :page => params[:page], :per_page => params[:per_page] )
    render :json => { :error => nil, :total_pages => games.total_pages, :games => games }, :methods => [:top_picture_url]
  end

  # Gets all information related to a single game. Along with metadata, this
  # includes all of the pictures that have been submitted for the game, along
  # with the pictures score and the current user's vote on that picture.
  #
  # Parameters: None
  def show
    id = params[:id]
    game = Game.find_by_id(id)
    raise Exceptions::APIError, "Unable to find Game with id '#{id}" if game.nil?

    # TODO: ORDER PICTURES BY SCORE
    render :json => { :error => nil, :game => game }, :include => {
      :pictures => {
        :only => [:image_url],
        :methods => [:score],
        # TODO: Right now we have no way of authenticating in the API, so
        # current_user will always be nil, resulting in a vote of 0. Better to
        # just not expose this field until after we have authentication
        # :vote_for_user => current_user,
      }
    }
  end

  # Gets the highest rated picture for a given game.
  #
  # Parameters: none
  def top_rated_picture
    id = params[:id]
    game = Game.find_by_id(id)
    raise Exceptions::APIError, "Unable to find Game with id '#{id}'" if game.nil?

    render :json => { :error => nil, :url => game.top_picture_url }
  end
end
