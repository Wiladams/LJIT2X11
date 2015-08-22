--[[
	A simple example of a minimal X11 program
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
local X11 = require("X11")()

-- some global variables
local dis = nil;
local screen = nil;
local win = nil;
local gc = nil;

-- important work routines
local function init_x()

	dis = XOpenDisplay(nil);
   	screen = DefaultScreen(dis);
	local black = BlackPixel(dis,screen);
	local white = WhitePixel(dis, screen);
   	
   	win = XCreateSimpleWindow(dis,DefaultRootWindow(dis),0,0,	
		300, 300, 5,black, white);

	XSetStandardProperties(dis,win,"Howdy","Hi",None,nil,0,nil);
	XSelectInput(dis, win, bor(ExposureMask,ButtonPressMask,KeyPressMask));
    
    gc = XCreateGC(dis, win, 0,nil);        
	
	XSetBackground(dis,gc,white);
	XSetForeground(dis,gc,black);
	XClearWindow(dis, win);
	XMapRaised(dis, win);
end

local function close_x()
	XFreeGC(dis, gc);
	XDestroyWindow(dis,win);
	XCloseDisplay(dis);				
	error();
end

local function redraw()
	XClearWindow(dis, win);
end

local function main ()
	local event = ffi.new("XEvent");

	init_x();

	while( true ) do		
		XNextEvent(dis, event);
	
		if (event.type == Expose and event.xexpose.count == 0) then
			redraw();
		end
	
		if (event.type==ButtonPress) then
			local text = "X is FUN!"
			XSetForeground(dis,gc,127);
			XDrawString(dis,win,gc,event.xbutton.x,event.xbutton.y, text, #text);
		end
	end
end

main()
