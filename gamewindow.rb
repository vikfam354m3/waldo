#!/usr/bin/ruby
require('gtk3')
load 'gamestate.rb'

#Gdk::Keyval::KEY_downarrow

$SCALE = 50

class GameWindow < Gtk::Window
	@darea
	@cr
	@width
	@height
	@state
	@entrance_i
	@exit_i
	def initialize
		
		super
      set_title "Where's Waldo?"
      signal_connect "destroy" do 
      	Gtk.main_quit 
      end
      signal_connect "key_press_event" do |widget, event|
			      
 			key_down widget, event
      end
      	
      @width = 500
      @height = 500
      
     	@state = State.new 10, 10
     	
     	init_ui

     	set_default_size 500, 500
     	set_window_position :center
     	show_all

		
   end
   
	def key_down w, e
		if(e.keyval == Gdk::Keyval::KEY_Down) then
			@state.move_down
		end
		if(e.keyval == Gdk::Keyval::KEY_Up) then
			@state.move_up
		end
		if(e.keyval == Gdk::Keyval::KEY_Left) then
			@state.move_left
		end
		if(e.keyval == Gdk::Keyval::KEY_Right) then
			@state.move_right
		end

		waldox = @state.wheres_waldo_c[0]
		waldoy = @state.wheres_waldo_c[1]
		
		cntxt = @darea.window.create_cairo_context
		draw_waldo cntxt, waldox, waldoy 
		if(@state.get_state == $STATE_FINISHED) then
			w.set_title "Press R and Fill in the board for an optical illusion"
	   	cntxt.set_source_rgb 1, 1, 0.9
	   	cntxt.rectangle 0, 0, @width, @height
	   	cntxt.fill
		end
		if((@state.get_state == $STATE_FINISHED) && (e.keyval == Gdk::Keyval::KEY_R)) then
			@state.set_state $STATE_BONUS
		end
		
		if(@state == $STATE_BONUS) then
			w.set_title "Bonus Round!"
		end	
	end   
   
   
   def init_ui
   	  @darea = Gtk::DrawingArea.new  
        
        @darea.signal_connect "draw" do  
            on_draw
        end
    
        add @darea 
   end
   
   def on_draw
        @cr = @darea.window.create_cairo_context 
        draw_waldo @cr, @state.wheres_waldo_c[0], @state.wheres_waldo_c[1]
        (0..(@state.get_width)).each do |i|
           (0..(@state.get_height)).each do |j|
           		if(@state.get_map.value(i, j)==1)
           			draw_block @cr, i, j
           	   end
           	   if(@state.get_map.value(i, j)==2)
           	   	draw_entrance @cr, i, j
           	   end
           	   if(@state.get_map.value(i, j)==3)
           	   	draw_exit @cr, i, j
           	   end
           	end
        end

   end

   def draw_waldo cr, x, y
   	cr.set_source_rgb 0.1, 0.1, 0
    	cr.rectangle (x*$SCALE)+($SCALE/10), (y*$SCALE)+($SCALE/10), 40, 40
    	cr.fill
   end
   
   
    def draw_block cr, x, y
        cr.set_source_rgb 0.5, 0.5, 0.5
        cr.rectangle x*$SCALE+($SCALE/20), y*$SCALE+($SCALE/20), ($SCALE)-($SCALE/10), (($SCALE)-($SCALE/10))
        cr.fill
        
    end
    
    def draw_entrance cr, x, y
    	  #draw_block cr, x, y
    	  cr.set_source_rgb 0, 0, 0.9
        cr.rectangle x*$SCALE+($SCALE/20), y*$SCALE+($SCALE/20), ($SCALE)-($SCALE/10), (($SCALE)-($SCALE/10))
        cr.fill    	  
    end
    
    def draw_exit cr, x, y
    	  #draw_block cr, x, y
    	  cr.set_source_rgb 0.1, 0.75, 0.1
        cr.rectangle x*$SCALE+($SCALE/20), y*$SCALE+($SCALE/20), ($SCALE)-($SCALE/10), (($SCALE)-($SCALE/10))
        cr.fill
    end
    
end

###
###
#TEST

