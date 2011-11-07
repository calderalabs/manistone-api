class FavoriteUsersController < ApplicationController
	before_filter :require_user
	
	def create
		@favorite = current_user.favorite_users.build(:favorite_user_id => params[:id])
		
		respond_to do |format|
			format.json {
				if @favorite.save
					render :json => @favorite.favorite_user.serializable_hash_for_user(current_user)
				else
					render :json => { :success => false }, :status => :unprocessable_entity
				end
			}
		end
	end
	
	def destroy
		@favorite = current_user.favorite_users.find_by_favorite_user_id(params[:id])
		
		respond_to do |format|
			format.json {
				if @favorite.destroy
					render :json => @favorite.favorite_user.serializable_hash_for_user(current_user)
				else
					render :json => { :success => false }, :status => :unprocessable_entity
				end
			}
		end
	end
end
