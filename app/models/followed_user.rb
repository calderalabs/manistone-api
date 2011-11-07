class FollowedUser < ActiveRecord::Base
	belongs_to :user, :counter_cache => true
	belongs_to :followed_user, :counter_cache => :followers_count, :class_name => 'User'
	
	validates_uniqueness_of :followed_user_id, :scope => :user_id

	attr_accessible :followed_user_id
end
