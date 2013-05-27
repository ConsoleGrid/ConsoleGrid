class ApiController < ApplicationController
  def top_picture
    console_id = Console.find_by_shortname(params[:console]).id
    @matched_game = Game.easy_search(params[:game], 1, :per_page => 1, :console_id => console_id).first
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
