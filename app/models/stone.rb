class Stone < ActiveRecord::Base
	acts_as_taggable
	acts_as_mappable :default_units => :kms,
					 :lat_column_name => :latitude,
					 :lng_column_name => :longitude
	
	validates_presence_of :user_id, :engraving, :latitude, :longitude
	
	belongs_to :user, :counter_cache => true

	has_many :dedications, :class_name => 'Dedication', :dependent => :destroy
	
	has_many :comments, :as => :resource, :class_name => 'Comment', :dependent => :destroy
	has_many :stacks, :class_name => 'StackedStone', :dependent => :destroy
	has_many :votes, :class_name => 'StoneVote', :dependent => :destroy
	has_many :views, :class_name => 'ViewedStone', :dependent => :destroy
	has_many :favorited_by_users, :class_name => 'FavoriteStone', :dependent => :destroy

	attr_accessible :engraving, :latitude, :longitude, :tag_list

	def self.random
      if (c = count) != 0
        find(:first, :offset =>rand(c))
      end
    end
	
	def likes_count
		votes.where("rating = 1").count
	end
	
	def dislikes_count
		votes.where("rating = -1").count
	end
	
	def serializable_hash(options = nil)
	  super(:include => {
	    :user => {
			:only => [:id, :name, :surname],
			:methods => [:has_photo]
		},
		:tags => {
			:only => [:name]
		}
      }, :except => :user_id,
	  :methods => [:likes_count, :dislikes_count])
	end
	
	def serializable_hash_for_user(user, options = nil)
		options ||= {}
		
		viewed = !!(user == self.user || user.viewed_stones.exists?(:stone_id => self.id))
		followed_user = user.followed_users.find_by_followed_user_id(self.user.id)
		
		hash = serializable_hash(options).merge({
			:favorited => user.favorite_stones.exists?(:stone_id => self.id),
			:liked => user.stone_votes.exists?(:stone_id => self.id, :rating => 1),
			:disliked => user.stone_votes.exists?(:stone_id => self.id, :rating => -1),
			:viewed => viewed,
			:unread => !!(!viewed && (followed_user && created_at > followed_user.created_at))
		})

		hash.reject! { |key, value| !options[:only].include?(key) } if options[:only].is_a?(Array)
		hash.reject! { |key, value| options[:except].include?(key) } if options[:except].is_a?(Array)
		hash
	end
end
