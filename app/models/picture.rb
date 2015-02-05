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

  def score()
    self.reputation_for(:votes).to_i
  end

  def serializable_hash(options)
    # Override which gives access to the `vote_for_user` property, which takes
    # a User object and returns +1, -1, or 0 based on whether the user upvoted,
    # downvoted, or didnt vote on a picture (respectively)
    hash = super(options)
    hash[:vote] = self.user_vote(options[:vote_for_user]) if options.include? :vote_for_user
    # Rename the 'image_url' parameter to a better user-facing name. In this
    # case, just 'url'
    hash[:url] = hash.delete "image_url" if hash.include? "image_url"
    return hash
  end

  def as_json(options={})
    default_options = {
      :only => [
        :image_url,
      ]
    }
    super(default_options.merge(options))
  end
end
