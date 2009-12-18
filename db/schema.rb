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

ActiveRecord::Schema.define(:version => 20090905233240) do

  create_table "events", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "description"
    t.string   "url"
    t.string   "last_updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id",      :default => 0
  end

  create_table "events_users", :id => false, :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.string   "last_updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "twitter_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "profile_image_url"
  end

end
