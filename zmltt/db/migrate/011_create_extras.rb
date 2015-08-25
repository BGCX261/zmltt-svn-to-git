class CreateExtras < ActiveRecord::Migration
  def self.up
    create_table :extras do |t|
      t.string :name
      t.string :who
      t.string :minsrok
      t.string :coast
      t.string :realcoast
      t.timestamps
    end
  end

  def self.down
    drop_table :extras
  end
end
