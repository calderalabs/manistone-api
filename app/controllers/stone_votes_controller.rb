class StoneVotesController < ApplicationController
	before_filter :require_user
	
	def create
		@vote = current_user.stone_votes.build(params[:vote])
		old_vote = current_user.stone_votes.find_by_stone_id(params[:vote][:stone_id])
		old_vote.destroy if old_vote && @vote.valid?
		
		respond_to do |format|
			format.json {
				if @vote.save
					render :json => @vote.stone.serializable_hash_for_user(current_user)
				else
					render :json => { :success => false }, :status => :unprocessable_entity
				end
			}
		end
	end
	
	def destroy
		@vote = current_user.stone_votes.find_by_stone_id(params[:id])
		
		respond_to do |format|
			format.json {
				if @vote.destroy
					render :json => @vote.stone.serializable_hash_for_user(current_user)
				else
					render :json => { :success => false }, :status => :unprocessable_entity
				end
			}
		end
	end
end
