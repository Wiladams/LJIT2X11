-- GuiApp.lua

package.path = package.path..";../?.lua"

local ffi = require("ffi")
local bit = require("bit")
local bor = bit.bor
local band = bit.band

local kernel = require("kernel")
local X11Interactor = require("X11Interactor")
local DrawingContext = require("DrawingContext")


-- some global variables
local width = 640;
local height = 480;


-- mouse information
mouseX = 0;
mouseY = 0;
local isMouseDragging = false;

-- keyboard information
keyCode = nil;
keyChar = nil;


--[[
	This function is called by the Interactor whenever there
	are interesting events, such as mouse and keyboard.  This
	is the primary tie between the platform, and the rest
	of the application.
--]]
local function tracker (activity)

	if activity.kind == "keypress" then
				keyCode = activity.keycode;
				keyChar = activity.keychar;

				if keyPressed then
					keyPressed();
				end

				if keyTyped then
					keyTyped(keyChar)
				end

	elseif activity.kind == "keyrelease" then
				keyCode = activity.keycode;
				if keyReleased then
					keyReleased();
				end
	elseif activity.kind == "mousemove" then
		mouseX = activity.x;
		mouseY = activity.y;
		if isMouseDragging then
			if mouseDragged then
				mouseDragged()
			end
		else
			if mouseMoved then
				mouseMoved()
			end
		end
	elseif (activity.kind == "buttonpress") then
		isMouseDragging = true;
		mouseButton = activity.button;
		mouseX = activity.x;
		mouseY = activity.y;
		if mousePressed then
			mousePressed()
		end
	elseif activity.kind == "buttonrelease" then
		isMouseDragging = false;
		mouseButton = activity.button;
		mouseX = activity.x;
		mouseY = activity.y;

		if mouseReleased then
			mouseReleased()
		end
	end
end


local driver = X11Interactor({Title="GuiApp", InputTracker = tracker})

function size(awidth, aheight)
	width = awidth;
	height = aheight;

	local data = driver:size(awidth, aheight)
	local dc = DrawingContext(awidth, aheight, data)

	return dc;
end

local exports = {
	size = size;
}

spawn(driver.run, driver)

return exports
