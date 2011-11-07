class TagsController < ApplicationController
	include ActsAsTaggableOn
	
	before_filter :require_user, :except => :index
	
	def index
		per_page = params[:per_page].to_i
		
		if per_page < 1
			per_page = 10
		elsif per_page > 60
			per_page = 60
		end
		
		page = params[:page].to_i
		
		if page < 1
			page = 1
		end
		
		@tags = Stone.tag_counts.where({})
		@tags = @tags.where(['LOWER(name) LIKE LOWER(?)', "#{params[:q]}%"]) if params[:q]
		@tags = @tags.order('count DESC, id ASC')
		@tags = @tags.paginate(:page => page, :per_page => per_page)
		
		respond_to do |format|
			format.json {
				render :json => { :results => @tags,:count => @tags.total_entries, :pages => @tags.total_pages, :page => @tags.current_page }
			}
		end
	end
end
