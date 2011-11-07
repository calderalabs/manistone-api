class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
	  t.integer :user_id, :null => false
	  t.text :text, :null => false
      t.references :resource, :polymorphic => { :default => 'Stone' }
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
