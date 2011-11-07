class FollowedUsersController < ApplicationController
	before_filter :require_user
	
	def create
		@followed = current_user.followed_users.build(:followed_user_id => params[:id])
		
		respond_to do |format|
			format.json {
				if @followed.save
					render :json => User.find(params[:id]).serializable_hash_for_user(current_user)
				else
					render :json => { :success => false }, :status => :unprocessable_entity
				end
			}
		end
	end
	
	def destroy
		@followed = current_user.followed_users.find_by_followed_user_id(params[:id])
		
		respond_to do |format|
			format.json {
				if @followed.destroy
					render :json => User.find(params[:id]).serializable_hash_for_user(current_user)
				else
					render :json => { :success => false }, :status => :unprocessable_entity
				end
			}
		end
	end
end
