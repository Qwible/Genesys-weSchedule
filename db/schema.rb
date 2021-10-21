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

ActiveRecord::Schema.define(version: 2021_05_13_090115) do

  create_table "calendar_events", force: :cascade do |t|
    t.datetime "event_start"
    t.datetime "event_end"
    t.integer "task_id"
    t.boolean "auto_generated"
    t.boolean "late_alert"
    t.index ["task_id"], name: "index_calendar_events_on_task_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "feedback_category"
    t.index ["feedback_category"], name: "index_feedbacks_on_feedback_category"
  end

  create_table "link_clicks", force: :cascade do |t|
    t.integer "visit_id"
    t.string "link_name"
    t.string "link_css_id"
    t.text "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["link_css_id"], name: "index_link_clicks_on_link_css_id"
    t.index ["visit_id"], name: "index_link_clicks_on_visit_id"
  end

  create_table "logins", force: :cascade do |t|
    t.string "email"
    t.integer "day"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "account_type"
  end

  create_table "questions", force: :cascade do |t|
    t.string "text"
    t.string "date"
    t.integer "n_ratings", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "answer"
    t.boolean "visible", default: true
    t.integer "score", default: 0
    t.integer "interest", default: 0
    t.index ["interest"], name: "index_questions_on_interest"
  end

  create_table "registrations", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "tier"
    t.index ["created_at"], name: "index_registrations_on_created_at"
    t.index ["tier"], name: "index_registrations_on_tier"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.boolean "anonymous"
    t.text "review", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "hidden", default: false
    t.integer "score", default: 0
    t.boolean "pinned", default: false
    t.index ["created_at"], name: "index_reviews_on_created_at"
    t.index ["hidden"], name: "index_reviews_on_hidden"
    t.index ["pinned"], name: "index_reviews_on_pinned"
    t.index ["score"], name: "index_reviews_on_score"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name"
    t.integer "length"
    t.integer "priority"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "schedule", default: false
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "user_preferences", force: :cascade do |t|
    t.integer "workday_start"
    t.integer "workday_end"
    t.boolean "alternating_tasks"
    t.boolean "weekends", default: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_user_preferences_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "account_type"
    t.datetime "locked_at"
    t.integer "failed_attempts", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "visits", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "location"
    t.integer "registration_id"
    t.index ["created_at"], name: "index_visits_on_created_at"
  end

  add_foreign_key "calendar_events", "tasks"
  add_foreign_key "tasks", "users", on_delete: :cascade
  add_foreign_key "user_preferences", "users", on_delete: :cascade
end
