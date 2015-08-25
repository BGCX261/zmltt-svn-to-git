class Newid < ActiveRecord::Migration
  def self.up
    add_column :contractors, :nid, :string
  end

  def self.down
    remove_column :contractors, :nid
  end
end
