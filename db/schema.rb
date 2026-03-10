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

ActiveRecord::Schema[8.1].define(version: 2026_03_10_162519) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "current_vibes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "energy_level"
    t.string "mood_desired"
    t.string "mood_now"
    t.integer "time_available"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_current_vibes_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.bigint "current_vibe_id", null: false
    t.string "role"
    t.datetime "updated_at", null: false
    t.index ["current_vibe_id"], name: "index_messages_on_current_vibe_id"
  end
  
  create_table "recommendations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "current_vibe_id"
    t.string "description"
    t.integer "r_rating"
    t.string "r_reasoning"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "year"
    t.index ["current_vibe_id"], name: "index_recommendations_on_current_vibe_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "age"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "era_preferred"
    t.string "genres_preferred"
    t.string "language_preferred"
    t.integer "ratings_preferred"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "current_vibes", "users"
  add_foreign_key "messages", "current_vibes"
  add_foreign_key "recommendations", "current_vibes"
end
