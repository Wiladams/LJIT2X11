-- GuiApp.lua

package.path = package.path..";../?.lua"

local X11Interactor = require("X11Interactor")











local ffi = require("ffi")
local bit = require("bit")
local bor = bit.bor
local band = bit.band




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
keyCode = nil;
keyChar = nil;

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

	local depth  = X11.DefaultDepth(dis,screen); 
	print("DEPTH:", depth)
	data = data or ffi.new("uint32_t[?]", width*height)
	img = LXImage(width, height, depth, data, dis, vis, X11.ZPixmap, 0, 32, 0)

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
local function getKeyChar(event)
	local buffer_size = 80;
	local buffer = ffi.new("char[80]");
	local keysym = ffi.new("KeySym[1]");
	--/* XComposeStatus compose; is not used, though it's in some books */
	local count = X11.XLookupString(ffi.cast("XKeyEvent *", event), 
		buffer, buffer_size, 
		keysym,
		nil);

	if count == 1 then
		return string.char(buffer[0])
	end

	if count > 1 then 
		return ffi.string(buffer, count)
	end

	return nil;
end

local function tracker (activity)

	if event.kind == "keypress" then
				keyCode = event.xkey.keycode;
				keyChar = getKeyChar(event)

				if keyPressed then
					keyPressed();
				end

				if keyTyped then
					keyTyped(keyChar)
				end

	elseif activity.kind == "keyrelease" then
				keyCode = event.xkey.keycode;
				if keyReleased then
					keyReleased();
				end
	elseif event.kind == "mousemove" then
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
	elseif (event.kind == "buttonpress") then
				isMouseDragging = true;
				mouseButton = event.xbutton.button;
				mouseX = event.xbutton.x;
				mouseY = event.xbutton.y;
				if mousePressed then
					mousePressed()
				end
	elseif event.kind == "buttonrelease" then
				isMouseDragging = false;
				mouseButton = event.xbutton.button;
				mouseX = event.xbutton.x;
				mouseY = event.xbutton.y;

				if mouseReleased then
					mouseReleased()
				end
	end
end



local function tracker(activity)
end

local driver = X11Interactor({Title="GuiApp", InputTracker = tracker})

return driver

