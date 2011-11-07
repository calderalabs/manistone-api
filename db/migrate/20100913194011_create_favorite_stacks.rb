class CreateFavoriteStacks < ActiveRecord::Migration
  def self.up
	create_table :favorite_stacks do |t|
		t.integer :user_id, :null => false
		t.integer :stack_id, :null => false
		
		t.timestamps
	end
  end

  def self.down
	drop_table :favorite_stacks
  end
end
