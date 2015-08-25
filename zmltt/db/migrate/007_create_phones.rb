class CreatePhones < ActiveRecord::Migration
  def self.up
    create_table :phones do |t|
      t.references :contact
      t.string :number
      t.string :tip
      t.string :visible, :default => 'false'
      t.timestamps
    end
  end

  def self.down
    drop_table :phones
  end
end
