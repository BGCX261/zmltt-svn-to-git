class AddToOnlineDates < ActiveRecord::Migration
  def self.up
    add_column :onlines, :databegin, :datetime
    add_column :onlines, :dataend, :datetime
  end

  def self.down
    remove_column :onlines, :databegin
    remove_column :onlines, :dataend
  end
end
