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

ActiveRecord::Schema.define(version: 20160125154309) do

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "schemas", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "capacity",   limit: 4
    t.integer  "x",          limit: 4
    t.integer  "y",          limit: 4
    t.text     "schema",     limit: 65535
    t.integer  "constraint", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "seats", force: :cascade do |t|
    t.integer  "x",          limit: 4
    t.integer  "y",          limit: 4
    t.integer  "state",      limit: 4
    t.integer  "schema_id",  limit: 4
    t.integer  "price",      limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "seats", ["schema_id"], name: "index_seats_on_schema_id", using: :btree

  create_table "seats_tickets", id: false, force: :cascade do |t|
    t.integer "ticket_id", limit: 4
    t.integer "seat_id",   limit: 4
  end

  add_index "seats_tickets", ["seat_id"], name: "index_seats_tickets_on_seat_id", using: :btree
  add_index "seats_tickets", ["ticket_id"], name: "index_seats_tickets_on_ticket_id", using: :btree

  create_table "tickets", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "name",       limit: 255
    t.boolean  "confirmed"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "tickets", ["user_id"], name: "index_tickets_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "role_id",                limit: 4
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "seats", "schemas"
  add_foreign_key "seats_tickets", "seats"
  add_foreign_key "seats_tickets", "tickets"
  add_foreign_key "tickets", "users"
end
