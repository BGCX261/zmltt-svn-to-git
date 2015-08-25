class CreateBanners < ActiveRecord::Migration
  def self.up
    create_table :banners do |t|
      t.string :city
      t.string :street
      t.string :house
      t.string :stroen
      t.string :primech
      t.string :tp
      t.string :ulic
      t.string :light
      t.string :storona
      t.string :xnomer
      t.string :zametka
      t.references :contractor

      t.timestamps
    end
  end

  def self.down
    drop_table :banners
  end
end
