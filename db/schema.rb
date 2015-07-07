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

ActiveRecord::Schema.define(version: 20150706042915) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "name",                   default: "",    null: false
    t.string   "avatar"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_service_admin"
    t.string   "record_number"
    t.string   "dependency"
    t.string   "administrative_unit"
    t.string   "charge"
    t.boolean  "is_public_servant"
    t.boolean  "disabled",               default: false
    t.boolean  "active",                 default: false
  end

  add_index "admins", ["authentication_token"], name: "index_admins_on_authentication_token", unique: true, using: :btree
  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "admins_services", force: :cascade do |t|
    t.integer "admin_id",   null: false
    t.integer "service_id", null: false
  end

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token"
    t.integer  "admin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "api_keys", ["access_token"], name: "index_api_keys_on_access_token", using: :btree
  add_index "api_keys", ["admin_id"], name: "index_api_keys_on_admin_id", using: :btree

  create_table "application_settings", force: :cascade do |t|
    t.string   "type"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "application_settings", ["type"], name: "index_application_settings_on_type", unique: true, using: :btree

  create_table "authentications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["user_id"], name: "index_authentications_on_user_id", using: :btree

  create_table "cis_reports", force: :cascade do |t|
    t.integer  "cis_id"
    t.decimal  "positive_overall_perception"
    t.decimal  "negative_overall_perception"
    t.integer  "respondents_count"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.text     "overall_areas"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content",            default: ""
    t.integer  "service_request_id"
    t.integer  "commentable_id",                  null: false
    t.string   "commentable_type",                null: false
    t.string   "ancestry"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["ancestry"], name: "index_comments_on_ancestry", using: :btree
  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["service_request_id"], name: "index_comments_on_service_request_id", using: :btree

  create_table "logos", force: :cascade do |t|
    t.string   "title"
    t.string   "image"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: :cascade do |t|
    t.text     "content"
    t.integer  "service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id"
  end

  add_index "messages", ["service_id"], name: "index_messages_on_service_id", using: :btree
  add_index "messages", ["status_id"], name: "index_messages_on_status_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.decimal  "value"
    t.string   "criterion"
    t.text     "text"
    t.string   "answer_type"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.text     "answers"
    t.integer  "service_survey_id"
    t.string   "answer_rating_range"
  end

  add_index "questions", ["service_survey_id"], name: "index_questions_on_service_survey_id", using: :btree

  create_table "service_fields", force: :cascade do |t|
    t.string   "name"
    t.integer  "service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_requests", force: :cascade do |t|
    t.text     "description",    default: ""
    t.boolean  "anonymous",      default: false
    t.text     "service_fields", default: "{}"
    t.text     "address",        default: ""
    t.string   "media"
    t.integer  "service_id"
    t.integer  "requester_id",                   null: false
    t.string   "requester_type",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id"
    t.string   "cis"
  end

  add_index "service_requests", ["requester_id", "requester_type"], name: "index_service_requests_on_requester_id_and_requester_type", using: :btree
  add_index "service_requests", ["service_id"], name: "index_service_requests_on_service_id", using: :btree
  add_index "service_requests", ["status_id"], name: "index_service_requests_on_status_id", using: :btree

  create_table "service_survey_reports", force: :cascade do |t|
    t.integer  "service_survey_id"
    t.float    "positive_overall_perception", default: 0.0, null: false
    t.float    "negative_overall_perception", default: 0.0, null: false
    t.integer  "people_who_participated",     default: 0,   null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.text     "areas_results"
  end

  add_index "service_survey_reports", ["service_survey_id"], name: "index_service_survey_reports_on_service_survey_id", using: :btree

  create_table "service_surveys", force: :cascade do |t|
    t.string   "title"
    t.string   "phase"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "admin_id"
    t.boolean  "open",       default: false
  end

  add_index "service_surveys", ["admin_id"], name: "index_service_surveys_on_admin_id", using: :btree

  create_table "services", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "service_type"
    t.string   "dependency"
    t.string   "administrative_unit"
    t.text     "cis"
    t.integer  "service_admin_id"
  end

  add_index "services", ["service_admin_id"], name: "index_services_on_service_admin_id", using: :btree

  create_table "services_service_surveys", force: :cascade do |t|
    t.integer "service_id",        null: false
    t.integer "service_survey_id", null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_default", default: false
  end

  create_table "survey_answers", force: :cascade do |t|
    t.string   "text"
    t.integer  "question_id"
    t.decimal  "score"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "survey_answers", ["question_id"], name: "index_survey_answers_on_question_id", using: :btree
  add_index "survey_answers", ["user_id"], name: "index_survey_answers_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "username"
    t.string   "avatar"
    t.string   "email",                  default: ""
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_observer"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "votes", force: :cascade do |t|
    t.boolean  "vote",          default: false, null: false
    t.integer  "voteable_id",                   null: false
    t.string   "voteable_type",                 null: false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], name: "index_votes_on_voteable_id_and_voteable_type", using: :btree
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], name: "fk_one_vote_per_user_per_entity", unique: true, using: :btree
  add_index "votes", ["voter_id", "voter_type"], name: "index_votes_on_voter_id_and_voter_type", using: :btree

  add_foreign_key "questions", "service_surveys"
  add_foreign_key "service_surveys", "admins"
  add_foreign_key "survey_answers", "questions"
  add_foreign_key "survey_answers", "users"
end
