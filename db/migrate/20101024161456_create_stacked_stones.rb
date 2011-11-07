class CreateStackedStones < ActiveRecord::Migration
  def self.up
    create_table :stacked_stones do |t|
	  t.integer :stone_id, :null => false
	  t.integer :stack_id, :null => false
	  t.integer :position
	  
      t.timestamps
    end
  end

  def self.down
    drop_table :stacked_stones
  end
end
