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

ActiveRecord::Schema.define(version: 20170413142230) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "candidates", force: :cascade do |t|
    t.string   "name"
    t.string   "birthday"
    t.string   "salary"
    t.string   "salary_format"
    t.string   "education"
    t.string   "languages"
    t.string   "city_of_residence"
    t.string   "ready_to_relocate"
    t.string   "desired_position"
    t.string   "status",            default: "Пассивен"
    t.string   "source"
    t.text     "original_cv_data"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "email"
    t.string   "phone"
    t.string   "linkedin"
    t.string   "facebook"
    t.string   "vkontakte"
    t.string   "google_plus"
    t.string   "home_page"
    t.string   "skype"
    t.integer  "user_id"
    t.integer  "company_id"
    t.string   "notice"
    t.text     "experience"
    t.integer  "geo_name_id"
    t.string   "file_name"
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "region_id"
    t.integer  "user_id"
  end

  create_table "cv_sources", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_cv_sources_on_name", unique: true, using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.datetime "will_begin_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.text     "description"
    t.integer  "user_id"
    t.integer  "staff_relation_id"
  end

  create_table "geo_alternate_names", force: :cascade do |t|
    t.integer  "geo_geoname_id"
    t.string   "language"
    t.string   "name"
    t.string   "alternate_name"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "geo_names", force: :cascade do |t|
    t.string   "name"
    t.string   "asciiname"
    t.decimal  "lat"
    t.decimal  "lng"
    t.string   "fclass"
    t.string   "fcode"
    t.string   "country"
    t.string   "cc2"
    t.string   "admin1"
    t.string   "admin2"
    t.string   "admin3"
    t.string   "admin4"
    t.integer  "population"
    t.integer  "elevation"
    t.integer  "gtopo30"
    t.string   "timezone"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "candidates_count", default: 0
  end

  create_table "histories", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "old_status"
    t.string   "new_status"
    t.hstore   "responsible"
    t.string   "action"
    t.index ["responsible"], name: "index_histories_on_responsible", using: :gin
  end

  create_table "images", force: :cascade do |t|
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "user_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "regions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "staff_relations", force: :cascade do |t|
    t.string   "status",       default: "Найденные"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "vacancy_id"
    t.integer  "candidate_id"
  end

  create_table "stickers", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.string   "bg_color"
    t.index ["deleted_at"], name: "index_stickers_on_deleted_at", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "skype"
    t.string   "post"
    t.integer  "region_id"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",      default: 0
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "vacancies", force: :cascade do |t|
    t.string   "name"
    t.string   "salary"
    t.string   "salary_format"
    t.string   "languages"
    t.string   "status",        default: "Не задействована"
    t.text     "requirements"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "region_id"
    t.integer  "user_id"
    t.time     "deleted_at"
  end

end
