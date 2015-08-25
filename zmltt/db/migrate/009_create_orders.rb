class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.references :client
      t.references :user
      t.references :dogovor
      t.text :order
      t.text :zametka
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
