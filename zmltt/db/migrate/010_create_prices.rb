class CreatePrices < ActiveRecord::Migration
  def self.up
    create_table :prices do |t|
      t.string :coast
      t.string :realcoast
      t.string :wtf
      t.string :month
      t.string :minsrok
      t.date :databegin
      t.date :dataend
      t.string :size, :default => '1'
      t.string :edinizm, :default => 'шт.'
      t.string :country, :default => 'Россия'
      t.references :banner
      t.references :extra
      t.references :order
      t.timestamps
    end
  end

  def self.down
    drop_table :prices
  end
end
