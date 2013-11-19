ActiveAdmin.register Console do
  config.sort_order = "name_asc"

  index do
    column("Name", :sortable => :name) {|console| link_to console.name, admin_console_path(console) }
    column("Shortname", :sortable => :shortname) {|console| link_to console.shortname, admin_console_path(console) }
    default_actions
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :name
      f.input :shortname
    end
    f.actions
  end
end
