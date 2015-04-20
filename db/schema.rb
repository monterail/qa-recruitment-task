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

ActiveRecord::Schema.define(version: 20150419075132) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.integer  "owner_id"
    t.integer  "proposition_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "comments", ["owner_id"], name: "index_comments_on_owner_id", using: :btree
  add_index "comments", ["proposition_id"], name: "index_comments_on_proposition_id", using: :btree

  create_table "propositions", force: :cascade do |t|
    t.string   "title",       null: false
    t.text     "description"
    t.decimal  "value"
    t.boolean  "chosen"
    t.integer  "owner_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "jubilat_id"
  end

  create_table "users", force: :cascade do |t|
    t.string  "email",                       null: false
    t.string  "name",                        null: false
    t.string  "sso_id",                      null: false
    t.boolean "szama"
    t.text    "hobbies",        default: [],              array: true
    t.integer "birthday_month"
    t.integer "birthday_day"
  end

  add_index "users", ["sso_id"], name: "index_users_on_sso_id", using: :btree

end
