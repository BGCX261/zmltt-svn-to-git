class Korpus < ActiveRecord::Migration
  def self.up
    add_column :banners, :korpus, :string
  end

  def self.down
    remove_column :banners, :korpus
  end
end
