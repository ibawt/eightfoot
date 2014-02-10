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

ActiveRecord::Schema.define(version: 20140209140830) do

  create_table "issues", force: true do |t|
    t.integer "repository_id"
    t.integer "project_id"
    t.integer "position"
    t.integer "gh_id",         limit: 8
  end

  add_index "issues", ["project_id", "gh_id"], name: "index_issues_on_project_id_and_gh_id", using: :btree
  add_index "issues", ["project_id", "position"], name: "index_issues_on_project_id_and_position", using: :btree
  add_index "issues", ["repository_id"], name: "index_issues_on_repository_id", using: :btree

  create_table "project_repositories", force: true do |t|
    t.integer "project_id"
    t.integer "repository_id"
  end

  add_index "project_repositories", ["project_id"], name: "index_project_repositories_on_project_id", using: :btree
  add_index "project_repositories", ["repository_id"], name: "index_project_repositories_on_repository_id", using: :btree

  create_table "projects", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gh_id",      limit: 8
  end

  create_table "repositories", force: true do |t|
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "nickname"
    t.string   "github_uid"
    t.string   "image"
    t.string   "token"
    t.boolean  "expires"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
