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

ActiveRecord::Schema.define(version: 2021_03_08_162309) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "album_songs", force: :cascade do |t|
    t.bigint "album_id", null: false
    t.bigint "song_id", null: false
    t.integer "track_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["album_id"], name: "index_album_songs_on_album_id"
    t.index ["song_id"], name: "index_album_songs_on_song_id"
  end

  create_table "albums", force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.date "release_date"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
    t.index ["artist_id"], name: "index_albums_on_artist_id"
  end

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.string "first_name"
    t.string "last_name"
    t.date "date_of_birth"
    t.string "birth_location"
    t.string "instagram"
    t.string "bio"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "collaborations", force: :cascade do |t|
    t.bigint "song_id", null: false
    t.bigint "artist_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["artist_id"], name: "index_collaborations_on_artist_id"
    t.index ["song_id"], name: "index_collaborations_on_song_id"
  end

  create_table "libraries", force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["artist_id"], name: "index_libraries_on_artist_id"
    t.index ["user_id"], name: "index_libraries_on_user_id"
  end

  create_table "outlists", force: :cascade do |t|
    t.bigint "song_id", null: false
    t.bigint "user_id", null: false
    t.boolean "played", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["song_id"], name: "index_outlists_on_song_id"
    t.index ["user_id"], name: "index_outlists_on_user_id"
  end

  create_table "songs", force: :cascade do |t|
    t.boolean "single"
    t.string "video_url"
    t.integer "length"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.string "location"
    t.string "instagram"
    t.string "gender"
    t.datetime "date_of_birth"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "album_songs", "albums"
  add_foreign_key "album_songs", "songs"
  add_foreign_key "albums", "artists"
  add_foreign_key "collaborations", "artists"
  add_foreign_key "collaborations", "songs"
  add_foreign_key "libraries", "artists"
  add_foreign_key "libraries", "users"
  add_foreign_key "outlists", "songs"
  add_foreign_key "outlists", "users"
end
