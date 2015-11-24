# LJIT2X11
These bindings go to 11!

X11 is the graphics subsytem that is commonly found atop the Linux operating system.
Using X11 you can open Windows, use mouse and keyboard interaction, and draw graphics in general.

This binding covers the core parts of the X11 system required to open windows, draw
graphics, and generally interact with keyboard and mouse.  It does not cover the entirety
of X11, as the parts not covered are not as required for basic GUI apps.

X11.lua is the primary entry point.  You can gain access to everything with one
'require' statement.

```lua
local X11 = require("x11.X11")

-- to create a connection to the default display
-- on the current machine
local display = X11.XOpenDisplay(nil);
```

Of course, that's just the beginning.  To get a Window up, with mouse and keyboard
events...

```lua
local myEvents = bor(X11.ExposureMask, 
		X11.KeyPressMask, X11.KeyReleaseMask,
		X11.ButtonPressMask,X11.ButtonReleaseMask,
		X11.PointerMotionMask)


screen = X11.DefaultScreen(disdisplay);
visual = X11.XDefaultVisual(display, X11.DefaultScreen(display));

	local blackPixel = X11.BlackPixel(display, screen);
	local whitePixel = X11.WhitePixel(display, screen);


   	Window = X11.XCreateSimpleWindow(self.dis,
   		X11.DefaultRootWindow(self.dis),
   		0,0,	
		awidth, aheight, 
		5,
		blackPixel, whitePixel);

	X11.XSetStandardProperties(display,Window,Title,"Hi",X11.None,nil,0,nil);


	X11.XSelectInput(display, Window, myEvents);
    
    gcontext = X11.XCreateGC(display, Window, 0,nil);        
	
	X11.XSetBackground(display,gcontext,whitePixel);
	X11.XSetForeground(display,gcontext,blackPixel);
	X11.XClearWindow(display, Window);
	X11.XMapRaised(display, Window);
```

You can essentially program as if you were writing X11 code in C, just put the
'X11.' in front of all references to functions, types, and constants.  Of course
this is Lua, so you could also make those local references, and write your code
exactly as you would in C, with some Lua goodness wrapping it up for convenience.