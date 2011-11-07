class StoneVote < ActiveRecord::Base
	belongs_to :stone, :counter_cache => :votes_count
	belongs_to :user, :counter_cache => true
	
	attr_accessible :stone_id, :rating

	validates_presence_of :rating
	validates_numericality_of :rating
	validate :validate_rating
	
	def validate_rating
		errors.add(:rating, "must be either -1 or 1") if rating != -1 && rating != 1
	end
end
