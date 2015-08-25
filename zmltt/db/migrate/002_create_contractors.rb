class CreateContractors < ActiveRecord::Migration
  def self.up
    create_table :contractors do |t|
      t.string :name
      t.string :fio
      t.string :tel
      t.string :zametka
      t.timestamps
    end
  end

  def self.down
    drop_table :contractors
  end
end
