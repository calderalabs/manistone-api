class CreateReadMessages < ActiveRecord::Migration
  def self.up
    create_table :read_messages do |t|
      t.integer :message_id, :null => false
      t.integer :user_id, :null => false
		
      t.timestamps
    end
  end

  def self.down
    drop_table :read_messages
  end
end
