class CreateFavoriteUsers < ActiveRecord::Migration
  def self.up
	create_table :favorite_users do |t|
		t.integer :user_id, :null => false
		t.integer :favorite_user_id, :null => false
		
		t.timestamps
	end
  end

  def self.down
	drop_table :favorite_users
  end
end
