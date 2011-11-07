class FavoriteStone < ActiveRecord::Base
	belongs_to :user, :counter_cache => true
	belongs_to :stone, :counter_cache => :favorited_by_users_count
	
	validates_uniqueness_of :stone_id, :scope => :user_id

	attr_accessible :stone_id
end
