class FavoriteUser < ActiveRecord::Base
	belongs_to :user, :counter_cache => true
	belongs_to :favorite_user, :counter_cache => :favorited_by_users_count, :class_name => 'User'
	
	validates_uniqueness_of :favorite_user_id, :scope => :user_id

	attr_accessible :favorite_user_id
end
