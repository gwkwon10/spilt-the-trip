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

ActiveRecord::Schema[8.0].define(version: 2025_04_14_062050) do
  create_table "expenses", force: :cascade do |t|
    t.float "amount"
    t.integer "trip_id"
    t.string "currency"
    t.string "category"
    t.date "date"
    t.string "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "liables", force: :cascade do |t|
    t.integer "user_id"
    t.float "amountLiable"
    t.integer "expense_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "on_trips", force: :cascade do |t|
    t.integer "user_id"
    t.integer "trip_id"
    t.float "balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "owes", force: :cascade do |t|
    t.integer "userOwing"
    t.integer "userOwed"
    t.float "amountOwed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trips", force: :cascade do |t|
    t.date "startDate"
    t.date "endDate"
    t.string "name"
    t.integer "ownerid"
    t.string "defaultCurrency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "password_digest"
    t.string "displayName"
    t.string "email"
    t.string "password"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
