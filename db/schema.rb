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

ActiveRecord::Schema.define(version: 20200426074106) do

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "finish_time"
    t.string "work_contents"
    t.string "overtime_status"
    t.datetime "overtime_hours"
    t.string "change"
    t.string "one_month_status"
    t.string "change_status"
    t.datetime "latest_started_at"
    t.datetime "latest_finished_at"
    t.datetime "start_on"
    t.datetime "end_on"
    t.string "tomorrow"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "bases", force: :cascade do |t|
    t.string "name"
    t.string "number"
    t.string "attendance_sort"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.datetime "basic_time", default: "2020-04-30 23:00:00"
    t.datetime "work_time", default: "2020-04-30 22:30:00"
    t.datetime "designed_work_start_time", default: "2020-05-01 00:00:00"
    t.datetime "designed_work_finish_time", default: "2020-05-01 09:00:00"
    t.string "affiliation"
    t.string "department"
    t.integer "employee_number"
    t.integer "uid"
    t.boolean "superior", default: false
  end

end
