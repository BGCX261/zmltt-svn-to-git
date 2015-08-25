class CreateDogovors < ActiveRecord::Migration
  def self.up
    create_table :dogovors do |t|
      t.text :dogovor
      t.string :tip
      t.text :shapka
      t.text :tail
      t.date :data
      t.string :status
      t.references :client
      t.references :ourfirm
      t.timestamps
    end
  end

  def self.down
    drop_table :dogovors
  end
end
