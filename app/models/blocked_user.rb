class BlockedUser < ActiveRecord::Base
	belongs_to :user, :counter_cache => true
	belongs_to :blocked_user, :counter_cache => :blocked_by_users_count, :class_name => 'User'
	
	validates_uniqueness_of :blocked_user_id, :scope => :user_id

	attr_accessible :blocked_user_id
end
