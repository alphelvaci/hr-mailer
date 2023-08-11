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

ActiveRecord::Schema[7.0].define(version: 2023_07_19_115702) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "celebration_events", force: :cascade do |t|
    t.string "reason", null: false
    t.date "date", null: false
    t.string "status", null: false
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
