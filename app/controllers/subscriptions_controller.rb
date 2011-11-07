class SubscriptionsController < ApplicationController
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
		
		@users = User.where("users.id IN (SELECT followed_user_id FROM followed_users WHERE user_id = #{current_user.id})")

		@users = @users.paginate(:page => page, :per_page => per_page)
		
		users = []
		
		@users.each do |user|
			users << user.serializable_hash(:feed_representation_for_user => current_user)
		end
		
		respond_to do |format|
			format.json {
				render :json => { :results => users, :count => @users.total_entries, :pages => @users.total_pages, :page => @users.current_page }
			}
		end
	end
end
