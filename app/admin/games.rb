ActiveAdmin.register Game do
  scope :all, :default => true
  scope :duplicates
  
  index do
    id_column
    column("Name", :sortable => :name) {|game| link_to game.name, admin_game_path(game) }
    column("Console") {|game| game.console.name }
    column "Duplicate", :sortable => :duplicate do |game|
      if game.duplicate
        status_tag("Duplicate", :error)
      else 
        status_tag "Unique"
      end      
    end
    column :created_at
    default_actions
  end
  
  show do |game|
    attributes_table do
      row :id
      row :name
      row :console
      row :duplicate do |game|
        if game.duplicate
          status_tag("Duplicate", :error)
        else 
          status_tag "Unique"
        end
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
  
  sidebar "Pictures", :width => "460px", :only => :show do
    game.pictures.each do |picture|
      div do
        img :src => picture.image_url, :width => "240px", :height => "113px"
      end
    end
  end
end
