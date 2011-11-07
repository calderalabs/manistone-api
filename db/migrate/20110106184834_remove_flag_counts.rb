class RemoveFlagCounts < ActiveRecord::Migration
  def self.up
	remove_column :users, :flagged_stones_count
  end

  def self.down
	add_column :users, :flagged_stones_count, :integer, :default => 0
  end
end
