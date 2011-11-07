class CreateDedications < ActiveRecord::Migration
  def self.up
    create_table :dedications do |t|
      t.integer :stone_id, :null => false
      t.integer :user_id, :null => false
      t.boolean :unread, :default => true
  
      t.timestamps
    end
  end

  def self.down
    drop_table :dedications
  end
end
