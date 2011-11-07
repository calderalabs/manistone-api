class FavoriteStack < ActiveRecord::Base
	belongs_to :user, :counter_cache => true
	belongs_to :stack, :counter_cache => :favorited_by_users_count
	
	validates_uniqueness_of :stack_id, :scope => :user_id

	attr_accessible :stack_id
end
