class Dedication < ActiveRecord::Base
	belongs_to :dedicated_user, :class_name => 'User'
	belongs_to :user
	belongs_to :stone

	attr_accessible :dedicated_user_id, :stone_id

	validate :validate_dedicated_user

	def validate_dedicated_user
		errors.add_to_base("#{self.dedicated_user.full_name} has blocked you") if self.dedicated_user.blocked_users.exists?(:blocked_user_id => user.id)
	end

	def serializable_hash(options = nil)
		super(:include => {
			:stone => {
				:only => [:id, :engraving]
			},
			:user => {
				:only => [:id, :name, :surname],
				:methods => [:has_photo]
			},
		},
		:only => [:id, :created_at, :unread])
	end
end
