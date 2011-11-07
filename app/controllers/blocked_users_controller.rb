class BlockedUsersController < ApplicationController
	before_filter :require_user
	
	def create
		@blocked = current_user.blocked_users.build(:blocked_user_id => params[:id])
		
		respond_to do |format|
			format.json {
				if @blocked.save
					render :json => User.find(params[:id]).serializable_hash_for_user(current_user)
				else
					render :json => { :success => false }, :status => :unprocessable_entity
				end
			}
		end
	end
	
	def destroy
		@blocked = current_user.blocked_users.find_by_blocked_user_id(params[:id])
		
		respond_to do |format|
			format.json {
				if @blocked.destroy
					render :json => User.find(params[:id]).serializable_hash_for_user(current_user)
				else
					render :json => { :success => false }, :status => :unprocessable_entity
				end
			}
		end
	end
end
