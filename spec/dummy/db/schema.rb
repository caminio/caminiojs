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

ActiveRecord::Schema.define(version: 20140712151957) do

  create_table "access_rules", force: true do |t|
    t.integer  "row_id"
    t.string   "row_type"
    t.integer  "group_id"
    t.integer  "label_id"
    t.integer  "user_id"
    t.boolean  "can_write",  default: false
    t.boolean  "can_share",  default: false
    t.boolean  "can_delete", default: false
    t.boolean  "is_owner",   default: false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "access_rules", ["row_id"], name: "index_access_rules_on_row_id"
  add_index "access_rules", ["row_type"], name: "index_access_rules_on_row_type"
  add_index "access_rules", ["user_id"], name: "index_access_rules_on_user_id"

  create_table "api_keys", force: true do |t|
    t.integer  "user_id"
    t.string   "access_token"
    t.datetime "expires_at"
  end

  add_index "api_keys", ["user_id"], name: "index_api_keys_on_user_id", unique: true

  create_table "app_plans", force: true do |t|
    t.integer  "price"
    t.integer  "app_id"
    t.integer  "users_amount", default: 1
    t.boolean  "visible",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_plans", ["app_id"], name: "index_app_plans_on_app_id", unique: true

  create_table "apps", force: true do |t|
    t.string  "path"
    t.boolean "is_public"
  end

  create_table "labels", force: true do |t|
    t.string   "name"
    t.string   "color"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "deleted_at"
    t.integer  "deleted_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "labels", ["name"], name: "index_labels_on_name"

  create_table "messages", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "followup_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "deleted_at"
    t.integer  "deleted_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["created_by"], name: "index_messages_on_created_by"
  add_index "messages", ["followup_id"], name: "index_messages_on_followup_id"

  create_table "oauth_access_grants", force: true do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true

  create_table "oauth_access_tokens", force: true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true

  create_table "oauth_applications", force: true do |t|
    t.string   "name",         null: false
    t.string   "uid",          null: false
    t.string   "secret",       null: false
    t.text     "redirect_uri", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true

  create_table "organizational_unit_app_plans", force: true do |t|
    t.integer "app_plan_id"
    t.integer "organizational_unit_id"
  end

  add_index "organizational_unit_app_plans", ["app_plan_id"], name: "index_organizational_unit_app_plans_on_app_plan_id"
  add_index "organizational_unit_app_plans", ["organizational_unit_id"], name: "index_organizational_unit_app_plans_on_organizational_unit_id"

  create_table "organizational_unit_members", force: true do |t|
    t.integer  "user_id"
    t.integer  "organizational_unit_id"
    t.integer  "access_level",           default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organizational_unit_members", ["organizational_unit_id"], name: "index_organizational_unit_members_on_organizational_unit_id"
  add_index "organizational_unit_members", ["user_id"], name: "index_organizational_unit_members_on_user_id"

  create_table "organizational_units", force: true do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.string   "color"
    t.text     "settings"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "row_labels", force: true do |t|
    t.integer "label_id"
    t.integer "row_id"
    t.string  "row_type"
  end

  add_index "row_labels", ["row_id"], name: "index_row_labels_on_row_id"
  add_index "row_labels", ["row_type"], name: "index_row_labels_on_row_type"

  create_table "translations", force: true do |t|
    t.string   "locale"
    t.string   "title"
    t.string   "subtitle"
    t.text     "aside"
    t.text     "aside2"
    t.text     "aside3"
    t.text     "content"
    t.text     "description"
    t.string   "keywords"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "phone"
    t.string   "categories"
    t.datetime "last_login_at"
    t.datetime "last_request_at"
    t.string   "last_login_ip"
    t.string   "password_digest"
    t.string   "confirmation_key"
    t.datetime "confirmation_key_expires_at"
    t.string   "public_key"
    t.string   "private_key"
    t.boolean  "api_user",                    default: false
    t.text     "settings"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["categories"], name: "index_users_on_categories"
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["private_key"], name: "index_users_on_private_key", unique: true
  add_index "users", ["public_key"], name: "index_users_on_public_key", unique: true

end
