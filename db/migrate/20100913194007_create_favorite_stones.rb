class CreateFavoriteStones < ActiveRecord::Migration
  def self.up
	create_table :favorite_stones do |t|
		t.integer :user_id, :null => false
		t.integer :stone_id, :null => false
		
		t.timestamps
	end
  end

  def self.down
	drop_table :favorite_stones
  end
end
