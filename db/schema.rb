# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_09_07_032211) do

  create_table "courses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.boolean "activated", default: false
    t.datetime "start_time"
    t.datetime "finish_time"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "estimated_end_time"
  end

  create_table "enrollments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "course_id"
    t.datetime "enroll_time"
    t.datetime "finish_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_enrollments_on_course_id"
    t.index ["user_id", "course_id"], name: "index_enrollments_on_user_id_and_course_id", unique: true
    t.index ["user_id"], name: "index_enrollments_on_user_id"
  end

  create_table "reports", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "date"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "today_task"
    t.text "tmr_task"
    t.bigint "course_id", null: false
    t.index ["course_id"], name: "index_reports_on_course_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "statuses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "enrollment_id"
    t.string "finishable_type"
    t.bigint "finishable_id"
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["enrollment_id"], name: "index_statuses_on_enrollment_id"
    t.index ["finishable_id", "finishable_type", "enrollment_id"], name: "index_finishable_and_enrollment_id", unique: true
    t.index ["finishable_type", "finishable_id"], name: "index_statuses_on_finishable_type_and_finishable_id"
  end

  create_table "subjects", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "course_id"
    t.string "name"
    t.datetime "start_time"
    t.integer "length"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_subjects_on_course_id"
  end

  create_table "supervisions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "course_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_supervisions_on_course_id"
    t.index ["user_id", "course_id"], name: "index_supervisions_on_user_id_and_course_id", unique: true
    t.index ["user_id"], name: "index_supervisions_on_user_id"
  end

  create_table "tasks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "subject_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["subject_id"], name: "index_tasks_on_subject_id"
  end

  create_table "trainee_infos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "garaduate_year"
    t.string "university"
    t.datetime "start_training_time"
    t.datetime "finish_training_time"
    t.index ["user_id"], name: "index_trainee_infos_on_user_id", unique: true
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "date_of_birth"
    t.string "address"
    t.integer "gender", default: 2
    t.integer "role", default: 0
    t.string "encrypted_password"
    t.string "remember_token"
    t.boolean "activated", default: false
    t.string "activation_digest"
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "enrollments", "courses"
  add_foreign_key "enrollments", "users"
  add_foreign_key "reports", "courses"
  add_foreign_key "reports", "users"
  add_foreign_key "statuses", "enrollments"
  add_foreign_key "subjects", "courses"
  add_foreign_key "supervisions", "courses"
  add_foreign_key "supervisions", "users"
  add_foreign_key "tasks", "subjects"
  add_foreign_key "trainee_infos", "users"
end
