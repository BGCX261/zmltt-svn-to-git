class CreatePromos < ActiveRecord::Migration
  def self.up
    create_table :promos do |t|
      t.string :fio
      t.datetime :birthday
      t.string :rost
      t.string :color
      t.string :medbook, :default => 'есть'
      t.string :clothsize
      t.text :pasport
      t.string :livepoint
      t.string :metro
      t.string :city
      t.string :sex, :default => 'муж.'
      t.string :otdel
      t.string :contact
      t.references :photo
      t.timestamps
    end
    add_column :photos, :promo_id, :integer
  end

  def self.down
    drop_table :promos
    remove_column :photos, :promo_id
  end
end
