class Comment < ActiveRecord::Base
	validates_presence_of :user_id, :resource_id, :text

	belongs_to :resource, :polymorphic => true, :counter_cache => :comments_count
	belongs_to :user, :counter_cache => true
	
	attr_accessible :text, :resource_type, :resource_id

	def serializable_hash(options = nil)
	  super(:include => {
	    :user => {
			:only => [:id, :name, :surname]
		},
		:resource => {
			:only => [:id]
		}
      }, :except => :user_id)
	end
end
