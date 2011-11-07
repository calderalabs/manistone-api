class FavoriteStonesController < ApplicationController
	before_filter :require_user
	
	def create
		@favorite = current_user.favorite_stones.build(:stone_id => params[:id])
		
		respond_to do |format|
			format.json {
				if @favorite.save
					render :json => Stone.find(params[:id]).serializable_hash_for_user(current_user)
				else
					render :json => { :success => false }, :status => :unprocessable_entity
				end
			}
		end
	end
	
	def destroy
		@favorite = current_user.favorite_stones.find_by_stone_id(params[:id])
		
		respond_to do |format|
			format.json {
				if @favorite.destroy
					render :json => Stone.find(params[:id]).serializable_hash_for_user(current_user)
				else
					render :json => { :success => false }, :status => :unprocessable_entity
				end
			}
		end
	end
end
