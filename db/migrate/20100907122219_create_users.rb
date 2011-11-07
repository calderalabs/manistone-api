class CreateUsers < ActiveRecord::Migration
	def self.up
		create_table :users do |t|
			t.string    :name, :null => false
			t.string    :surname, :null => false
			t.datetime  :birthday
			t.string    :hometown
			t.string    :current_city
			t.integer   :gender, :default => 0
			t.text      :informations
			t.string    :website
			t.boolean   :share_email, :null => false, :default => true
			t.boolean   :share_birthday, :null => false, :default => true
	
			t.integer   :followers_count, :default => 0
			t.integer   :favorite_users_count, :default => 0
			t.integer   :followed_users_count, :default => 0
			t.integer   :favorited_by_users_count, :default => 0
			t.integer   :blocked_users_count, :default => 0
			t.integer   :blocked_by_users_count, :default => 0
			t.integer   :stones_count, :default => 0
			t.integer   :comments_count, :default => 0
			t.integer   :favorite_stones_count, :default => 0
			t.integer   :stone_votes_count, :default => 0
			t.integer   :viewed_stones_count, :default => 0
			t.integer   :flagged_stones_count, :default => 0
			
			t.integer   :stacks_count, :default => 0
			t.integer   :favorite_stacks_count, :default => 0
			t.integer   :stack_votes_count, :default => 0
			t.integer   :viewed_stacks_count, :default => 0
			
			t.string    :email,               :null => false, :unique => true
			t.string    :crypted_password,    :null => false
			t.string    :password_salt,       :null => false
			t.string    :persistence_token,   :null => false
			t.string    :single_access_token, :null => false
			t.string    :perishable_token,    :null => false
			t.boolean   :active,              :null => false, :default => false
			t.integer   :login_count,         :null => false, :default => 0
			t.integer   :failed_login_count,  :null => false, :default => 0
			t.datetime  :last_request_at
			t.datetime  :current_login_at
			t.datetime  :last_login_at
			t.string    :current_login_ip
			t.string    :last_login_ip
	
			t.timestamps
		end
	end

	def self.down
		drop_table :users
	end
end
