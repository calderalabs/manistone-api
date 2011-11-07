class User < ActiveRecord::Base
	acts_as_authentic do |c|
		c.logged_in_timeout = 1.day
	end

	has_attached_file :photo,
	:storage => :s3,
	:s3_credentials => "#{Rails.root.to_s}/config/s3.yml",
	:path => ":attachment/:id/:style.:extension",
	:styles => { :normal => "100x100>", :thumb => "60x60>" }

	validates_url_format_of :website,
                          :allow_nil => true,
                          :message => 'must be a valid URL. Try by adding http://'
	
	validates_presence_of :name, :surname, :birthday

	validate :validate_birthday

	def validate_birthday
		errors.add(:birthday, "is invalid") if 13.years.ago < birthday
	end

	default_scope where(:active => true)

	has_many :sent_dedications, :class_name => 'Dedication'
	has_many :received_dedications, :class_name => 'Dedication', :foreign_key => 'dedicated_user_id'
	has_many :stacks
	has_many :stones
	has_many :favorite_stones
	has_many :favorite_stacks
	has_many :favorite_users
	has_many :blocked_users
	has_many :followed_users
	has_many :stone_votes
	has_many :viewed_stones
	has_many :stack_votes
	has_many :viewed_stacks
	has_many :comments
	has_many :comments
	has_many :stack_votes
	has_many :deleted_messages
	has_many :read_messages
	has_many :sent_messages, :class_name => 'Message'
	has_and_belongs_to_many :received_messages, :join_table => 'recipients', :class_name => 'Message'
	
	alias_method :old_received_messages, :received_messages
	alias_method :old_sent_messages, :sent_messages
	
	attr_accessible :name, :surname, :email, :birthday, :password, :password_confirmation,
			:hometown, :gender, :current_city,
			:website, :informations, :share_birthday, :share_email

	def messages
		Message.where("user_id = #{self.id} OR
		#{self.id} IN (SELECT user_id FROM recipients WHERE message_id = messages.id) AND
		messages.id NOT IN (SELECT message_id FROM deleted_messages WHERE user_id = #{self.id})")
	end
	
	def received_messages
		old_received_messages.where("messages.id NOT IN (SELECT message_id FROM deleted_messages WHERE user_id = #{self.id})")
	end
	
	def sent_messages
		old_sent_messages.where("messages.id NOT IN (SELECT message_id FROM deleted_messages WHERE user_id = #{self.id})")
	end
	
	def full_name
		[name, surname].join(' ')
	end
	
	def activate!
		self.active = true
		save
	end
	
	def favorites_count
		favorite_stones_count + favorite_stacks_count + favorite_users_count
	end
	
	def has_photo
		return photo?
	end
	
	def unread_counts
		{
			:dedications_count => Stone.where(
				"id IN (SELECT stone_id FROM dedications WHERE dedicated_user_id = #{self.id} AND unread = TRUE)"
			).count,
			:inbox_count => Message.where(
				"id IN (SELECT message_id FROM recipients WHERE user_id = #{self.id}) AND
				id NOT IN (SELECT message_id FROM read_messages WHERE user_id = #{self.id}) AND
				id NOT in (SELECT message_id FROM deleted_messages WHERE user_id = #{self.id})"
			).count,
			:subscriptions_count => Stone.where(
				"stones.created_at > followed_users.created_at AND
				stones.id NOT IN (SELECT stone_id FROM viewed_stones WHERE user_id = #{self.id})"
			).all(:joins => "INNER JOIN followed_users ON followed_users.followed_user_id = stones.user_id AND followed_users.user_id = #{self.id}").count
		}
	end
	
	def unread_count_for_user(user)
		self.stones.where("stones.created_at > followed_users.created_at AND
		stones.id NOT IN (SELECT viewed_stones.stone_id FROM viewed_stones WHERE
		viewed_stones.user_id = #{user.id})").all(:joins => "INNER JOIN followed_users ON followed_users.followed_user_id = stones.user_id AND followed_users.user_id = #{user.id}").count
	end
	
	def serializable_hash_for_user(user, options = nil)
		options ||= {}
		
		hash = serializable_hash(options).merge({
			:favorited => user.favorite_users.exists?(:favorite_user_id => self.id),
			:followed => user.followed_users.exists?(:followed_user_id => self.id),
			:blocked => user.blocked_users.exists?(:blocked_user_id => self.id),
		})
		
		hash[:email] = email if share_email || user == self
		hash[:birthday] = birthday if share_birthday || user == self
		
		hash.reject! { |key, value| !options[:only].include?(key) } if options[:only].is_a?(Array)
		hash.reject! { |key, value| options[:except].include?(key) } if options[:except].is_a?(Array)
		hash
	end
	
	def serializable_hash(options = nil)
		options ||= {}
		
		if options[:feed_representation_for_user]
			super(:only => [:id, :created_at, :updated_at, :name, :surname], :methods => [:has_photo]).merge({
				:unread_count => unread_count_for_user(options[:feed_representation_for_user])
			})
		else
		only = [:id,
			:created_at,
			:name,
			:surname,
			:hometown,
			:gender,
			:current_city,
			:website,
			:followers_count,
			:informations,
			:stones_count,
			:stacks_count,
			:comments_count]
		
		if options[:include_privacy_settings]
			only += [:share_email, :share_birthday]
		end
		
		super({
			:only => only,
			:methods => [:favorites_count, :has_photo]
		}.merge(options))
		end
	end
end
