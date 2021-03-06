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

ActiveRecord::Schema.define(:version => 20130310111301) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "companies", :force => true do |t|
    t.string  "name"
    t.string  "symbol"
    t.integer "sector_id"
    t.string  "index"
  end

  create_table "company_performances", :force => true do |t|
    t.integer  "company_id"
    t.integer  "period_type_id"
    t.datetime "closed_at"
    t.decimal  "value_close"
    t.decimal  "value_open"
    t.decimal  "value_high"
    t.decimal  "value_low"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.decimal  "value_last"
  end

  create_table "dividends", :force => true do |t|
    t.integer "company_id"
    t.integer "shares"
    t.date    "received_at"
    t.decimal "amount"
    t.decimal "taxes"
  end

  create_table "orders", :force => true do |t|
    t.integer  "company_id"
    t.integer  "shares"
    t.decimal  "price"
    t.integer  "order_type"
    t.decimal  "commission"
    t.decimal  "taxes"
    t.datetime "created_at"
    t.boolean  "executed"
    t.datetime "executed_at"
  end

  create_table "portfolio_performances", :force => true do |t|
    t.integer  "period_type_id"
    t.datetime "closed_at"
    t.decimal  "value_close"
    t.decimal  "value_open"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "closings"
    t.decimal  "trade_gains"
  end

  create_table "quotes", :force => true do |t|
    t.integer  "company_id"
    t.decimal  "value"
    t.decimal  "value_day_open"
    t.decimal  "value_day_low"
    t.decimal  "value_day_high"
    t.decimal  "variation_day_low"
    t.decimal  "variation_day_high"
    t.decimal  "variation_day_current"
    t.integer  "volume"
    t.datetime "created_at"
  end

  create_table "sectors", :force => true do |t|
    t.string "name"
  end

  create_table "trades", :force => true do |t|
    t.integer  "shares"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "company_id"
    t.integer  "order_open_id"
    t.integer  "order_close_id"
  end

  create_table "transactions", :force => true do |t|
    t.integer "transaction_type"
    t.decimal "amount"
    t.date    "created_at"
  end

end
