class ReadMessage < ActiveRecord::Base
	belongs_to :message
	belongs_to :user
	
	validates_uniqueness_of :message_id, :scope => :user_id

	attr_accessible :message_id
end
