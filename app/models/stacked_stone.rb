class StackedStone < ActiveRecord::Base
	validate :validate_position
	after_save :update_positions
	after_destroy :update_positions
	after_initialize :set_position
	
	belongs_to :stack, :counter_cache => :stones_count
	belongs_to :stone, :counter_cache => :stacks_count
	
	validates_uniqueness_of :stone_id, :scope => :stack_id
	
	attr_accessible :stack_id, :stone_id, :position

	attr_accessor :skip_update_positions
	
	def validate_position
		errors.add(:position, "must be in stones range") if self.position < 0 || self.position > stack.stones.count
	end
	
	def update_positions
		if skip_update_positions
			skip_update_positions = false
			return true
		end
		
		stacked_stones = stack.stacked_stones.to_a
		
		stacked_stones.delete_if { |s|
			s.id == self.id
		}
		
		stacked_stones.insert(position, self) if !self.destroyed?
		
		stacked_stones.each_index do |index|
			stacked_stone = stacked_stones.at(index)
			stacked_stone.skip_update_positions = true
			stacked_stone.position = index
			stacked_stone.save!
		end

	end

	def set_position
		self.position = stack.stones.count
	end
end
