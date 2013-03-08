class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  
  has_many :pictures
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
  has_many :evaluations, :class_name => "RSEvaluation", :as => :source
  
  def vote_for(picture)
    evaluation = ReputationSystem::Evaluation.find_by_reputation_name_and_source_and_target(:votes,self,picture)
    if evaluation.nil?
      0
    else
      evaluation.value
    end
  end
end