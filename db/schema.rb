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

ActiveRecord::Schema.define(version: 20160426182538) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "status"
    t.integer  "schedule_id"
    t.integer  "bicycle_number"
    t.datetime "start"
    t.string   "description"
    t.text     "anomaly"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "cards", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "uid"
    t.string   "object"
    t.boolean  "active"
    t.string   "last4"
    t.datetime "exp_month"
    t.datetime "exp_year"
    t.string   "name"
    t.text     "address"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "phone"
    t.boolean  "primary",    default: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "distributions", force: :cascade do |t|
    t.integer  "height"
    t.integer  "width"
    t.string   "description"
    t.text     "inactive_seats"
    t.text     "active_seats"
    t.integer  "total_seats"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "emails", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "email_status"
    t.string   "email_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "instructors", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "bio"
    t.string   "quote"
  end

  create_table "packs", force: :cascade do |t|
    t.string   "description"
    t.integer  "classes"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.float    "special_price"
    t.float    "price"
    t.integer  "expiration"
  end

  create_table "purchases", force: :cascade do |t|
    t.integer  "pack_id"
    t.integer  "user_id"
    t.string   "uid"
    t.string   "object"
    t.boolean  "livemode"
    t.string   "status"
    t.string   "description"
    t.integer  "amount"
    t.string   "currency"
    t.text     "payment_method"
    t.text     "details"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "expired",        default: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer  "venue_id"
    t.integer  "distribution_id"
    t.string   "description"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.integer  "instructor_id"
    t.integer  "room_id"
    t.datetime "datetime"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "classes_left"
    t.datetime "last_class_purchased"
    t.string   "picture"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "active",                 default: true
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "email"
    t.json     "tokens"
    t.string   "phone"
    t.string   "conekta_customer_id"
    t.string   "conekta_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  create_table "venues", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_foreign_key "roles_users", "roles"
  add_foreign_key "roles_users", "users"
end
