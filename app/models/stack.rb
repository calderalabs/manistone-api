class Stack < ActiveRecord::Base
	belongs_to :user, :counter_cache => true

	has_many :stacked_stones, :class_name => 'StackedStone', :order => 'position ASC', :dependent => :destroy
	has_many :stones, :through => :stacked_stones, :order => 'position ASC'
	has_many :votes, :class_name => 'StackVote', :dependent => :destroy
	has_many :views, :class_name => 'ViewedStack', :dependent => :destroy
	has_many :comments, :as => :resource, :class_name => 'Comment', :dependent => :destroy
	has_many :favorited_by_users, :class_name => 'FavoriteStack', :dependent => :destroy
	
	attr_accessible :name

	validates_presence_of :name, :user_id

	def likes_count
		votes.where("rating = 1").count
	end
	
	def dislikes_count
		votes.where("rating = -1").count
	end
	
	def serializable_hash(options = nil)
	  options ||= {}
	  
	  super({ :include => {
	    :user => {
			:only => [:id, :name, :surname],
			:methods => [:has_photo]
		},
		:stones => { }
      }, :except => :user_id,
	  :methods => [:likes_count, :dislikes_count]
	  }.merge(options))
	end
	
	def serializable_hash_for_user(user, options = nil)
		options ||= {}
		
		hash = serializable_hash(options).merge({
			:favorited => user.favorite_stacks.exists?(:stack_id => self.id),
			:liked => user.stack_votes.exists?(:stack_id => self.id, :rating => 1),
			:disliked => user.stack_votes.exists?(:stack_id => self.id, :rating => -1),
			:viewed =>  !!(user == self.user || user.viewed_stacks.exists?(:stack_id => self.id))
		})
		
		hash.reject! { |key, value| !options[:only].include?(key) } if options[:only].is_a?(Array)
		hash.reject! { |key, value| options[:except].include?(key) } if options[:except].is_a?(Array)
		hash
	end
end
