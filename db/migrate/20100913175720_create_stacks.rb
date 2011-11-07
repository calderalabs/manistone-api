class CreateStacks < ActiveRecord::Migration
  def self.up
    create_table :stacks do |t|
	  t.integer :user_id, :null => false
	  t.string :name, :null => false
	  
	  t.integer :stones_count, :default => 0
	  t.integer :votes_count, :default => 0
	  t.integer :comments_count, :default => 0
	  t.integer :views_count, :default => 0
	  t.integer :favorited_by_users_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :stacks
  end
end
