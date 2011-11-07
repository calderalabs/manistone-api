class CreateRecipients < ActiveRecord::Migration
  def self.up
	create_table :recipients, :id => false do |t|
		t.integer :user_id, :null => false
		t.integer :message_id, :null => false
		
		t.timestamps
	end
  end

  def self.down
	drop_table :recipients
  end
end
