class FavoritesController < ApplicationController
	def counts
		@user = User.find(params[:id])
		
		respond_to do |format|
			format.json {
				render :json => {
					:stones_count => @user.favorite_stones_count,
					:stacks_count => @user.favorite_stacks_count,
					:users_count => @user.favorite_users_count
				}
			}
		end
	end
end
