class AccountsController < ApplicationController
	before_filter :require_no_user, :only => [:activate, :resend_activation, :create, :forgot_password, :reset_password]
	before_filter :require_user, :only => [:update]

    	def activate
		@user = User.find_using_perishable_token(params[:id], 1.week)
		
		if @user && !@user.active? && @user.activate!
			UserMailer.welcome_email(@user).deliver
			UserSession.create(@user, false)
			
			render :json => { :success => true }
		else
			render :json => { :error => 'There was a problem activating your account.' }, :status => :unprocessable_entity
		end
    	end
	
	def resend_activation
		if params[:email]
			@user = User.find_by_email(params[:email])
			
			if @user && !@user.active?
				UserMailer.activation_email(@user, "http://www.manistone.net/activate.php?token=" + @user.perishable_token.to_s).deliver
				render :json => { :success => true }
			else
				render :json => { :success => false }, :status => :unprocessable_entity
			end
		end
	end

	def forgot_password
		if params[:email]
			@user = User.find_by_email(params[:email])
			
			if @user && @user.active?
				@user.reset_perishable_token!
				UserMailer.password_reset_email(@user, "http://www.manistone.net/reset_password.php?token=" + @user.perishable_token.to_s).deliver
				render :json => { :success => true }
			else
				render :json => { :success => false }, :status => :unprocessable_entity
			end
		end
	end

	def reset_password
		@user = User.find_using_perishable_token(params[:id], 1.week)
		
		if @user && @user.active?
			if params[:user][:password].blank?
				render :json => { :success => false }

				return
			end

			@user.password = params[:user][:password]  
			@user.password_confirmation = params[:user][:password_confirmation]  

			if @user.save
				render :json => { :success => true }
			else
				render :json => { :errors => @user.errors.full_messages }, :status => :unprocessable_entity
			end
		end
	end

	def decode_photo
		unless params[:user][:photo].blank?
			@user.photo = StringIO.new(ActiveSupport::Base64.decode64(params[:user][:photo]))
			params[:user].delete("photo")
		end
	end
	
	def create
		@user = User.new(params[:user])
		
		decode_photo
		
		if @user.save
			UserMailer.activation_email(@user, "http://www.manistone.net/activate.php?token=" + @user.perishable_token.to_s).deliver
			render :json => { :success => true }
		else
			render :json => { :errors => @user.errors.full_messages }, :status => :unprocessable_entity
		end
	end
	
	def update
		@user = current_user
		
		if(params[:user][:delete_photo])
			params[:user].delete("delete_photo")
			@user.photo = nil
		else
			decode_photo
		end
	
		respond_to do |format|
			if @user.update_attributes(params[:user])
				format.json {
					render :json => current_user.serializable_hash_for_user(@user, { :include_privacy_settings => true })
				}
			else
				format.json {
					render :json => { :errors => @user.errors.full_messages }, :status => :unprocessable_entity
				}
			end
		end
	end
end
