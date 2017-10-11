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

ActiveRecord::Schema.define(version: 20171011214319) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "brands", force: :cascade do |t|
    t.citext   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "items_count", default: 0
  end

  add_index "brands", ["slug"], name: "index_brands_on_slug", unique: true, using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "items", force: :cascade do |t|
    t.string   "title"
    t.string   "asin"
    t.integer  "brand_id"
    t.text     "description"
    t.integer  "price_cents",        default: 0
    t.text     "buy_now"
    t.integer  "total_offers",       default: 0
    t.integer  "sales_rank"
    t.integer  "page_views",         default: 0
    t.text     "dimensions"
    t.text     "package_dimensions"
    t.text     "buy_box"
    t.text     "images"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "source"
  end

  add_index "items", ["brand_id"], name: "index_items_on_brand_id", using: :btree

  create_table "list_items", force: :cascade do |t|
    t.integer  "list_id",                null: false
    t.integer  "item_id"
    t.text     "details"
    t.integer  "sort",       default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "list_items", ["item_id"], name: "index_list_items_on_item_id", using: :btree
  add_index "list_items", ["list_id", "item_id"], name: "index_list_items_on_list_id_and_item_id", unique: true, using: :btree
  add_index "list_items", ["list_id"], name: "index_list_items_on_list_id", using: :btree

  create_table "lists", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "body"
    t.integer  "status",        default: 0
    t.integer  "item_count",    default: 0
    t.integer  "display_theme", default: 0
    t.integer  "category_id"
    t.integer  "user_id",       default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort",          default: 0
    t.integer  "page_views",    default: 0
    t.string   "source"
  end

  add_index "lists", ["category_id"], name: "index_lists_on_category_id", using: :btree
  add_index "lists", ["user_id"], name: "index_lists_on_user_id", using: :btree

  create_table "saved_items", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "saved_items", ["item_id", "user_id"], name: "index_saved_items_on_item_id_and_user_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
