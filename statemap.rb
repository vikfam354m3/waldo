#!/usr/bin/ruby
def translate x, y
	return (10*y)+x #Happy parenthesis
end

def translate_toc z 
	#convert *to* virtual coordinates	
	return [0, 0] if z == 0 #no dbz
	x = z % 10
	return [x, 0] if (z -(z % 10)) == 0 #no dbz
	y = (z - (z % 10))/10
	return [x, y]
end


class StateMap	
		#Describes a 10x10 map encoded within a 100
		#field array--
		#0 - space
		#1 - wall
		#2 - entrance
		#3 - exit
		@map
		@waldo

		def set _map, _waldo
			@map = _map
			@waldo = _waldo
		end
		def getAt x, y
			return @map[translate x, y]		
		end
		
		def changeAt x, y, delta
			index = translate x, y
			@map[index] = delta
		end			
		
		def wheresWaldo
			return @waldo
		end
		
		def getMap
			return @map
		end		
		
		def initialize
			@map = Array.new(100, 0)
			10.times do |i|
				#top row
				changeAt i, 0, 1
				#bottom row
				changeAt 9, i, 1
				#left side
				changeAt 0, i, 1
				#right side
				changeAt i, 9, 1
			end
			#random entrance on left side (not y=0 or y=9)
			#and exit on right ... 
			entrance = rand(7)+1
			exit = rand(7)+1
			
			#fill 'em in and place waldo
			changeAt 0, entrance, 2
			@waldo = translate(0, entrance)
			
			changeAt 9, exit, 3
			
			#ok we need obstacles or it's no
			#contest - none ever possibly blocking an entrance
			#one per column (1 < x < 8)
			6.times do |i|
				changeAt i+2, (rand(6)+2), 1
			end
			

		end
					
		def move_up
			coords = translate_toc(@waldo)
			x = coords[0]
			y = coords[1]
			newx = x
			newy = y-1
			newcoords = [newx, newy]
			if (getAt(newx, newy)==0)
				@waldo = translate(newx, newy)
			elsif (getAt(newx, newy)==3)
				return true 
			end
			return false
		end
		
		def move_down
			coords = translate_toc(@waldo)
			x = coords[0]
			y = coords[1]
			newx = x
			newy = y+1
			newcoords = [newx, newy]
			if (getAt(newx, newy)==0)
				@waldo = translate(newx, newy)
			elsif (getAt(newx, newy)==3)
				return true 
			end
			return false
		end
		
		def move_left
			coords = translate_toc(@waldo)
			x = coords[0]
			y = coords[1]
			newx = x-1
			newy = y
			newcoords = [newx, newy]
			if (getAt(newx, newy)==0)
				@waldo = translate(newx, newy)
			elsif (getAt(newx, newy)==3)
				return true 
			end
			return false			
		end
		
		def move_right
			coords = translate_toc(@waldo)
			x = coords[0]
			y = coords[1]
			newx = x+1
			newy = y
			newcoords = [newx, newy]
			if (getAt(newx, newy)==0)
				@waldo = translate(newx, newy)
			elsif (getAt(newx, newy)==3)
				return true 
			end
			return false
		end

end
