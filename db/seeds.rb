# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

Console.create([
  {:name => 'Nintendo Entertainment System', :shortname => 'NES'},
  {:name => 'Super Nintendo', :shortname => 'SNES'},
  {:name => 'Nintendo 64', :shortname => 'N64'},
  {:name => 'Nintendo Gamecube', :shortname => 'Gamecube'},
  {:name => 'Playstation', :shortname => 'PS1'},
  {:name => 'Playstation 2', :shortname => 'PS2'},
  {:name => 'Sega Genesis', :shortname => 'Genesis'},
  # {:name => 'Sega Dreamcast', :shortname => 'Dreamcast'},
  {:name => 'Gameboy', :shortname => 'Gameboy'},
  {:name => 'Gameboy Advance', :shortname => 'GBA'}
])


# Seed the database with the game data from db/seeds/{CONSOLE}.json
Console.all.each do |console|
  puts "Seeding console: " + console.name
  filename = console.shortname + ".json"
  filepath = File.join('db','seed',filename)
  if File.exist?(filepath)
    File.open(filepath,'r') do |f|
      games = JSON.parse(f.read)
      games.each do |game|
        current = Game.new(:name => game)
        current.console = console
        current.save
      end
    end
  end
end

puts "Indexing with Solr"
Game.reindex