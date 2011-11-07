class SessionsController < ApplicationController
	before_filter :require_no_user, :only => [:create]
	before_filter :require_user, :only => [:destroy]
	
	def create
		@user_session = UserSession.new(params[:user_session])
		
		if @user_session.save
			render :json => @user_session.user.serializable_hash(:only => [:id, :birthday, :gender], :methods => []), :status => :created
		else
			render :json => { :success => false }, :status => :unauthorized
		end
	end
	
	def destroy
		current_session.destroy
		
		render :json => { :success => true }, :status => :ok
	end
end
