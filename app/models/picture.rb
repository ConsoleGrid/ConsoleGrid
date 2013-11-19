class Picture < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  attr_accessible :image_url
  attr_accessible :game_id, :user_id, :image_url, :as => :admin
  
  validates_presence_of :game,:user,:image_url
  
  has_reputation :votes, :source => :user, :aggregated_by => :sum
  
  def save_image(image)
    imgur = Imgur::API.new('dc3a429ef78358381910d28657f4b301')
    # Should return a hash like this
    # {     
    #       "small_thumbnail"=>"http://imgur.com/NfuKFs.png", 
    #       "original_image"=>"http://imgur.com/NfuKF.png", 
    #       "large_thumbnail"=>"http://imgur.com/NfuKFl.png", 
    #       "delete_hash"=>"VAiPkk5NoQ", "imgur_page"=>"http://imgur.com/NfuKF", 
    #       "delete_page"=>"http://imgur.com/delete/VAiPkk5NoQ", 
    #       "image_hash"=>"NfuKF"
    # }
    begin
      uploaded_img = imgur.upload_file image.tempfile.path
      self.image_url = uploaded_img["original_image"]
    rescue StandardError => error
      logger.warn "@ ======================== @"
      logger.warn "@ Error uploading image... @"
      logger.warn "@ ======================== @"
    end
  end
  
  def user_vote(user)
    if user.nil?
      return 0
    else
      return user.vote_for(self)
    end
  end
end
