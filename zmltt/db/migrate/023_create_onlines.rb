class CreateOnlines < ActiveRecord::Migration
  def self.up
    add_column :banners, :online, :string, :default => 'нет'
    create_table :onlines do |t|
      t.references :banner
      t.string :month
      t.string :coast
      t.string :realcoast
      t.timestamps
    end
  end

  def self.down
    drop_table :onlines
    remove_column :banners, :online
  end
end
