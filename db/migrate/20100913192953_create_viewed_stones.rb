class CreateViewedStones < ActiveRecord::Migration
  def self.up
	create_table :viewed_stones do |t|
		t.integer :stone_id, :null => false
		t.integer :user_id, :null => false
		
		t.timestamps
	end
  end

  def self.down
	drop_table :viewed_stones
  end
end
