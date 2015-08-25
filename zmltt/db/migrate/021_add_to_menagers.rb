class AddToMenagers < ActiveRecord::Migration
  def self.up
    add_column :users, :birthday, :datetime, :default => '01-01-1901'.to_datetime
    add_column :users, :archived, :string, :default => 'Нет'
    add_column :users, :post, :string, :default => 'Менеджер'
    add_column :users, :percent, :string, :default => '10'
    add_column :users, :status, :string, :default => 'Кадровый сотрудник'
  end

  def self.down
    remove_column :users, :archived
    remove_column :users, :birthday
    remove_column :users, :post
    remove_column :users, :percent
    remove_column :users, :status
  end
end
