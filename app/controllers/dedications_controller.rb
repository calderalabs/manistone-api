class DedicationsController < ApplicationController
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
		
		
		@dedications = Dedication.where("dedicated_user_id = #{current_user.id}")
		@dedications = @dedications.order("created_at DESC")

		@dedications = @dedications.paginate(:page => page, :per_page => per_page)
		
		respond_to do |format|
			format.json {
				render :json => { :results => @dedications, :count => @dedications.total_entries, :pages => @dedications.total_pages, :page => @dedications.current_page }
			}
		end
	end

	def create
		@dedication = current_user.sent_dedications.build(params[:dedication])
		
		respond_to do |format|
			format.json {
				if @dedication.save
					render :json => { :success => true }
				else
					render :json => { :errors => @dedication.errors.full_messages }, :status => :unprocessable_entity
				end
			}
		end
	end

	def destroy
		respond_to do |format|
			format.json {
				if current_user.received_dedications.find(params[:id]).destroy
					render :json => { :success => true }
				else
					render :json => { :success => false }, :status => :unprocessable_entity
				end
			}
		end
	end
end
