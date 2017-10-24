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

ActiveRecord::Schema.define(version: 20171002155405) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "car_categories", force: :cascade do |t|
    t.string   "name"
    t.string   "initial"
    t.string   "logo"
    t.string   "parent_id"
    t.string   "depth"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "sizetype"
    t.string   "fullname"
    t.string   "keyword"
    t.string   "state"
    t.string   "translate_name"
  end

  add_index "car_categories", ["state", "depth"], name: "index_car_categories_on_state_and_depth", using: :btree

  create_table "cate_20170615_1", id: false, force: :cascade do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "initial"
    t.string   "logo"
    t.string   "parent_id"
    t.string   "depth"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sizetype"
    t.string   "fullname"
    t.string   "keyword"
    t.string   "state"
  end

  create_table "cate_20170619_1", id: false, force: :cascade do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "initial"
    t.string   "logo"
    t.string   "parent_id"
    t.string   "depth"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sizetype"
    t.string   "fullname"
    t.string   "keyword"
    t.string   "state"
    t.string   "translate_name"
  end

  create_table "downloaded_videos", force: :cascade do |t|
    t.string   "url"
    t.integer  "state",           default: 0, null: false
    t.string   "video_format"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "spyder_video_id"
  end

  add_index "downloaded_videos", ["spyder_video_id"], name: "index_downloaded_videos_on_spyder_video_id", using: :btree

  create_table "raw_comments", force: :cascade do |t|
    t.string   "comment_user"
    t.string   "avatar"
    t.string   "text"
    t.string   "key_word"
    t.integer  "user_id"
    t.string   "url"
    t.string   "state"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "raw_comments", ["user_id"], name: "index_raw_comments_on_user_id", using: :btree

  create_table "spyder_videos", force: :cascade do |t|
    t.string   "src"
    t.string   "name"
    t.string   "author"
    t.string   "pv"
    t.string   "video_duration"
    t.string   "key_word"
    t.string   "state"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.datetime "upload_time"
    t.string   "category"
    t.string   "translate_name"
    t.string   "category_str"
    t.string   "file_name"
    t.string   "file_type"
    t.string   "file_hash"
    t.string   "qiniu_url"
    t.string   "qiniu_thumb_url"
    t.integer  "user_id"
    t.string   "source_type"
  end

  add_index "spyder_videos", ["name", "video_duration"], name: "index_spyder_videos_on_name_and_video_duration", using: :btree
  add_index "spyder_videos", ["src"], name: "index_spyder_videos_on_src", using: :btree
  add_index "spyder_videos", ["state"], name: "index_spyder_videos_on_state", using: :btree
  add_index "spyder_videos", ["user_id"], name: "index_spyder_videos_on_user_id", using: :btree

  create_table "spyder_videos_20170908_1", id: false, force: :cascade do |t|
    t.integer  "id"
    t.string   "src"
    t.string   "name"
    t.string   "author"
    t.string   "pv"
    t.string   "video_duration"
    t.string   "key_word"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "upload_time"
    t.string   "category"
    t.string   "translate_name"
    t.string   "category_str"
    t.string   "file_name"
    t.string   "file_type"
    t.string   "file_hash"
    t.string   "qiniu_url"
    t.string   "qiniu_thumb_url"
    t.integer  "user_id"
    t.string   "source_type"
  end

  create_table "spyder_videos_20170908_modify_1", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.string  "author"
    t.string  "name"
    t.string  "translate_name"
    t.string  "qiniu_url"
  end

  create_table "spyders", force: :cascade do |t|
    t.string   "site"
    t.string   "keyword"
    t.datetime "begin_time"
    t.datetime "end_time"
    t.boolean  "active",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "page",       default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "mobile"
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "nick_name"
  end

  add_index "users", ["mobile"], name: "index_users_on_mobile", unique: true, using: :btree

  create_table "users_20170908_1", id: false, force: :cascade do |t|
    t.integer  "id"
    t.string   "mobile"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "downloaded_videos", "spyder_videos"
end
