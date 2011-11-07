class CreateStoneVotes < ActiveRecord::Migration
  def self.up
	create_table :stone_votes do |t|
		t.integer :stone_id, :null => false
		t.integer :user_id, :null => false
		
		t.integer :rating, :null => false
		
		t.timestamps
	end
  end

  def self.down
	drop_table :stone_votes
  end
end
