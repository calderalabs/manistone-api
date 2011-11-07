class AddDedicatedUserToDedications < ActiveRecord::Migration
  def self.up
	add_column :dedications, :dedicated_user_id, :integer
  end

  def self.down
	remove_column :dedications, :dedicated_user_id
  end
end
