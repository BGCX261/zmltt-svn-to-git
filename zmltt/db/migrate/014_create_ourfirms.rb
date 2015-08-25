class CreateOurfirms < ActiveRecord::Migration
  def self.up
    create_table :ourfirms do |t|
      t.string :ourfirm
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :ourfirms
  end
end
