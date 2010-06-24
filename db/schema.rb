# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100623233300) do

  create_table "associated_account_types", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "associated_accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "username"
    t.integer  "associated_account_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "url"
    t.string   "last_updated_by"
    t.integer  "creator_id",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events_search_terms", :id => false, :force => true do |t|
    t.integer  "event_id"
    t.integer  "search_term_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events_users", :id => false, :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.string   "last_updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "event_id"
    t.string   "original_id"
    t.string   "from_user"
    t.string   "origin_url"
    t.string   "text"
    t.string   "profile_image_url"
    t.datetime "created"
    t.string   "source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_terms", :force => true do |t|
    t.string   "term"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "ec_username"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "profile_image_url"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
