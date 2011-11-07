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

ActiveRecord::Schema.define(:version => 20110115111130) do

  create_table "blocked_users", :force => true do |t|
    t.integer  "user_id",         :null => false
    t.integer  "blocked_user_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id",                            :null => false
    t.text     "text",                               :null => false
    t.integer  "resource_id"
    t.string   "resource_type", :default => "Stone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dedications", :force => true do |t|
    t.integer  "stone_id",                            :null => false
    t.integer  "user_id",                             :null => false
    t.boolean  "unread",            :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dedicated_user_id"
  end

  create_table "deleted_messages", :force => true do |t|
    t.integer  "message_id", :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorite_stacks", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "stack_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorite_stones", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "stone_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorite_users", :force => true do |t|
    t.integer  "user_id",          :null => false
    t.integer  "favorite_user_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flagged_stones", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "stone_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "followed_users", :force => true do |t|
    t.integer  "user_id",          :null => false
    t.integer  "followed_user_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.text     "text",       :null => false
    t.string   "subject",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "read_messages", :force => true do |t|
    t.integer  "message_id", :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipients", :id => false, :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "message_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stack_votes", :force => true do |t|
    t.integer  "stack_id",   :null => false
    t.integer  "user_id",    :null => false
    t.integer  "rating",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stacked_stones", :force => true do |t|
    t.integer  "stone_id",   :null => false
    t.integer  "stack_id",   :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stacks", :force => true do |t|
    t.integer  "user_id",                                 :null => false
    t.string   "name",                                    :null => false
    t.integer  "stones_count",             :default => 0
    t.integer  "votes_count",              :default => 0
    t.integer  "comments_count",           :default => 0
    t.integer  "views_count",              :default => 0
    t.integer  "favorited_by_users_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stone_votes", :force => true do |t|
    t.integer  "stone_id",   :null => false
    t.integer  "user_id",    :null => false
    t.integer  "rating",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stones", :force => true do |t|
    t.integer  "user_id",                                 :null => false
    t.integer  "favorited_by_users_count", :default => 0
    t.integer  "votes_count",              :default => 0
    t.integer  "views_count",              :default => 0
    t.integer  "flags_count",              :default => 0
    t.integer  "comments_count",           :default => 0
    t.integer  "stacks_count",             :default => 0
    t.text     "engraving",                               :null => false
    t.float    "latitude",                                :null => false
    t.float    "longitude",                               :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                                        :null => false
    t.string   "surname",                                     :null => false
    t.datetime "birthday"
    t.string   "hometown"
    t.string   "current_city"
    t.integer  "gender",                   :default => 0
    t.text     "informations"
    t.string   "website"
    t.boolean  "share_email",              :default => true,  :null => false
    t.boolean  "share_birthday",           :default => true,  :null => false
    t.integer  "followers_count",          :default => 0
    t.integer  "favorite_users_count",     :default => 0
    t.integer  "followed_users_count",     :default => 0
    t.integer  "favorited_by_users_count", :default => 0
    t.integer  "blocked_users_count",      :default => 0
    t.integer  "blocked_by_users_count",   :default => 0
    t.integer  "stones_count",             :default => 0
    t.integer  "comments_count",           :default => 0
    t.integer  "favorite_stones_count",    :default => 0
    t.integer  "stone_votes_count",        :default => 0
    t.integer  "viewed_stones_count",      :default => 0
    t.integer  "stacks_count",             :default => 0
    t.integer  "favorite_stacks_count",    :default => 0
    t.integer  "stack_votes_count",        :default => 0
    t.integer  "viewed_stacks_count",      :default => 0
    t.string   "email",                                       :null => false
    t.string   "crypted_password",                            :null => false
    t.string   "password_salt",                               :null => false
    t.string   "persistence_token",                           :null => false
    t.string   "single_access_token",                         :null => false
    t.string   "perishable_token",                            :null => false
    t.boolean  "active",                   :default => false, :null => false
    t.integer  "login_count",              :default => 0,     :null => false
    t.integer  "failed_login_count",       :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "viewed_stacks", :force => true do |t|
    t.integer  "stack_id",   :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "viewed_stones", :force => true do |t|
    t.integer  "stone_id",   :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
