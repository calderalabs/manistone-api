class StonesController < ApplicationController
	include Geokit
	before_filter :require_user, :except => [:index, :show]
	
	def show
		if(params[:id].to_i == 0)
			@stone = Stone.random
		else
			@stone = Stone.find(params[:id])
		end
		
		if current_user && !current_user.viewed_stones.exists?(:stone_id => @stone.id)
			@viewed = current_user.viewed_stones.build(:stone_id => @stone.id)
			@viewed.save!
		end
		
		if current_user && current_user.received_dedications.exists?(:stone_id => @stone.id)
			dedication = current_user.received_dedications.find_by_stone_id(@stone.id)
			dedication.unread = false
			dedication.save!
		end

		respond_to do |format|
			format.json {
				render :json => (current_user ? @stone.serializable_hash_for_user(current_user) : @stone)
			}
		end
	end
	
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
		
		scope = 'engraving'
		
		if ['engraving', 'tags'].include?(params[:scope])
			scope = params[:scope]
		end
		
		@stones = Stone.where({})

		@stones = @stones.select('stones.*')

		@related_stones = []
		@related_tags = []
		
		if params[:tag_name]
			@stones = @stones.tagged_with(params[:tag_name]) 
			related_stones = Stone.tagged_with(params[:tag_name]).to_a
			@related_tags = related_stones.collect{ |s| s.tags}.flatten.uniq
			@related_tags.delete_if{ |s| s.name == params[:tag_name]}
		end
		
		if params[:q]
			if scope == 'engraving'
				@stones = @stones.where(["LOWER(engraving) LIKE LOWER(?)", "%#{params[:q]}%"])
			elsif scope == 'tags'
				@stones = @stones.tagged_with(params[:q].split.map { |t| t.downcase })
			end
		end
		
		if params[:bounds]
			bounds = params[:bounds].split(',')
			
			swpoint = [bounds[0].to_f, bounds[1].to_f]
			nepoint = [bounds[2].to_f, bounds[3].to_f]
			
			@stones = @stones.in_bounds([swpoint, nepoint]) if bounds.size == 4
		end
		
		if params[:origin]
			radius = params[:radius].to_f
			radius = 10 if radius < 10
			
			origin = params[:origin].split(',')
			
			radius /= 1000
			
			@stones = @stones.within(radius, :origin => [origin[0].to_f, origin[1].to_f]) if origin.size == 2
		end
		
		@stones = @stones.where(['user_id = ?', params[:user_id]]) if params[:user_id]
		
		@stones = @stones.where(['id IN (SELECT stone_id FROM favorite_stones WHERE favorite_stones.user_id = ?)', params[:favorited_by_user_id]]) if params[:favorited_by_user_id]
		
		if !params[:sort] || params[:sort] == "date"
			@stones = @stones.order('stones.created_at DESC')
		elsif params[:sort] == "votes"
			@stones = @stones.select('COALESCE((SELECT SUM(rating) FROM stone_votes WHERE stone_id = stones.id), 0) AS rating')
			@stones = @stones.order('rating DESC, comments_count DESC, views_count DESC')
		elsif params[:sort] == "views"
			@stones = @stones.order('views_count DESC')
		end

		@stones = @stones.paginate(:page => page, :per_page => per_page)
		
		stones = []
		
		@stones.each do |stone|
			stones << (current_user ? stone.serializable_hash_for_user(current_user) : stone.serializable_hash)
		end
		
		respond_to do |format|
			format.json {
				render :json => ActiveSupport::JSON.decode({
					:related_tags => @related_tags,
					:results => stones,
					:count => @stones.total_entries,
					:pages => @stones.total_pages,
					:page => @stones.current_page
				}.to_json)
			}
		end
	end
	
	def create
		@stone = current_user.stones.build(params[:stone])
		
		respond_to do |format|
			if @stone.save
				format.json {
					render :json => @stone.serializable_hash_for_user(current_user)
				}
			else
				format.json {
					render :json => { :errors => @stone.errors.full_messages }, :status => :unprocessable_entity
				}
			end
		end
			
	end
	
	def update
		@stone = Stone.find(params[:id])
		
		respond_to do |format|
			if @stone.update_attributes(params[:stone])
				format.json {
					render :json => @stone.serializable_hash_for_user(current_user)
				}
			else
				format.json {
					render :json => { :errors => @stone.errors.full_messages }, :status => :unprocessable_entity
				}
			end
		end
			
	end
	
	def destroy
		@stone = current_user.stones.find(params[:id])
		
		respond_to do |format|
			if @stone.destroy
				format.json {
					render :json => { :success => true }
				}
			else
				format.json {
					render :json => { :success => false }, :status => :unprocessable_entity
				}
			end
		end
	end
end
