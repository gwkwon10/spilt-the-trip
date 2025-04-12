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

ActiveRecord::Schema[8.0].define(version: 2025_04_09_092545) do
  create_table "authenticates", force: :cascade do |t|
    t.string "password"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_authenticates_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.float "amount"
    t.string "currency"
    t.string "category"
    t.date "date"
    t.string "desc"
    t.integer "trip_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id"], name: "index_expenses_on_trip_id"
  end

  create_table "liables", force: :cascade do |t|
    t.float "amountLiable"
    t.integer "user_id"
    t.integer "expense_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_id"], name: "index_liables_on_expense_id"
    t.index ["user_id"], name: "index_liables_on_user_id"
  end

  create_table "on_trips", force: :cascade do |t|
    t.float "balance"
    t.integer "user_id"
    t.integer "trip_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id"], name: "index_on_trips_on_trip_id"
    t.index ["user_id"], name: "index_on_trips_on_user_id"
  end

  create_table "owes", force: :cascade do |t|
    t.float "amountOwed"
    t.integer "userOwed_id"
    t.integer "userOwing_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["userOwed_id"], name: "index_owes_on_userOwed_id"
    t.index ["userOwing_id"], name: "index_owes_on_userOwing_id"
  end

  create_table "trips", force: :cascade do |t|
    t.date "startDate"
    t.date "endDate"
    t.string "name"
    t.string "defaultCurrency"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_trips_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "displayName"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "expenses", "trips"
  add_foreign_key "owes", "users", column: "userOwed_id"
  add_foreign_key "owes", "users", column: "userOwing_id"
  add_foreign_key "trips", "users", column: "owner_id"
end
