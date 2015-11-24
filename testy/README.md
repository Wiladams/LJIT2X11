Documentation for some extras
-----------------------------

X11Interactor
-------------
This is a convenience class that makes it relatively easy to setup a window and start
receiving various notifications and events.  Use the X11Interactor if what you want
is to bring up a window on the local workstation and interact with it.

In addition to supplying this fundamental capability, it helps to separate the 
window creation and event notifications from the rest of the system.

```lua
local X11Interactor = require("X11Interactor")

local function tracker (activity)
	print("Activity: ", activity.kind)
end

local driver = X11Interactor({Title="GuiApp", InputTracker = tracker})

function size(awidth, aheight)
	width = awidth;
	height = aheight;

	local data = driver:size(awidth, aheight)
	local dc = DrawingContext(awidth, aheight, data)

	return dc;
end

size(640, 480)
```

This is the bare minimum needed to use the X11Interactor.  Basically, create an instance 
'driver', handing in a 'Title' and 'InputTracker'.  The 'InputTracker' must be a function
which will be called any time there is some interesting activity, such as mouse or keyboard
events.  The tracker function will receive a single parameter, which is the activity
encapsulated in a lua table.  At the very least, the activity will contain a field which
specified the 'kind' of activity.  Typical kinds include 'mousemove, mousepress, mouserelease,'
'keypress', 'keyrelease', 'loop'.  Your application is free to respond to these various
activities however it sees fit.

When you construct the driver, and call the 'size()' method, you are returned a pointer to a 
piece of data, which represents the framebuffer of the window that is created.  This is in
essence the data backing a XPixmap data structure.  You are free to draw into this data pointer.
The layout is that of a 32-bit rgba.  Each row is width*4 bytes wide.  You can build up fundamental drawing routines from here.

