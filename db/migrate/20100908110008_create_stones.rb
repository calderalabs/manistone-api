class CreateStones < ActiveRecord::Migration
  def self.up
    create_table :stones do |t|
      t.integer :user_id, :null => false
	  
	  t.integer :favorited_by_users_count, :default => 0
	  t.integer :votes_count, :default => 0
	  t.integer :views_count, :default => 0
	  t.integer :flags_count, :default => 0
	  t.integer :comments_count, :default => 0
	  t.integer :stacks_count, :default => 0
	  
	  t.text :engraving, :null => false
	  t.float :latitude, :limit => 25, :null => false
	  t.float :longitude, :limit => 25, :null => false
	  
      t.timestamps
    end
  end

  def self.down
    drop_table :stones
  end
end
