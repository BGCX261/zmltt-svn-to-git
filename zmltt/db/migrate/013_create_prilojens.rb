class CreatePrilojens < ActiveRecord::Migration
  def self.up
    create_table :prilojens do |t|
      t.references :order
      t.text :prilojen
      t.timestamps
    end
  end

  def self.down
    drop_table :prilojens
  end
end
