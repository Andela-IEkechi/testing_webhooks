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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130731102424) do

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "plan",       :default => "free"
    t.boolean  "enabled",    :default => true
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "accounts", ["user_id"], :name => "index_accounts_on_user_id"

  create_table "api_keys", :id => false, :force => true do |t|
    t.string   "name",       :null => false
    t.string   "token",      :null => false
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comment_assets", :force => true do |t|
    t.integer  "comment_id", :null => false
    t.string   "payload"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "ticket_id",                      :null => false
    t.integer  "feature_id"
    t.integer  "sprint_id"
    t.integer  "assignee_id"
    t.integer  "status_id"
    t.text     "body"
    t.integer  "cost",            :default => 0
    t.integer  "user_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.text     "rendered_body"
    t.string   "api_key_name"
    t.string   "commenter"
    t.string   "git_commit_uuid"
  end

  add_index "comments", ["git_commit_uuid"], :name => "index_comments_on_git_commit_uuid"

  create_table "features", :force => true do |t|
    t.string   "title",                      :null => false
    t.string   "description"
    t.date     "due_on"
    t.integer  "project_id",                 :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "scoped_id",   :default => 0
  end

  add_index "features", ["project_id"], :name => "index_features_on_project_id"

  create_table "memberships", :force => true do |t|
    t.integer "project_id"
    t.integer "user_id"
    t.string  "role",       :default => "regular", :null => false
  end

  create_table "overviews", :force => true do |t|
    t.string   "title",                      :null => false
    t.string   "filter",     :default => "", :null => false
    t.integer  "user_id",                    :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "overviews_projects", :id => false, :force => true do |t|
    t.integer "overview_id"
    t.integer "project_id"
  end

  create_table "projects", :force => true do |t|
    t.string   "title",                               :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "user_id",                             :null => false
    t.integer  "tickets_sequence",  :default => 0
    t.integer  "features_sequence", :default => 0
    t.integer  "sprints_sequence",  :default => 0
    t.boolean  "private",           :default => true
    t.string   "description"
  end

  create_table "sprints", :force => true do |t|
    t.date     "due_on",                    :null => false
    t.string   "goal",                      :null => false
    t.integer  "project_id",                :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "scoped_id",  :default => 0
  end

  add_index "sprints", ["project_id"], :name => "index_sprints_on_project_id"

  create_table "ticket_statuses", :force => true do |t|
    t.integer "project_id",                       :null => false
    t.string  "name",                             :null => false
    t.boolean "open",           :default => true
    t.integer "sort_index"
    t.boolean "system_default"
  end

  create_table "tickets", :force => true do |t|
    t.integer  "project_id",                     :null => false
    t.string   "title",                          :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "last_comment_id"
    t.integer  "scoped_id",       :default => 0
    t.string   "slug"
  end

  add_index "tickets", ["project_id", "scoped_id"], :name => "index_tickets_on_project_id_and_scoped_id"
  add_index "tickets", ["project_id"], :name => "index_tickets_on_project_id"
  add_index "tickets", ["slug"], :name => "index_tickets_on_slug", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                                :default => "",    :null => false
    t.string   "encrypted_password",                   :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.string   "provider"
    t.string   "uid"
    t.string   "full_name"
    t.boolean  "terms",                                :default => false
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.text     "preferences"
    t.datetime "deleted_at"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",      :null => false
    t.integer  "item_id",        :null => false
    t.string   "event",          :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
