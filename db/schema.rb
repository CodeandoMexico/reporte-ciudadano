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

ActiveRecord::Schema.define(version: 20140211002335) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "name",                   limit: 255, default: "", null: false
    t.string   "avatar",                 limit: 255
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "authentication_token",   limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "admins", ["authentication_token"], name: "index_admins_on_authentication_token", unique: true, using: :btree
  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token", limit: 255
    t.integer  "admin_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "api_keys", ["access_token"], name: "index_api_keys_on_access_token", using: :btree
  add_index "api_keys", ["admin_id"], name: "index_api_keys_on_admin_id", using: :btree

  create_table "application_settings", force: :cascade do |t|
    t.string   "type",       limit: 255
    t.string   "value",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "application_settings", ["type"], name: "index_application_settings_on_type", unique: true, using: :btree

  create_table "authentications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider",   limit: 255
    t.string   "uid",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "authentications", ["user_id"], name: "index_authentications_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "content",                        default: ""
    t.integer  "service_request_id"
    t.integer  "commentable_id",                              null: false
    t.string   "commentable_type",   limit: 255,              null: false
    t.string   "ancestry",           limit: 255
    t.string   "image",              limit: 255
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "comments", ["ancestry"], name: "index_comments_on_ancestry", using: :btree
  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["service_request_id"], name: "index_comments_on_service_request_id", using: :btree

  create_table "logos", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "image",      limit: 255
    t.integer  "position"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text     "content"
    t.integer  "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "status_id"
  end

  add_index "messages", ["service_id"], name: "index_messages_on_service_id", using: :btree
  add_index "messages", ["status_id"], name: "index_messages_on_status_id", using: :btree

  create_table "service_fields", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "service_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "service_requests", force: :cascade do |t|
    t.text     "description",                default: ""
    t.string   "lat",            limit: 255, default: ""
    t.string   "lng",            limit: 255, default: ""
    t.boolean  "anonymous",                  default: false
    t.text     "service_fields",             default: "{}"
    t.text     "address",                    default: ""
    t.string   "media",          limit: 255
    t.integer  "service_id"
    t.integer  "requester_id",                               null: false
    t.string   "requester_type", limit: 255,                 null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "status_id"
  end

  add_index "service_requests", ["requester_id", "requester_type"], name: "index_service_requests_on_requester_id_and_requester_type", using: :btree
  add_index "service_requests", ["service_id"], name: "index_service_requests_on_service_id", using: :btree
  add_index "service_requests", ["status_id"], name: "index_service_requests_on_status_id", using: :btree

  create_table "services", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "is_default",             default: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "username",               limit: 255
    t.string   "avatar",                 limit: 255
    t.string   "email",                  limit: 255, default: ""
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "votes", force: :cascade do |t|
    t.boolean  "vote",                      default: false, null: false
    t.integer  "voteable_id",                               null: false
    t.string   "voteable_type", limit: 255,                 null: false
    t.integer  "voter_id"
    t.string   "voter_type",    limit: 255
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "votes", ["voteable_id", "voteable_type"], name: "index_votes_on_voteable_id_and_voteable_type", using: :btree
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], name: "fk_one_vote_per_user_per_entity", unique: true, using: :btree
  add_index "votes", ["voter_id", "voter_type"], name: "index_votes_on_voter_id_and_voter_type", using: :btree

end
