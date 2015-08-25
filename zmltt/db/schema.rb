# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090618100112) do

  create_table "banners", :force => true do |t|
    t.string   "city"
    t.string   "street"
    t.string   "house"
    t.string   "stroen"
    t.string   "primech"
    t.string   "tp"
    t.string   "ulic"
    t.string   "light"
    t.string   "storona"
    t.string   "xnomer"
    t.string   "zametka"
    t.integer  "contractor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "korpus"
    t.string   "online",        :default => "нет"
  end

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.string   "login"
    t.string   "adresreal"
    t.string   "password"
    t.date     "contact"
    t.text     "zametka"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "client_id"
    t.integer  "contractor_id"
    t.string   "name"
    t.string   "post"
    t.string   "visible",       :default => "false"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contractors", :force => true do |t|
    t.string   "name"
    t.string   "fio"
    t.string   "tel"
    t.string   "zametka"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nid"
    t.string   "otrasl",     :default => "Наружная реклама"
  end

  create_table "db_files", :force => true do |t|
    t.binary "data", :limit => 16777215
  end

  create_table "dogovors", :force => true do |t|
    t.text     "dogovor"
    t.string   "tip"
    t.text     "shapka"
    t.text     "tail"
    t.date     "data"
    t.string   "status"
    t.integer  "client_id"
    t.integer  "ourfirm_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "extras", :force => true do |t|
    t.string   "name"
    t.string   "who"
    t.string   "minsrok"
    t.string   "coast"
    t.string   "realcoast"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "onlines", :force => true do |t|
    t.integer  "banner_id"
    t.string   "month"
    t.string   "coast"
    t.string   "realcoast"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "databegin"
    t.datetime "dataend"
  end

  create_table "orders", :force => true do |t|
    t.integer  "client_id"
    t.integer  "user_id"
    t.integer  "dogovor_id"
    t.text     "order"
    t.text     "zametka"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "contact",    :default => '2008-09-15'
  end

  create_table "ourfirms", :force => true do |t|
    t.string   "ourfirm"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phones", :force => true do |t|
    t.integer  "contact_id"
    t.string   "number"
    t.string   "tip"
    t.string   "visible",    :default => "false"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.string  "content_type"
    t.string  "filename"
    t.integer "size"
    t.integer "banner_id"
    t.integer "parent_id"
    t.string  "thumbnail"
    t.integer "width"
    t.integer "height"
    t.integer "db_file_id"
    t.integer "user_id"
    t.integer "promo_id"
  end

  create_table "plategs", :force => true do |t|
    t.integer  "order_id"
    t.string   "nomer"
    t.string   "sum"
    t.string   "plateg"
    t.date     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prices", :force => true do |t|
    t.string   "coast"
    t.string   "realcoast"
    t.string   "wtf"
    t.string   "month"
    t.string   "minsrok"
    t.date     "databegin"
    t.date     "dataend"
    t.string   "size",       :default => "1"
    t.string   "edinizm",    :default => "шт."
    t.string   "country",    :default => "Россия"
    t.integer  "banner_id"
    t.integer  "extra_id"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prilojens", :force => true do |t|
    t.integer  "order_id"
    t.text     "prilojen"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "promos", :force => true do |t|
    t.string   "fio"
    t.datetime "birthday"
    t.string   "rost"
    t.string   "color"
    t.string   "medbook",    :default => "есть"
    t.string   "clothsize"
    t.text     "pasport"
    t.string   "livepoint"
    t.string   "metro"
    t.string   "city"
    t.string   "sex",        :default => "муж."
    t.string   "otdel"
    t.string   "contact"
    t.integer  "photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rekvizits", :force => true do |t|
    t.integer  "client_id"
    t.integer  "ourfirm_id"
    t.string   "name"
    t.string   "adressur"
    t.string   "inn"
    t.string   "kpp"
    t.string   "rschet"
    t.string   "bank"
    t.string   "kschet"
    t.string   "bik"
    t.string   "gendir",     :default => "Генеральный директор"
    t.string   "gendirosn",  :default => "устава"
    t.string   "gendirname"
    t.string   "gendirfam"
    t.string   "gendirotch"
    t.string   "bux",        :default => "Главный бухгалтер"
    t.string   "buxname"
    t.string   "buxfam"
    t.string   "buxotch"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schema_info", :id => false, :force => true do |t|
    t.integer "version"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "specials", :force => true do |t|
    t.string   "name"
    t.string   "msg"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size"
    t.integer  "parent_id"
    t.integer  "db_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "fio"
    t.string   "oklad"
    t.string   "zp"
    t.string   "phone"
    t.string   "cfg",                                     :default => "client"
    t.string   "icq"
    t.string   "otdel"
    t.integer  "order_id"
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.datetime "birthday",                                :default => '1901-01-01 00:00:00'
    t.string   "archived",                                :default => "Нет"
    t.string   "post",                                    :default => "Менеджер"
    t.string   "percent",                                 :default => "10"
    t.string   "status",                                  :default => "Кадровый сотрудник"
  end

end
