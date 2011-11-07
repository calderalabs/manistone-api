class CreateBlockedUsers < ActiveRecord::Migration
  def self.up
	create_table :blocked_users do |t|
		t.integer :user_id, :null => false
		t.integer :blocked_user_id, :null => false
		
		t.timestamps
	end
  end

  def self.down
	drop_table :blocked_users
  end
end
