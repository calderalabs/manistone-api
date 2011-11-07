class CommentsController < ApplicationController
	before_filter :require_user
	
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
		
		@comments = Comment.where({})
		@comments = @comments.where(['LOWER(text) LIKE LOWER(?)', "%#{params[:q]}%"]) if params[:q]

		@comments = @comments.where(['LOWER(resource_type) LIKE LOWER(?)', params[:resource_type]]) if params[:resource_type]
		@comments = @comments.where(['resource_id = ?', params[:resource_id]]) if params[:resource_id]
		@comments = @comments.where(['user_id = ?', params[:user_id]]) if params[:user_id]

		@comments = @comments.order('created_at DESC, id ASC')

		@comments = @comments.paginate(:page => page, :per_page => per_page)
		
		respond_to do |format|
			format.json {
				render :json => { :results => @comments, :count => @comments.total_entries, :pages => @comments.total_pages, :page => @comments.current_page }
			}
		end
	end
	
	def create
		params[:comment][:resource_type].capitalize! if params[:comment]
		
		@comment = current_user.comments.build(params[:comment])
		
		respond_to do |format|
			if @comment.save
				format.json {
					render :json => @comment
				}
			else
				format.json {
					render :json => { :errors => @comment.errors.full_messages }, :status => :unprocessable_entity
				}
			end
		end
			
	end
	
	def destroy
		@comment = current_user.comments.find(params[:id])
		
		respond_to do |format|
			if @comment.destroy
				format.json {
					render :json => { :success => true }
				}
			else
				format.json {
					render :json => { :success => false }, :status => :unprocessable_entity
				}
			end
		end
	end
end
