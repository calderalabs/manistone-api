class CreateStackVotes < ActiveRecord::Migration
  def self.up
    create_table :stack_votes do |t|
      t.integer :stack_id, :null => false
	  t.integer :user_id, :null => false
	  
	  t.integer :rating, :null => false
	  
      t.timestamps
    end
  end

  def self.down
    drop_table :stack_votes
  end
end
