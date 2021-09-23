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

ActiveRecord::Schema.define(version: 20210701202923) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alchemy_attachments", force: :cascade do |t|
    t.string   "name"
    t.string   "file_name"
    t.string   "file_mime_type"
    t.integer  "file_size"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "cached_tag_list"
    t.string   "file_uid"
    t.index ["file_uid"], name: "index_alchemy_attachments_on_file_uid", using: :btree
  end

  create_table "alchemy_cells", force: :cascade do |t|
    t.integer  "page_id",    null: false
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_alchemy_cells_on_page_id", using: :btree
  end

  create_table "alchemy_contents", force: :cascade do |t|
    t.string   "name"
    t.string   "essence_type", null: false
    t.integer  "essence_id",   null: false
    t.integer  "element_id",   null: false
    t.integer  "position"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.index ["element_id", "position"], name: "index_contents_on_element_id_and_position", using: :btree
    t.index ["essence_id", "essence_type"], name: "index_alchemy_contents_on_essence_id_and_essence_type", unique: true, using: :btree
  end

  create_table "alchemy_elements", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.integer  "page_id",                           null: false
    t.boolean  "public",            default: true
    t.boolean  "folded",            default: false
    t.boolean  "unique",            default: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.integer  "cell_id"
    t.text     "cached_tag_list"
    t.integer  "parent_element_id"
    t.index ["cell_id"], name: "index_alchemy_elements_on_cell_id", using: :btree
    t.index ["page_id", "parent_element_id"], name: "index_alchemy_elements_on_page_id_and_parent_element_id", using: :btree
    t.index ["page_id", "position"], name: "index_elements_on_page_id_and_position", using: :btree
  end

  create_table "alchemy_elements_alchemy_pages", id: false, force: :cascade do |t|
    t.integer "element_id"
    t.integer "page_id"
  end

  create_table "alchemy_essence_booleans", force: :cascade do |t|
    t.boolean  "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.index ["value"], name: "index_alchemy_essence_booleans_on_value", using: :btree
  end

  create_table "alchemy_essence_dates", force: :cascade do |t|
    t.datetime "date"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "alchemy_essence_files", force: :cascade do |t|
    t.integer  "attachment_id"
    t.string   "title"
    t.string   "css_class"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "link_text"
    t.index ["attachment_id"], name: "index_alchemy_essence_files_on_attachment_id", using: :btree
  end

  create_table "alchemy_essence_htmls", force: :cascade do |t|
    t.text     "source"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "alchemy_essence_links", force: :cascade do |t|
    t.string   "link"
    t.string   "link_title"
    t.string   "link_target"
    t.string   "link_class_name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  create_table "alchemy_essence_pictures", force: :cascade do |t|
    t.integer  "picture_id"
    t.string   "caption"
    t.string   "title"
    t.string   "alt_tag"
    t.string   "link"
    t.string   "link_class_name"
    t.string   "link_title"
    t.string   "css_class"
    t.string   "link_target"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "crop_from"
    t.string   "crop_size"
    t.string   "render_size"
    t.boolean  "searchable",      default: true
    t.index ["picture_id"], name: "index_alchemy_essence_pictures_on_picture_id", using: :btree
  end

  create_table "alchemy_essence_richtexts", force: :cascade do |t|
    t.text     "body"
    t.text     "stripped_body"
    t.boolean  "public"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "searchable",    default: true
  end

  create_table "alchemy_essence_selects", force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.index ["value"], name: "index_alchemy_essence_selects_on_value", using: :btree
  end

  create_table "alchemy_essence_texts", force: :cascade do |t|
    t.text     "body"
    t.string   "link"
    t.string   "link_title"
    t.string   "link_class_name"
    t.boolean  "public",          default: false
    t.string   "link_target"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "searchable",      default: true
  end

  create_table "alchemy_folded_pages", force: :cascade do |t|
    t.integer "page_id",                 null: false
    t.integer "user_id",                 null: false
    t.boolean "folded",  default: false
    t.index ["page_id", "user_id"], name: "index_alchemy_folded_pages_on_page_id_and_user_id", unique: true, using: :btree
  end

  create_table "alchemy_languages", force: :cascade do |t|
    t.string   "name"
    t.string   "language_code"
    t.string   "frontpage_name"
    t.string   "page_layout",    default: "intro"
    t.boolean  "public",         default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.boolean  "default",        default: false
    t.string   "country_code",   default: "",      null: false
    t.integer  "site_id",                          null: false
    t.string   "locale"
    t.index ["language_code", "country_code"], name: "index_alchemy_languages_on_language_code_and_country_code", using: :btree
    t.index ["language_code"], name: "index_alchemy_languages_on_language_code", using: :btree
    t.index ["site_id"], name: "index_alchemy_languages_on_site_id", using: :btree
  end

  create_table "alchemy_legacy_page_urls", force: :cascade do |t|
    t.string   "urlname",    null: false
    t.integer  "page_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_alchemy_legacy_page_urls_on_page_id", using: :btree
    t.index ["urlname"], name: "index_alchemy_legacy_page_urls_on_urlname", using: :btree
  end

  create_table "alchemy_pages", force: :cascade do |t|
    t.string   "name"
    t.string   "urlname"
    t.string   "title"
    t.string   "language_code"
    t.boolean  "language_root"
    t.string   "page_layout"
    t.text     "meta_keywords"
    t.text     "meta_description"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "parent_id"
    t.integer  "depth"
    t.boolean  "visible",          default: false
    t.integer  "locked_by"
    t.boolean  "restricted",       default: false
    t.boolean  "robot_index",      default: true
    t.boolean  "robot_follow",     default: true
    t.boolean  "sitemap",          default: true
    t.boolean  "layoutpage",       default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.integer  "language_id"
    t.text     "cached_tag_list"
    t.datetime "published_at"
    t.datetime "public_on"
    t.datetime "public_until"
    t.datetime "locked_at"
    t.index ["language_id"], name: "index_pages_on_language_id", using: :btree
    t.index ["locked_at", "locked_by"], name: "index_alchemy_pages_on_locked_at_and_locked_by", using: :btree
    t.index ["parent_id", "lft"], name: "index_pages_on_parent_id_and_lft", using: :btree
    t.index ["public_on", "public_until"], name: "index_alchemy_pages_on_public_on_and_public_until", using: :btree
    t.index ["rgt"], name: "index_alchemy_pages_on_rgt", using: :btree
    t.index ["urlname"], name: "index_pages_on_urlname", using: :btree
  end

  create_table "alchemy_pictures", force: :cascade do |t|
    t.string   "name"
    t.string   "image_file_name"
    t.integer  "image_file_width"
    t.integer  "image_file_height"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.string   "upload_hash"
    t.text     "cached_tag_list"
    t.string   "image_file_uid"
    t.integer  "image_file_size"
    t.string   "image_file_format"
  end

  create_table "alchemy_sites", force: :cascade do |t|
    t.string   "host"
    t.string   "name"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "public",                   default: false
    t.text     "aliases"
    t.boolean  "redirect_to_primary_host"
    t.index ["host", "public"], name: "alchemy_sites_public_hosts_idx", using: :btree
    t.index ["host"], name: "index_alchemy_sites_on_host", using: :btree
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  add_foreign_key "alchemy_cells", "alchemy_pages", column: "page_id", name: "alchemy_cells_page_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "alchemy_contents", "alchemy_elements", column: "element_id", name: "alchemy_contents_element_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "alchemy_elements", "alchemy_cells", column: "cell_id", name: "alchemy_elements_cell_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "alchemy_elements", "alchemy_pages", column: "page_id", name: "alchemy_elements_page_id_fkey", on_update: :cascade, on_delete: :cascade
end
