class DeletedMessage < ActiveRecord::Base
	belongs_to :message
	belongs_to :user
	after_save :delete_message
	
	validates_uniqueness_of :message_id, :scope => :user_id

	attr_accessible :message_id

	def delete_message
		message.destroy if Message.where("messages.id = #{message.id} AND messages.id
		IN (SELECT deleted_messages.message_id FROM deleted_messages WHERE deleted_messages.user_id = messages.user_id)
		AND messages.id IN (SELECT deleted_messages.message_id FROM deleted_messages WHERE deleted_messages.user_id
		IN (SELECT recipients.user_id FROM recipients WHERE recipients.message_id = messages.id))").count != 0
	end
end
