Documentation for some extras
-----------------------------

GuiReactor
----------
This is a convenient class for setting up a window, and creating 
an event loop in a reactor sort of pattern.  Typical usage is like
this:

```lua
package.path = package.path..";../?.lua"

local gap = require("GuiReactor")

function mouseMoved()
	print("mouse move: ", mouseX, mouseY)
end

-- A setup function isn't strictly required, but 
-- you MUST at least call gap.size(), or no window
-- will be created.
function setup()
	print("setup");
	graphPort = size(awidth,aheight);
end

function loop()
	graphPort:setPixel(10, 10, colors.white)

	graphPort:hline(10, 20, 100, colors.white)

	graphPort:rect(10, 30, 100, 100, colors.red)
	graphPort:rect(110, 30, 100, 100, colors.green)
	graphPort:rect(210, 30, 100, 100, colors.blue)
end


run()
```

The GuiReactor takes care of creating various activities such as
keyboard and mouse.  You only need to provide implementations for
the functions that you are actually interested in handling.


Miscellany
----------

colors.lua
This is a convenience class that contains some simple RGBA color 
values stuffed into 
uint32_t.  They are suitable for doing your own drawing directly into the constructed
framebuffer returned from the X11Interactor:size() call.

DrawingContext.lua
This represents a very rudimentary 2D renderer.  The core function is setPixel().  
Horizontal lines, and rectangles are built atop that.  No other functions are 
available.  This is just enough to be able to write simple test cases that can
show something rendered in a window.

gen_keysymdeff.lua
This is a utility function that is used to create the 'keysymdef.lua' file found in the 
x11 directory.  

tinylibc.lua
Contains a number of useful ffi calls required by the kernel.  It is also 
a convenient place to put any additional such calls, for interaction with 
the libc library.
