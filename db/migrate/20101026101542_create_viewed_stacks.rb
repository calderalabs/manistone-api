class CreateViewedStacks < ActiveRecord::Migration
  def self.up
    create_table :viewed_stacks do |t|
      t.integer :stack_id, :null => false
      t.integer :user_id, :null => false
		
      t.timestamps
    end
  end

  def self.down
    drop_table :viewed_stacks
  end
end
