class ApiController < ApplicationController
  def top_picture
    console_id = Console.find_by_shortname(params[:console]).id
    if console_id.nil?
      @matched_game = Game.search(params[:game]).order("LENGTH(name)").limit(1).first
      logger.debug @matched_game.name
    else
      @matched_game = Game.search(params[:game]).where(:console_id => console_id).order("LENGTH(name)").limit(1).first
      logger.debug "Console: " + console_id.to_s + " Game: " + @matched_game.name
    end
    if @matched_game.nil?
      # Respond with a 404, we couldn't find the game they wanted.
      render :nothing => true, :status => 404
    else
      # Print the name of the game that was found (DEBUGGING)
      # render :text => @matched_game.name
      # return
      # Find the top rated picture for the game
      @picture = @matched_game.top_rated_picture
      if @picture.nil?
        # If there are no pictures for the game, send a 204 No Content.
        head :no_content
      else
        # Otherwise, if we found a game and it has a picture, send the imgur
        # link for the user to download
        render :text => @picture.image_url
      end
    end
  end
end
