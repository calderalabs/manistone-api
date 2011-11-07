class ApplicationController < ActionController::Base
    protect_from_forgery

    helper_method :current_session, :current_user

    alias :old_render :render

    def render(options = nil, extra_options = {}, &block)
        options[:callback] = params[:callback] if options.is_a?(Hash) && options[:json] && request.get?

        old_render(options, extra_options, &block)
    end

    private
	def current_session
        return @current_session if defined?(@current_session)
        @current_session = UserSession.find
	end
	
	def current_user
        return @current_user if defined?(@current_user)
        @current_user = current_session && current_session.user
	end
	
	def require_user
		render :json => { :success => false }, :status => :unauthorized unless current_user
	end
		
	def require_no_user
		render :json => { :success => false }, :status => :unauthorized if current_user
	end
end
