class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.string :name    
      t.string :login
      t.string :adresreal
      t.string :password
      
      t.date :contact
      t.text :zametka
      t.timestamps
    end
  end

  def self.down
    drop_table :clients
  end
end
