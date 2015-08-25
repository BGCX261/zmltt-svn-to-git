class AddContactOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :contact, :date, :default => Time.now.to_date
  end

  def self.down
    remove_column :orders, :contact
  end
end
