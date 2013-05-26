class PicturesController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    @picture = Picture.new
    @picture.game_id = params[:picture][:game_id]
    @picture.user = current_user
    @picture.save_image(params[:picture][:image])
    
    respond_to do |format|
      if @picture.save
        format.html { redirect_to @picture.game, :notice => 'Picture was successfully created.' }
      else
        format.html { redirect_to @picture.game, :alert => 'There was an error uploading your image. Please try again, or try a different image' }
      end
    end
  end
  
  def vote
    value = params[:type] == "up" ? 1 : -1
    @picture = Picture.find(params[:id])
    @picture.add_or_update_evaluation(:votes, value, current_user)
    redirect_to :back, :notice => "Thank you for voting"
  end
end
