class CreatePlategs < ActiveRecord::Migration
  def self.up
    create_table :plategs do |t|
      t.references :order
      t.string :nomer
      t.string :sum
      t.string :plateg
      t.date :data
      t.timestamps
    end
  end

  def self.down
    drop_table :plategs
  end
end
