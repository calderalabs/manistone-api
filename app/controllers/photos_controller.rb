class PhotosController < ApplicationController
	def show
		@user = User.find(params[:id])
		
		style = params[:style]
		
		style ||= "normal"
		
		redirect_to @user.photo.url(style.to_sym)
	end
end
