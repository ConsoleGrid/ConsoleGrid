ActiveAdmin.register Picture do
  filter :game_name, :as => :string
  filter :user, :as => :select
  filter :created_at, :as => :date_range
  
  index :as => :grid do |picture|
    a truncate(picture.game.name,:length => 38), :href => admin_game_path(picture.game)
    div do
      a :href => admin_picture_path(picture) do
        image_tag picture.image_url, :width => 214, :height => 100
      end
    end
    a "by " + picture.user.email, :href => admin_user_path(picture.user)
  end


  show do |picture|
    attributes_table do
      row :image do |picture|
        image_tag picture.image_url
      end
      row :id
      row :game
      row :user
      row :image_url
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end
