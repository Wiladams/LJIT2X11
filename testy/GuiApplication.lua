--[[
	A simple example of a minimal X11 program displaying pixmap
http://www.linuxquestions.org/questions/programming-9/how-to-draw-color-images-with-xlib-339366/

--]]
package.path = package.path..";../?.lua"

local ffi = require("ffi")
local bit = require("bit")
local bor = bit.bor
local band = bit.band


--[[
	if you require X11, and call it as a function, then 
	everything in the X11 binding will be made global.
	This gives you a programming environment just like when 
	you program X11 using 'C'.

	If you don't want that behavior, then simply do:
	
	local X11 = require("X11")

	And get at the various functions you want through the 
	various table entries.
--]]
local X11 = require("x11.X11")()
local LXImage = require("x11.LXImage")

-- some global variables
local dis = nil;
local screen = nil;
local win = nil;
local gc = nil;
local vis = nil;
local img = nil;
local width = 640;
local height = 480;
local black = nil;
local white = nil;

local ZPixmap	= 2;

-- mouse information
mouseX = 0;
mouseY = 0;
local isMouseDragging = false;

-- important work routines
local function init_x(title)
	title = title or "GuiApplication"

	dis = X11.XOpenDisplay(nil);
   	screen = DefaultScreen(dis);
   	vis = X11.XDefaultVisual(dis, screen)

	blackPixel = X11.BlackPixel(dis,screen);
	whitePixel = X11.WhitePixel(dis, screen);
end

local myEvents = bor(X11.ExposureMask, 
		X11.KeyPressMask, X11.KeyReleaseMask,
		X11.ButtonPressMask,X11.ButtonReleaseMask,
		X11.PointerMotionMask)

local function size(awidth, aheight, data)
	width = awidth;
	height = aheight;


   	win = X11.XCreateSimpleWindow(dis,
   		X11.DefaultRootWindow(dis),
   		0,0,	
		width, height, 
		5,
		blackPixel, whitePixel);

	X11.XSetStandardProperties(dis,win,title,"Hi",None,nil,0,nil);


	X11.XSelectInput(dis, win, myEvents);
    
    gc = X11.XCreateGC(dis, win, 0,nil);        
	
	X11.XSetBackground(dis,gc,whitePixel);
	X11.XSetForeground(dis,gc,blackPixel);
	X11.XClearWindow(dis, win);
	X11.XMapRaised(dis, win);

	data = data or ffi.new("uint32_t[?]", width*height)
	img = LXImage(width, height, 24, data, dis, vis, ZPixmap, 0, 32, 0)

	return data;
end

local function close_x()
	X11.XFreeGC(dis, gc);
	X11.XDestroyWindow(dis,win);
	X11.XCloseDisplay(dis);				
	--error();
end

--[[
	This is the internal drawing routine.  It takes the 
pixmap, which represents the drawing the user is doing
and puts that on the Window.
--]]
local function redraw()
	X11.XPutImage(dis,
    	win,
    	gc,
    	img.Handle,
    	0, 0,
    	0, 0,
    	width,
    	height);
end

--[[
run()

The primary function the user MUST call.  This will 
initiate running their 'setup()' function, if present
and run the event loop to deal with keyboard and mouse
activity.
--]]

local function run ()
	local event = ffi.new("XEvent");

	init_x();

	-- if the user has implemented a global 'setup' routine
	-- it is expected that the user will at least call
	-- the size() function, or they won't see a window
	if setup then
		setup()
	end

	-- the primary event loop

	while( true ) do
		if nil ~= loop then
			loop()
		end

		if (X11.XPending(dis) > 0) then
			X11.XNextEvent(dis,event)

		--if (XCheckWindowEvent(dis, win, myEvents, event) ~= 0) then
			--print("event type: ", event.type)
			if event.type == X11.KeyPress then
				keyCode = event.xkey.keycode;
				if keyPressed then
					keyPressed();
				end
			elseif event.type == X11.KeyRelease then
				keyCode = event.xkey.keycode;
				if keyReleased then
					keyReleased();
				end
			elseif event.type == X11.MotionNotify then
				mouseX = event.xmotion.x;
				mouseY = event.xmotion.y;
				if isMouseDragging then
					if mouseDragged then
						mouseDragged()
					end
				else
					if mouseMoved then
						mouseMoved()
					end
				end
			elseif (event.type == X11.ButtonPress) then
				isMouseDragging = true;
				mouseButton = event.xbutton.button;
				mouseX = event.xbutton.x;
				mouseY = event.xbutton.y;
				if mousePressed then
					mousePressed()
				end
			elseif (event.type == X11.ButtonRelease) then
				isMouseDragging = false;
				mouseButton = event.xbutton.button;
				mouseX = event.xbutton.x;
				mouseY = event.xbutton.y;

				if mouseReleased then
					mouseReleased()
				end
			elseif (event.type == X11.Expose and event.xexpose.count == 0) then
				-- possibly only do this on a timer event?
				if draw ~= nil then
					draw();
				end

			end
		end
		
		-- blit our pixmap to the window
		redraw();
	end
end

local exports = {
	run = run;
	size = size;

	width = width;
	height = height;

}


return exports
