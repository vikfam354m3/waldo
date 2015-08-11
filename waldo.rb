#!/usr/bin/ruby

require 'gtk3'


load 'algo.rb'

class Maze < Gtk::Window  
	@smap
	@solution
	def initialize
		  @smap = StateMap.new
		  s = Solver.new
		  @solution = s.Solve(@smap.getMap, @smap.wheresWaldo)
#		  g = Gene.new @smap.getMap, @smap.wheresWaldo
#		  g.random

		  super
        set_title "Basic shapes"
        signal_connect "destroy" do 
            Gtk.main_quit 
        end
        
        init_ui

        set_default_size 500, 500
        set_window_position :center
        
        show_all
    end
    
    def init_ui
    
        @darea = Gtk::DrawingArea.new  
        
        @darea.signal_connect "draw" do  
            on_draw
        end
    
        add @darea
    end
    
    def on_draw
    
        cr = @darea.window.create_cairo_context  
        draw_shapes cr
    end
    
    def draw_shapes cr 
        (0..99).each do |i|
        		coords = translate_toc(i)
        		x = coords[0]
        		y = coords[1]
        		draw_entrance cr, x, y if @smap.getAt(x, y)== 2
        		draw_exit cr, x, y if @smap.getAt(x,y) == 3
        		draw_block cr, x, y if (@smap).getAt(x, y) == 1
        		draw_waldo cr, x, y if @smap.wheresWaldo==translate(x, y)
        end
        @solution.each do |foo|
        	  ###
        end
    end
    
    def draw_block cr, x, y
        cr.set_source_rgb 0.5, 0.5, 0.5
        cr.rectangle x*50, y*50, 50, 50
        cr.fill
        
    end
    
    def draw_entrance cr, x, y
    	  #draw_block cr, x, y
    	  cr.set_source_rgb 0, 0, 0.9
        cr.rectangle x*50, y*50, 50, 50
        cr.fill    	  
    end
    
    def draw_exit cr, x, y
    	  #draw_block cr, x, y
    	  cr.set_source_rgb 0.1, 0.75, 0.1
        cr.rectangle x*50, y*50, 50, 50
        cr.fill
    end
    
    def draw_waldo cr, x, y
    	  cr.set_source_rgb 0.9, 0.2, 0.2
    	  cr.rectangle (x*50)+5, (y*50)+5, 40, 40
    	  cr.fill
    end
    	  
end

Gtk.init
	window = Maze.new
Gtk.main
