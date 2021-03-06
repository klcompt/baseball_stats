# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130223022913) do

  create_table "players", :force => true do |t|
    t.string  "player_key"
    t.integer "birth_year"
    t.string  "last_name"
    t.string  "first_name"
  end

  create_table "stats", :force => true do |t|
    t.integer "player_id"
    t.integer "year"
    t.string  "team_id"
    t.integer "game",            :default => 0
    t.integer "at_bats",         :default => 0
    t.integer "runs",            :default => 0
    t.integer "hits",            :default => 0
    t.integer "doubles",         :default => 0
    t.integer "triples",         :default => 0
    t.integer "home_runs",       :default => 0
    t.integer "runs_batted_in",  :default => 0
    t.integer "stolen_bases",    :default => 0
    t.integer "caught_stealing", :default => 0
  end

  add_index "stats", ["player_id"], :name => "index_stats_on_player_id"
  add_index "stats", ["team_id"], :name => "index_stats_on_team_id"
  add_index "stats", ["year"], :name => "index_stats_on_year"

end
