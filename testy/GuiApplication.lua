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


-- important work routines
local function init_x(title)
	print("init_x")
	title = title or "GuiApplication"

	dis = XOpenDisplay(nil);
   	screen = DefaultScreen(dis);
   	vis = XDefaultVisual(dis, screen)

	black = BlackPixel(dis,screen);
	white = WhitePixel(dis, screen);
	print("init_x: END")
end

local function size(awidth, aheight, data)
	width = awidth;
	height = aheight;


   	win = XCreateSimpleWindow(dis,
   		DefaultRootWindow(dis),
   		0,0,	
		width, height, 
		5,
		black, white);

	XSetStandardProperties(dis,win,title,"Hi",None,nil,0,nil);
	XSelectInput(dis, win, bor(ExposureMask,ButtonPressMask,KeyPressMask));
    
    gc = XCreateGC(dis, win, 0,nil);        
	
	XSetBackground(dis,gc,white);
	XSetForeground(dis,gc,black);
	XClearWindow(dis, win);
	XMapRaised(dis, win);


	data = data or ffi.new("uint32_t[?]", width*height)
	img = LXImage(width, height, 24, data, dis, vis, ZPixmap, 0, 32, 0)


	return data;
end

local function close_x()
	XFreeGC(dis, gc);
	XDestroyWindow(dis,win);
	XCloseDisplay(dis);				
	error();
end

local function redraw()
	XPutImage(dis,
    	win,
    	gc,
    	img.Handle,
    	0, 0,
    	0, 0,
    	width,
    	height);
end

local function run ()
	local event = ffi.new("XEvent");

	init_x();

	if setup then
		setup()
	end


	while( true ) do
		if nil ~= loop then
			loop()
		end

		if (XCheckWindowEvent(dis, win, bor(ExposureMask, ButtonPressMask), event) ~= 0) then
		--XNextEvent(dis, event);
	
			if (event.type == Expose and event.xexpose.count == 0) then
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