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

ActiveRecord::Schema.define(version: 20160519103914) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer  "user_id",        null: false
    t.date     "anniversary_on"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["user_id"], name: "index_accounts_on_user_id", using: :btree
  end

  create_table "attachments", force: :cascade do |t|
    t.integer  "comment_id", null: false
    t.string   "file_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_attachments_on_comment_id", using: :btree
  end

  create_table "boards", force: :cascade do |t|
    t.integer  "project_id", null: false
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_boards_on_project_id", using: :btree
  end

  create_table "boards_tickets", id: false, force: :cascade do |t|
    t.integer "board_id",  null: false
    t.integer "ticket_id", null: false
    t.index ["board_id"], name: "index_boards_tickets_on_board_id", using: :btree
    t.index ["ticket_id"], name: "index_boards_tickets_on_ticket_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "ticket_id",      null: false
    t.integer  "commenter_id"
    t.integer  "status_id"
    t.integer  "assignee_id_id"
    t.text     "message"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["assignee_id_id"], name: "index_comments_on_assignee_id_id", using: :btree
    t.index ["commenter_id"], name: "index_comments_on_commenter_id", using: :btree
    t.index ["status_id"], name: "index_comments_on_status_id", using: :btree
    t.index ["ticket_id"], name: "index_comments_on_ticket_id", using: :btree
  end

  create_table "members", force: :cascade do |t|
    t.integer  "project_id", null: false
    t.integer  "user_id",    null: false
    t.string   "role",       null: false
    t.boolean  "confirmed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_members_on_project_id", using: :btree
    t.index ["user_id"], name: "index_members_on_user_id", using: :btree
  end

  create_table "members_projects", id: false, force: :cascade do |t|
    t.integer "member_id",  null: false
    t.integer "project_id", null: false
    t.index ["member_id"], name: "index_members_projects_on_member_id", using: :btree
    t.index ["project_id"], name: "index_members_projects_on_project_id", using: :btree
  end

  create_table "members_users", id: false, force: :cascade do |t|
    t.integer "member_id", null: false
    t.integer "user_id",   null: false
    t.index ["member_id"], name: "index_members_users_on_member_id", using: :btree
    t.index ["user_id"], name: "index_members_users_on_user_id", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "slug"
    t.string   "logo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "refile_attachments", force: :cascade do |t|
    t.string "namespace", null: false
    t.index ["namespace"], name: "index_refile_attachments_on_namespace", using: :btree
  end

  create_table "statuses", force: :cascade do |t|
    t.integer  "project_id",                null: false
    t.string   "name",                      null: false
    t.integer  "order",      default: 0
    t.boolean  "open",       default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["project_id"], name: "index_statuses_on_project_id", using: :btree
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "tickets", force: :cascade do |t|
    t.integer  "project_id",    null: false
    t.integer  "parent_id"
    t.integer  "sequential_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "title"
    t.index ["parent_id"], name: "index_tickets_on_parent_id", using: :btree
    t.index ["project_id"], name: "index_tickets_on_project_id", using: :btree
  end

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
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

end
