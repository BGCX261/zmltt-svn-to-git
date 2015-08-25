class CreateRekvizits < ActiveRecord::Migration
  def self.up
    create_table :rekvizits do |t|
      t.references :client
      t.references :ourfirm
      t.string :name
      t.string :adressur
      t.string :inn
      t.string :kpp
      t.string :rschet
      t.string :bank
      t.string :kschet
      t.string :bik
      
      t.string :gendir, :default => 'Генеральный директор'
      t.string :gendirosn, :default => 'устава'
      t.string :gendirname
      t.string :gendirfam
      t.string :gendirotch
      
      t.string :bux, :default => 'Главный бухгалтер'
      t.string :buxname
      t.string :buxfam
      t.string :buxotch
      t.timestamps
    end
  end

  def self.down
    drop_table :rekvizits
  end
end
