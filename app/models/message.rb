class Message < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :recipients, :class_name => 'User', :join_table => 'recipients'
	has_many :readings, :class_name => 'ReadMessage', :dependent => :destroy
	has_many :deletions, :class_name => 'DeletedMessage', :dependent => :destroy
	
	validates_presence_of :subject
	validates_presence_of :text

	validate :validate_recipients

	def validate_recipients
		self.recipients.each do |r|
			errors.add_to_base("#{r.full_name} has blocked you") if r.blocked_users.exists?(:blocked_user_id => user.id)
		end
	end

	def serializable_hash_for_user(user, options = nil)
		options ||= {}
		
		hash = serializable_hash(options).merge({
			:unread => user != self.user && !user.read_messages.exists?(:message_id => self.id),
		})
		
		hash.reject! { |key, value| !options[:only].include?(key) } if options[:only].is_a?(Array)
		hash.reject! { |key, value| options[:except].include?(key) } if options[:except].is_a?(Array)
		hash
	end
	
	def serializable_hash(options = nil)
		super(
			:only => [:id,
			:created_at,
			:text,
			:subject],
			:include => { :recipients => { :only => [:id, :name, :surname] }, :user => { :only => [:id, :name, :surname] } }
		)
	end

	attr_accessible :text, :subject, :recipient_ids
end
