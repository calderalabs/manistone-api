class StackedStonesController < ApplicationController
	before_filter :require_user
	
	def create
		@stacked_stone = StackedStone.new(params[:stacked_stone])
		
		respond_to do |format|
			format.json {
				if @stacked_stone.save
					render :json => @stacked_stone.stack.serializable_hash_for_user(current_user), :status => :created
				else
					render :json => { :success => false }, :status => :unprocessable_entity
				end
			}
		end
	end
	
	def update
		@stacked_stone = StackedStone.find_by_stone_id_and_stack_id(params[:stone_id], params[:stack_id])
		
		respond_to do |format|
			format.json {
				if @stacked_stone.update_attributes(params[:stacked_stone])
					render :json =>  @stacked_stone.stack.serializable_hash_for_user(current_user)
				else
					render :json => { :success => false }, :status => :unprocessable_entity
				end
			}
		end
	end
	
	def destroy
		@stacked_stone = StackedStone.find_by_stone_id_and_stack_id(params[:stone_id], params[:stack_id])
		
		respond_to do |format|
			format.json {
				if @stacked_stone.destroy
					render :json =>  @stacked_stone.stack.serializable_hash_for_user(current_user)
				else
					render :json => { :success => false }, :status => :unprocessable_entity
				end
			}
		end
	end
end
