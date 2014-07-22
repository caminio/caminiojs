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

  create_table "api_keys", force: true do |t|
    t.integer  "user_id"
    t.string   "access_token"
    t.datetime "expires_at"
  end

  create_table "circles", force: true do |t|
    t.integer  "user_id"
    t.boolean  "follow",     default: false
    t.text     "settings"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "circles", ["user_id"], name: "index_circles_on_user_id"

  create_table "domains", force: true do |t|
    t.string   "name"
    t.string   "qualified_name"
    t.integer  "role",            default: 50
    t.boolean  "suspended",       default: false
    t.boolean  "superuser",       default: false
    t.datetime "last_login_at"
    t.datetime "last_request_at"
    t.string   "last_login_ip"
    t.text     "app_ids"
    t.string   "password_digest"
    t.text     "settings"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "domains", ["name"], name: "index_domains_on_name", unique: true
  add_index "domains", ["qualified_name"], name: "index_domains_on_qualified_name", unique: true

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

  create_table "subscriptions", force: true do |t|
    t.string   "obj_type"
    t.integer  "obj_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["obj_id"], name: "index_subscriptions_on_obj_id"

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "phone"
    t.string   "categories"
    t.integer  "access_level",                default: 50
    t.boolean  "suspended",                   default: false
    t.boolean  "superuser",                   default: false
    t.datetime "last_login_at"
    t.datetime "last_request_at"
    t.string   "last_login_ip"
    t.text     "app_ids"
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
