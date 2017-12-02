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

ActiveRecord::Schema.define(version: 20171128194256) do

  create_table "spyder_articles", force: :cascade do |t|
    t.integer  "spyder_id",  limit: 4
    t.string   "title",      limit: 255
    t.string   "url",        limit: 255
    t.string   "author",     limit: 255
    t.string   "summary",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "spyder_articles", ["spyder_id"], name: "index_spyder_articles_on_spyder_id", using: :btree

  create_table "spyder_videos", force: :cascade do |t|
    t.string   "src",             limit: 255
    t.string   "name",            limit: 255
    t.string   "author",          limit: 255
    t.string   "pv",              limit: 255
    t.string   "video_duration",  limit: 255
    t.string   "key_word",        limit: 255
    t.string   "state",           limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.datetime "upload_time"
    t.string   "category",        limit: 255
    t.string   "translate_name",  limit: 255
    t.string   "category_str",    limit: 255
    t.string   "file_name",       limit: 255
    t.string   "file_type",       limit: 255
    t.string   "file_hash",       limit: 255
    t.string   "qiniu_url",       limit: 255
    t.string   "qiniu_thumb_url", limit: 255
    t.integer  "user_id",         limit: 4
    t.string   "source_type",     limit: 255
    t.integer  "spyder_id",       limit: 4
  end

  add_index "spyder_videos", ["name", "video_duration"], name: "index_spyder_videos_on_name_and_video_duration", using: :btree
  add_index "spyder_videos", ["spyder_id"], name: "index_spyder_videos_on_spyder_id", using: :btree
  add_index "spyder_videos", ["src"], name: "index_spyder_videos_on_src", using: :btree
  add_index "spyder_videos", ["state"], name: "index_spyder_videos_on_state", using: :btree
  add_index "spyder_videos", ["user_id"], name: "index_spyder_videos_on_user_id", using: :btree

  create_table "spyders", force: :cascade do |t|
    t.string   "site",       limit: 255
    t.string   "keyword",    limit: 255
    t.datetime "begin_time"
    t.datetime "end_time"
    t.boolean  "active",                 default: true
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "page",       limit: 4,   default: 0
    t.string   "open_id",    limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "mobile",     limit: 255
    t.string   "token",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "nick_name",  limit: 255
  end

  add_index "users", ["mobile"], name: "index_users_on_mobile", unique: true, using: :btree

end
