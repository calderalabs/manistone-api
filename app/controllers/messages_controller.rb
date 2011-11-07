class MessagesController < ApplicationController
	before_filter :require_user
	
	def show
		@message = current_user.messages.find(params[:id])
		
		if !current_user.read_messages.exists?(:message_id => @message.id)
			@read = current_user.read_messages.build(:message_id => @message.id)
			@read.save!
		end
		
		respond_to do |format|
			format.json {
				render :json => @message
			}
		end
	end
	
	def index
		per_page = params[:per_page].to_i
		
		if per_page < 1
			per_page = 5
		elsif per_page > 50
			per_page = 50
		end
		
		page = params[:page].to_i
		
		if page < 1
			page = 1
		end
		
		folder = "inbox"

		folder = params[:folder] if ['inbox', 'sent'].include?(params[:folder])

		if folder == 'inbox'
			@messages = current_user.received_messages.where({})
		elsif folder == 'sent'
			@messages = current_user.sent_messages.where({})
		end

		@messages = @messages.order('created_at DESC, id ASC')

		@messages = @messages.paginate(:page => page, :per_page => per_page)
		
		messages = []
		
		@messages.each do |message|
			messages << message.serializable_hash_for_user(current_user)
		end
		
		respond_to do |format|
			format.json {
				render :json => { :results => messages, :count => @messages.total_entries, :pages => @messages.total_pages, :page => @messages.current_page }
			}
		end
	end
	
	def create
		@message = current_user.sent_messages.build(params[:message])
		
		respond_to do |format|
			if @message.save
				format.json {
					render :json => @message
				}
			else
				format.json {
					render :json => { :errors => @message.errors.full_messages }, :status => :unprocessable_entity
				}
			end
		end
			
	end
	
	def destroy
		@deleted = current_user.deleted_messages.build(:message_id => params[:id])
		
		respond_to do |format|
			format.json {
				if @deleted.save
					render :json => { :success => true }
				else
					render :json => { :success => false }, :status => :unprocessable_entity
				end
			}
		end
	end
end
