# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_12_23_195352) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "message_recipient_lists", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.bigint "recipient_list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_message_recipient_lists_on_message_id"
    t.index ["recipient_list_id"], name: "index_message_recipient_lists_on_recipient_list_id"
  end

  create_table "message_recipients", force: :cascade do |t|
    t.string "status", null: false
    t.string "error"
    t.string "sid"
    t.bigint "message_id", null: false
    t.bigint "recipient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_status_check"
    t.index ["message_id"], name: "index_message_recipients_on_message_id"
    t.index ["recipient_id"], name: "index_message_recipients_on_recipient_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "content", null: false
    t.string "status", null: false
    t.datetime "sent_at"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "messages_recipient_lists", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.bigint "recipient_list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_messages_recipient_lists_on_message_id"
    t.index ["recipient_list_id"], name: "index_messages_recipient_lists_on_recipient_list_id"
  end

  create_table "recipient_lists", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_recipient_lists_on_user_id"
  end

  create_table "recipient_lists_recipients", id: false, force: :cascade do |t|
    t.bigint "recipient_id", null: false
    t.bigint "recipient_list_id", null: false
    t.index ["recipient_id"], name: "index_recipient_lists_recipients_on_recipient_id"
    t.index ["recipient_list_id"], name: "index_recipient_lists_recipients_on_recipient_list_id"
  end

  create_table "recipients", force: :cascade do |t|
    t.string "phone", null: false
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipients_recipient_lists", force: :cascade do |t|
    t.bigint "recipient_id", null: false
    t.bigint "recipient_list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id"], name: "index_recipients_recipient_lists_on_recipient_id"
    t.index ["recipient_list_id"], name: "index_recipients_recipient_lists_on_recipient_list_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "message_recipient_lists", "messages"
  add_foreign_key "message_recipient_lists", "recipient_lists"
  add_foreign_key "message_recipients", "messages"
  add_foreign_key "message_recipients", "recipients"
  add_foreign_key "messages", "users"
  add_foreign_key "messages_recipient_lists", "messages"
  add_foreign_key "messages_recipient_lists", "recipient_lists"
  add_foreign_key "recipient_lists", "users"
  add_foreign_key "recipients_recipient_lists", "recipient_lists"
  add_foreign_key "recipients_recipient_lists", "recipients"
end
