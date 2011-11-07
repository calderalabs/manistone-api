class UsersController < ApplicationController
	before_filter :require_user, :except => :create
	
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
		
		names = params[:q].to_s.split
		
		@users = User.where({})
		
		@users = @users.where(['? IN (SELECT followed_user_id FROM followed_users WHERE user_id = users.id)', params[:followed_id]]) if params[:followed_id]
		@users = @users.where(['id IN (SELECT favorite_user_id FROM favorite_users WHERE favorite_users.user_id = ?)', params[:favorited_by_user_id]]) if params[:favorited_by_user_id]
		
		if names.size == 1
			@users = @users.where(['LOWER(name) LIKE LOWER(?) OR LOWER(surname) LIKE LOWER(?)', "#{names[0]}%", "#{names[0]}%"])
		elsif names.size == 2
			@users = @users.where(
				['(LOWER(name) LIKE LOWER(?) AND LOWER(surname) LIKE LOWER(?)) OR (LOWER(name) LIKE (?) and LOWER(surname) LIKE LOWER(?))',
				"#{names[0]}%",
				"#{names[1]}%",
				"#{names[1]}%",
				"#{names[0]}%",]
			)
		end
		
		if !params[:sort] || params[:sort] == "followed"
			@users = @users.order('followers_count DESC, id ASC')
		elsif params[:sort] == "active"
			@users = @users.order('stones_count DESC, id ASC')
		elsif params[:sort] == "date"
			@users = @users.order('created_at DESC, id ASC')
		end

		@users = @users.paginate(:page => page, :per_page => per_page)
		
		options = {}
		
		if params[:dedication]
			options[:only] = [:id, :name, :surname]
			options[:methods] = [:has_photo]
		end
		
		users = []
		
		@users.each do |user|
			users << user.serializable_hash(options)
		end
		
		respond_to do |format|
			format.json {
				render :json => { :results => users, :count => @users.total_entries, :pages => @users.total_pages, :page => @users.current_page }
			}
		end
	end
	
	def show
		@user = User.find(params[:id])
		
		respond_to do |format|
			format.json {
				render :json => @user.serializable_hash_for_user(current_user, { :include_privacy_settings => (params[:include_privacy_settings] && @user == current_user) })
			}
		end
	end
	
	def unread_counts
		respond_to do |format|
			format.json {
				render :json => current_user.unread_counts
			}
		end
	end
end
