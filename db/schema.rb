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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170221143016) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "battings", force: :cascade do |t|
    t.integer  "year"
    t.integer  "games"
    t.integer  "ab"
    t.integer  "runs"
    t.integer  "hits"
    t.integer  "double"
    t.integer  "triple"
    t.integer  "hr"
    t.integer  "rbi"
    t.integer  "sb"
    t.integer  "cs"
    t.integer  "bb"
    t.integer  "so"
    t.integer  "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "average"
    t.integer  "mlbteam_id"
  end

  add_index "battings", ["mlbteam_id"], name: "index_battings_on_mlbteam_id", using: :btree
  add_index "battings", ["player_id"], name: "index_battings_on_player_id", using: :btree

  create_table "mlbteams", force: :cascade do |t|
    t.string   "abbr"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "owners", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "team_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "abbr"
  end

  create_table "pitchings", force: :cascade do |t|
    t.integer  "year"
    t.integer  "wins"
    t.integer  "loss"
    t.integer  "games"
    t.integer  "gs"
    t.float    "innings"
    t.integer  "cg"
    t.integer  "shutouts"
    t.integer  "sv"
    t.integer  "hits"
    t.integer  "er"
    t.integer  "hr"
    t.integer  "bb"
    t.integer  "so"
    t.float    "ba_opp"
    t.float    "era"
    t.float    "whip"
    t.integer  "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "mlbteam_id"
  end

  add_index "pitchings", ["mlbteam_id"], name: "index_pitchings_on_mlbteam_id", using: :btree
  add_index "pitchings", ["player_id"], name: "index_pitchings_on_player_id", using: :btree

  create_table "player_rankings", force: :cascade do |t|
    t.integer  "my_rank"
    t.integer  "espn"
    t.integer  "cbs"
    t.integer  "mlb"
    t.integer  "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "player_rankings", ["player_id"], name: "index_player_rankings_on_player_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birthday"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "avail"
    t.boolean  "batter"
    t.integer  "owner_id"
  end

  add_index "players", ["owner_id"], name: "index_players_on_owner_id", using: :btree

  create_table "players_positions", force: :cascade do |t|
    t.integer "position_id"
    t.integer "player_id"
  end

  add_index "players_positions", ["player_id"], name: "index_players_positions_on_player_id", using: :btree
  add_index "players_positions", ["position_id"], name: "index_players_positions_on_position_id", using: :btree

  create_table "positions", force: :cascade do |t|
    t.string   "pos"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_seasons", force: :cascade do |t|
    t.integer  "year"
    t.integer  "place"
    t.float    "run_points"
    t.float    "hr_points"
    t.float    "rbi_points"
    t.float    "sb_points"
    t.float    "avg_points"
    t.float    "win_points"
    t.float    "k_points"
    t.float    "sv_points"
    t.float    "whip_points"
    t.float    "era_points"
    t.integer  "total_run"
    t.integer  "total_hr"
    t.integer  "total_rbi"
    t.integer  "total_sb"
    t.float    "total_avg"
    t.integer  "total_win"
    t.integer  "total_k"
    t.integer  "total_sv"
    t.float    "total_whip"
    t.float    "total_era"
    t.float    "total_points"
    t.integer  "owner_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.boolean  "current_season"
    t.float    "innings"
    t.integer  "gp"
  end

  add_index "team_seasons", ["owner_id"], name: "index_team_seasons_on_owner_id", using: :btree

  create_table "years", force: :cascade do |t|
    t.integer  "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "battings", "mlbteams"
  add_foreign_key "battings", "players"
  add_foreign_key "pitchings", "mlbteams"
  add_foreign_key "pitchings", "players"
  add_foreign_key "player_rankings", "players"
  add_foreign_key "players", "owners"
  add_foreign_key "players_positions", "players"
  add_foreign_key "players_positions", "positions"
  add_foreign_key "team_seasons", "owners"
end
