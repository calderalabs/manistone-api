class CreateDeletedMessages < ActiveRecord::Migration
  def self.up
    create_table :deleted_messages do |t|
      t.integer :message_id, :null => false
      t.integer :user_id, :null => false
		
      t.timestamps
    end
  end

  def self.down
    drop_table :deleted_messages
  end
end
