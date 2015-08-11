#!/usr/bin/ruby
load 'statemap.rb'

# Genetic algorithm to solve the maze
$UP = "up"
$DOWN = "down"
$LEFT = "left"
$RIGHT = "right"

class Solver
	@map
	@waldo
	
	def initiate

	end

	def Solve _map, _waldo
		@map = _map
		@waldo = _waldo
		sm = StateMap.new
		sm.set @map, @waldo
		steps = Array.new
		done = false
		until done
			step = rand(4)
			if step == 3
			 done = sm.move_up
			 steps.push('up')
			end
			if step == 2
			 done = sm.move_down
			 steps.push('down')
			end			
			if step == 1
			 done = sm.move_left
			 steps.push('left')
			end			
			if step == 0
			 done = sm.move_right
			 steps.push('right')
			end		
		end
		print "\nSolved!\n"
		print steps
		print "\nin #{steps.length} steps"
		return steps
	end

end

class Gene
	@steps
	@sm
	def initialize map, waldo
		@sm = StateMap.new
		@sm.set map, waldo
		
		@steps = Array.new
	end
	
	def random
		(0..255).each do
			r = rand(4)
			@steps.push($UP) if r == 0
			@steps.push($DOWN) if r == 1
			@steps.push($LEFT) if r == 2
			@steps.push($RIGHT) if r == 3			
		end		
	end
	
	
	def works
		count = 0
		@steps.each do |foo|
		   count += 1
			if foo == $UP
				return true if @sm.move_up
			end
			if foo == $DOWN
				return true if @sm.move_down
			end
			if foo == $LEFT
				return true if @sm.move_left
			end
			if foo == $RIGHT
				return true if @sm.move_right
			end
		end
		
		return false 
	end	
end
