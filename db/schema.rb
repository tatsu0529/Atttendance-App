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

ActiveRecord::Schema.define(version: 20200327070831) do

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "bases", force: :cascade do |t|
    t.string "name"
    t.integer "number"
    t.string "attendance_sort"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "applicant_id", null: false
    t.integer "applied_id", null: false
    t.integer "executive_application_id"
    t.integer "attendance_change_id"
    t.integer "overtime_id"
    t.string "action", default: "", null: false
    t.boolean "checked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["applicant_id"], name: "index_notifications_on_applicant_id"
    t.index ["applied_id"], name: "index_notifications_on_applied_id"
    t.index ["attendance_change_id"], name: "index_notifications_on_attendance_change_id"
    t.index ["executive_application_id"], name: "index_notifications_on_executive_application_id"
    t.index ["overtime_id"], name: "index_notifications_on_overtime_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.datetime "basic_time", default: "2020-03-14 23:00:00"
    t.datetime "work_time", default: "2020-03-14 22:30:00"
    t.datetime "designed_work_start_time", default: "2020-03-15 00:00:00"
    t.datetime "designed_work_finish_time", default: "2020-03-15 09:00:00"
    t.string "affiliation"
    t.string "department"
    t.integer "employee_number"
    t.integer "uid"
  end

end
