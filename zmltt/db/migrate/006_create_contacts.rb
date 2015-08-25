class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.references :client
      t.references :contractor
      t.string :name
      t.string :post
      t.string :visible, :default => 'false'
      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
