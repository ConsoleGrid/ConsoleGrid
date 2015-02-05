class Api::V1::ApiController < ApplicationController
  before_filter :set_cors_headers

  def set_cors_headers
    # We don't need to authenticate for this API endpoint, so there is no
    # point giving it the Allow-Credentials header. Since that is the case we
    # don't need to be restrictive about who we allow requests from, and can
    # just use '*'
    headers['Access-Control-Allow-Origin'] = '*'
  end

  def top_picture
    console_id = Console.find_by_shortname(params[:console]).id
    @matched_game = Game.easy_search(params[:game], :console_id => console_id).first
    # @matched_game = search.results.first
    if @matched_game.nil?
      # Respond with a 204 No Content, we couldn't find the game they wanted.
      head :no_content
    else
      # Find the top rated picture for the game
      @picture = @matched_game.top_rated_picture
      if @picture.nil?
        # If there are no pictures for the game, send an empty string
        render :text => ""
      else
        # Otherwise, if we found a game and it has a picture, send the imgur
        # link for the user to download
        render :text => @picture.image_url
      end
    end
  end
end
