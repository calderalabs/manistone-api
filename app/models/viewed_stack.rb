class ViewedStack < ActiveRecord::Base
	belongs_to :stack, :counter_cache => :views_count
	belongs_to :user, :counter_cache => true
	
	attr_accessible :stack_id

	validates_uniqueness_of :stack_id, :scope => :user_id
end
