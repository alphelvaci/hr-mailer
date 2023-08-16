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

ActiveRecord::Schema[7.0].define(version: 2023_08_16_075001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "celebration_event_reason", ["birthday", "work_anniversary"]
  create_enum "celebration_event_status", ["pending", "pending_retry", "error", "sent"]

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

  create_table "celebration_events", force: :cascade do |t|
    t.enum "reason", null: false, enum_type: "celebration_event_reason"
    t.date "date", null: false
    t.enum "status", default: "pending", null: false, enum_type: "celebration_event_status"
    t.datetime "sent_at"
    t.text "error_message"
    t.bigint "recipient_id", null: false
    t.bigint "cc_recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cc_recipient_id"], name: "index_celebration_events_on_cc_recipient_id"
    t.index ["recipient_id", "reason", "date"], name: "index_celebration_events_on_recipient_id_and_reason_and_date", unique: true
    t.index ["recipient_id"], name: "index_celebration_events_on_recipient_id"
  end

  create_table "recipients", force: :cascade do |t|
    t.string "kolay_ik_id", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.date "birth_date", null: false
    t.date "employment_start_date", null: false
    t.boolean "is_active", null: false
    t.bigint "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kolay_ik_id"], name: "index_recipients_on_kolay_ik_id"
    t.index ["manager_id"], name: "index_recipients_on_manager_id"
  end

  add_foreign_key "celebration_events", "recipients"
  add_foreign_key "celebration_events", "recipients", column: "cc_recipient_id"
  add_foreign_key "recipients", "recipients", column: "manager_id"
end
