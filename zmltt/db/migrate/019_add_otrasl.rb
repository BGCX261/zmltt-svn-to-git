class AddOtrasl < ActiveRecord::Migration
  def self.up
    add_column :contractors, :otrasl, :string, :default => 'Наружная реклама'
  end

  def self.down
    remove_column :contractors, :otrasl
  end
end
