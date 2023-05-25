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

ActiveRecord::Schema[7.0].define(version: 2023_05_22_053541) do
  create_table "assignments", force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "teaching_assistant_id", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_assignments_on_course_id"
    t.index ["teaching_assistant_id"], name: "index_assignments_on_teaching_assistant_id"
  end

  create_table "courses", force: :cascade do |t|
    t.integer "year"
    t.string "term"
    t.string "number"
    t.string "name"
    t.string "instructor"
    t.integer "time_budget"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teaching_assistants", force: :cascade do |t|
    t.integer "year"
    t.string "number"
    t.string "name"
    t.string "grade"
    t.string "labo"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "account_name"
    t.string "password"
    t.string "admin_flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "work_hours", force: :cascade do |t|
    t.datetime "dtstart"
    t.datetime "dtend"
    t.integer "actual_working_minutes"
    t.integer "assignment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignment_id"], name: "index_work_hours_on_assignment_id"
  end

  add_foreign_key "assignments", "courses"
  add_foreign_key "assignments", "teaching_assistants"
  add_foreign_key "work_hours", "assignments"
end
