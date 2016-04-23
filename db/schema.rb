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

ActiveRecord::Schema.define(version: 20160423112541) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer  "user_id",        null: false
    t.date     "anniversary_on"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "accounts", ["user_id"], name: "index_accounts_on_user_id", using: :btree

  create_table "attachments", force: :cascade do |t|
    t.integer  "comment_id", null: false
    t.string   "file_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "attachments", ["comment_id"], name: "index_attachments_on_comment_id", using: :btree

  create_table "boards", force: :cascade do |t|
    t.integer  "project_id", null: false
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "boards", ["project_id"], name: "index_boards_on_project_id", using: :btree

  create_table "boards_tickets", id: false, force: :cascade do |t|
    t.integer "board_id",  null: false
    t.integer "ticket_id", null: false
  end

  add_index "boards_tickets", ["board_id", "ticket_id"], name: "index_boards_tickets_on_board_id_and_ticket_id", using: :btree
  add_index "boards_tickets", ["board_id"], name: "index_boards_tickets_on_board_id", using: :btree
  add_index "boards_tickets", ["ticket_id"], name: "index_boards_tickets_on_ticket_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "ticket_id",    null: false
    t.integer  "commenter_id"
    t.integer  "status_id"
    t.text     "message"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "comments", ["commenter_id"], name: "index_comments_on_commenter_id", using: :btree
  add_index "comments", ["status_id"], name: "index_comments_on_status_id", using: :btree
  add_index "comments", ["ticket_id"], name: "index_comments_on_ticket_id", using: :btree

  create_table "members", force: :cascade do |t|
    t.integer  "project_id", null: false
    t.integer  "user_id",    null: false
    t.string   "role",       null: false
    t.boolean  "confirmed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "members", ["project_id"], name: "index_members_on_project_id", using: :btree
  add_index "members", ["user_id"], name: "index_members_on_user_id", using: :btree

  create_table "members_projects", id: false, force: :cascade do |t|
    t.integer "member_id",  null: false
    t.integer "project_id", null: false
  end

  add_index "members_projects", ["member_id", "project_id"], name: "index_members_projects_on_member_id_and_project_id", using: :btree
  add_index "members_projects", ["member_id"], name: "index_members_projects_on_member_id", using: :btree
  add_index "members_projects", ["project_id"], name: "index_members_projects_on_project_id", using: :btree

  create_table "members_users", id: false, force: :cascade do |t|
    t.integer "member_id", null: false
    t.integer "user_id",   null: false
  end

  add_index "members_users", ["member_id", "user_id"], name: "index_members_users_on_member_id_and_user_id", using: :btree
  add_index "members_users", ["member_id"], name: "index_members_users_on_member_id", using: :btree
  add_index "members_users", ["user_id"], name: "index_members_users_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "slug"
    t.string   "logo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "refile_attachments", force: :cascade do |t|
    t.string "namespace", null: false
  end

  add_index "refile_attachments", ["namespace"], name: "index_refile_attachments_on_namespace", using: :btree

  create_table "statuses", force: :cascade do |t|
    t.integer  "project_id",                null: false
    t.string   "name",                      null: false
    t.integer  "order",      default: 0
    t.boolean  "open",       default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "statuses", ["project_id"], name: "index_statuses_on_project_id", using: :btree

  create_table "tickets", force: :cascade do |t|
    t.integer  "project_id",    null: false
    t.integer  "parent_id"
    t.integer  "sequential_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "tickets", ["parent_id"], name: "index_tickets_on_parent_id", using: :btree
  add_index "tickets", ["project_id"], name: "index_tickets_on_project_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
