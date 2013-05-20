class ApiController < ApplicationController
  def top_picture
    console_id = Console.find_by_shortname(params[:console]).id
    if console_id.nil?
      search = Game.search do
        fulltext params[:game]
        paginate :page => 1, :per_page => 1
      end
    else
      search = Game.search do
        fulltext params[:game]
        with :console_id, console_id
        paginate :page => 1, :per_page => 1
      end
    end
    @matched_game = search.results.first
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
