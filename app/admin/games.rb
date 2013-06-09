ActiveAdmin.register Game do
  index do
    id_column
    column "Name", :sortable => :name do |game|
      link_to game.name, admin_game_path(game)
    end
    column "Console" do |game|
      game.console.name
    end
    column :created_at
    default_actions
  end
end
