--[[
	X11Interactor

	Contains enough to get a buffer built, which can be displayed
	on the screen.  It also captures mouse and keyboard activity 
	and forwards to the specified recipient.
--]]
--package.path = package.path..";../?.lua"

local ffi = require("ffi")
local bit = require("bit")
local band, bor = bit.band, bit.bor


local X11 = require("x11.X11")
local LXImage = require("x11.LXImage")


local X11Interactor = {}
setmetatable(X11Interactor, {
	__call = function(self, ...)
		return self:new(...)
	end,
})
local X11Interactor_mt = {
	__index = X11Interactor;
}


local myEvents = bor(X11.ExposureMask, 
		X11.KeyPressMask, X11.KeyReleaseMask,
		X11.ButtonPressMask,X11.ButtonReleaseMask,
		X11.PointerMotionMask)


local function defaultTracker(activity)
	print("defaultTracker: ", activity)
end

function X11Interactor.init(self, params)
print("X11Interactor.init: ", params)
	local dis = X11.XOpenDisplay(nil);

	local obj = {
		Title = params.Title or "GuiApplication";
		dis = dis;
   		screen = X11.DefaultScreen(dis);
   		vis = X11.XDefaultVisual(dis, X11.DefaultScreen(dis));

		InputTracker = params.InputTracker or defaultTracker;
	}

	setmetatable(obj, X11Interactor_mt)

	return obj;
end

function X11Interactor.new(self, params)
	return self:init(params)
end


function X11Interactor.size(self, awidth, aheight, data)

	local blackPixel = X11.BlackPixel(self.dis, self.screen);
	local whitePixel = X11.WhitePixel(self.dis, self.screen);

	self.width = awidth;
	self.height = aheight;


   	self.Window = X11.XCreateSimpleWindow(self.dis,
   		X11.DefaultRootWindow(self.dis),
   		0,0,	
		awidth, aheight, 
		5,
		blackPixel, whitePixel);

	X11.XSetStandardProperties(self.dis,self.Window,self.Title,"Hi",X11.None,nil,0,nil);


	X11.XSelectInput(self.dis, self.Window, myEvents);
    
    self.gc = X11.XCreateGC(self.dis, self.Window, 0,nil);        
	
	X11.XSetBackground(self.dis,self.gc,whitePixel);
	X11.XSetForeground(self.dis,self.gc,blackPixel);
	X11.XClearWindow(self.dis, self.Window);
	X11.XMapRaised(self.dis, self.Window);

	local depth  = X11.DefaultDepth(self.dis,self.screen); 

	data = data or ffi.new("uint32_t[?]", awidth*aheight)
	self.img = LXImage(awidth, aheight, depth, data, self.dis, self.vis, X11.ZPixmap, 0, 32, 0)

	return data;
end

function X11Interactor.close()
	X11.XFreeGC(self.dis, self.gc);
	X11.XDestroyWindow(self.dis,self.win);
	X11.XCloseDisplay(self.dis);				
end

--[[
	This is the internal drawing routine.  It takes the 
pixmap, which represents the drawing the user is doing
and puts that on the Window.
--]]
function X11Interactor.redraw(self)
	X11.XPutImage(self.dis,
    	self.Window,
    	self.gc,
    	self.img.Handle,
    	0, 0,
    	0, 0,
    	self.width,
    	self.height);
end

--[[
	Returns the symbol on the key indicated by the event.
	Modifiers are applied.
	nil is returned if it's not a printable key
--]]
local buffer_size = 80;
local buffer = ffi.new("char[80]");
local keysym = ffi.new("KeySym[1]");

local function getKeyChar(event)

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

--[[
run()

The primary function the user MUST call.  This will 
initiate running their 'setup()' function, if present
and run the event loop to deal with keyboard and mouse
activity.
--]]
function X11Interactor.run(self)
	local event = ffi.new("XEvent");

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

		if (X11.XPending(self.dis) > 0) then
			X11.XNextEvent(self.dis,event)

			if event.type == X11.KeyPress then
				self.InputTracker({
						kind = "keypress",
						keycode = event.xkey.keycode,
						keychar = getKeyChar(event),
						})
			elseif event.type == X11.KeyRelease then
				self.InputTracker({
						kind = "keyrelease",
						keycode = event.xkey.keycode,
						keychar = getKeyChar(event),
						})
			elseif event.type == X11.MotionNotify then
				self.InputTracker({
						kind = "mousemove",
						x = event.xmotion.x,
						y = event.xmotion.y,
						})
			elseif (event.type == X11.ButtonPress) then
				self.InputTracker({
						kind = "buttonpress",
						x = event.xmotion.x,
						y = event.xmotion.y,
						button = event.xbutton.button,
						})
			elseif (event.type == X11.ButtonRelease) then
				self.InputTracker({
						kind = "buttonrelease",
						x = event.xmotion.x,
						y = event.xmotion.y,
						button = event.xbutton.button,
						})
			end
		end
		
		-- blit our pixmap to the window
		self:redraw();

		-- we MUST run in a cooperative environment
		yield();
	end
end

return X11Interactor

