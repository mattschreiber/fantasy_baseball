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

ActiveRecord::Schema.define(version: 20160711135948) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "owners", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "team_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_seasons", force: :cascade do |t|
    t.integer  "year"
    t.integer  "place"
    t.integer  "run_points"
    t.integer  "hr_points"
    t.integer  "rbi_points"
    t.integer  "sb_points"
    t.integer  "avg_points"
    t.integer  "win_points"
    t.integer  "k_points"
    t.integer  "sv_points"
    t.integer  "whip_points"
    t.integer  "era_points"
    t.integer  "total_run"
    t.integer  "total_hr"
    t.integer  "total_rbi"
    t.integer  "total_sb"
    t.integer  "total_avg"
    t.integer  "total_win"
    t.integer  "total_k"
    t.integer  "total_sv"
    t.integer  "total_whip"
    t.integer  "total_era"
    t.integer  "owner_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "team_seasons", ["owner_id"], name: "index_team_seasons_on_owner_id", using: :btree

  add_foreign_key "team_seasons", "owners"
end
