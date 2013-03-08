class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :initialize_crumbs
  
  def initialize_crumbs
    @breadcrumbs = []
    add_crumb("Home",root_path)
  end
  
  def add_crumb(title,link,index=-1)
    @breadcrumbs.insert(index,{:title => title, :link => link})
  end
end
