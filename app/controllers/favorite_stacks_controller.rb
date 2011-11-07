class FavoriteStacksController < ApplicationController
	before_filter :require_user
	
	def create
		@favorite = current_user.favorite_stacks.build(:stack_id => params[:id])
		
		respond_to do |format|
			format.json {
				if @favorite.save
					render :json => Stack.find(params[:id]).serializable_hash_for_user(current_user)
				else
					render :json => { :success => false }, :status => :unprocessable_entity
				end
			}
		end
	end
	
	def destroy
		@favorite = current_user.favorite_stacks.find_by_stack_id(params[:id])
		
		respond_to do |format|
			format.json {
				if @favorite.destroy
					render :json => Stack.find(params[:id]).serializable_hash_for_user(current_user)
				else
					render :json => { :success => false }, :status => :unprocessable_entity
				end
			}
		end
	end
end
