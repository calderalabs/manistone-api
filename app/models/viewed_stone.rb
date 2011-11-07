class ViewedStone < ActiveRecord::Base
	belongs_to :stone, :counter_cache => :views_count
	belongs_to :user, :counter_cache => true
	
	attr_accessible :stone_id

	validates_uniqueness_of :stone_id, :scope => :user_id
end
