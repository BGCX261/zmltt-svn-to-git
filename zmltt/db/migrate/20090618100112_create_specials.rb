class CreateSpecials < ActiveRecord::Migration
  def self.up
    create_table :specials do |t|
		t.string :name
		t.string :msg
		t.column "content_type", :string
	    t.column "filename", :string
		t.column "size", :integer
		t.column "parent_id",  :integer 
		t.column "db_file_id", :integer
		t.timestamps
    end
  end

  def self.down
    drop_table :specials
  end
end
