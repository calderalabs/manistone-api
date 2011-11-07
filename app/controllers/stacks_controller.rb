class StacksController < ApplicationController
	before_filter :require_user, :except => [:index, :show]
	
	def show
		@stack = Stack.find(params[:id])
		
		respond_to do |format|
			format.json {
				render :json => (current_user ? @stack.serializable_hash_for_user(current_user) : @stack)
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
		
		@stacks = Stack.where({})
		@stacks = @stacks.where(['LOWER(name) LIKE LOWER(?)', "%#{params[:q]}%"]) if params[:q]

		@stacks = @stacks.where(['? NOT IN (SELECT stone_id FROM stacked_stones WHERE stacks.id = stack_id)', params[:stone_id]]) if params[:stone_id]
		@stacks = @stacks.where(['? IN (SELECT stone_id FROM stacked_stones WHERE stacks.id = stack_id)', params[:stacked_stone_id]]) if params[:stacked_stone_id]
		@stacks = @stacks.where(['user_id = ?', params[:user_id]]) if params[:user_id]

		@stacks = @stacks.where(['id IN (SELECT stack_id FROM favorite_stacks WHERE favorite_stacks.user_id = ?)', params[:favorited_by_user_id]]) if params[:favorited_by_user_id]

		if !params[:sort] || params[:sort] == "date"
			@stacks = @stacks.order('created_at DESC, id ASC')
		elsif params[:sort] == "votes"
			@stacks = @stacks.select('*, COALESCE((SELECT SUM(rating) FROM stack_votes WHERE stack_id = stacks.id), 0) AS rating')
			@stacks = @stacks.order('rating DESC, id ASC')
		elsif params[:sort] == "views"
			@stacks = @stacks.order('views_count DESC, id ASC')
		end

		@stacks = @stacks.paginate(:page => page, :per_page => per_page)
		
		stacks = []
		
    options =  {
        :include => {
          :user => {
            :only => [:id, :name, :surname]
          }
        }
    }
    
		@stacks.each do |stack|
			stacks << (current_user ? stack.serializable_hash_for_user(current_user, options) : stack.serializable_hash(options))
		end
		
		respond_to do |format|
			format.json {
				render :json => { :results => stacks, :count => @stacks.total_entries, :pages => @stacks.total_pages, :page => @stacks.current_page }
			}
		end
	end
	
	def create
		@stack = current_user.stacks.build(params[:stack])
		
		respond_to do |format|
			if @stack.save
				format.json {
					render :json => @stack
				}
			else
				format.json {
					render :json => { :errors => @stack.errors.full_messages }, :status => :unprocessable_entity
				}
			end
		end
			
	end
	
	def update
		@stack = Stack.find(params[:id])
		
		respond_to do |format|
			if @stack.update_attributes(params[:stack])
				format.json {
					render :json => @stack
				}
			else
				format.json {
					render :json => { :errors => @stack.errors.full_messages }, :status => :unprocessable_entity
				}
			end
		end
			
	end

	def destroy
		@stack = Stack.find(params[:id])
		
		respond_to do |format|
			if @stack.destroy
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
