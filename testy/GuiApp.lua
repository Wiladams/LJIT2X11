-- GuiApp.lua

package.path = package.path..";../?.lua"

local ffi = require("ffi")
local bit = require("bit")
local bor = bit.bor
local band = bit.band

local X11Interactor = require("X11Interactor")








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


-- mouse information
mouseX = 0;
mouseY = 0;
local isMouseDragging = false;
keyCode = nil;
keyChar = nil;


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

	return data;
end



local exports = {
	size = size;
	run = function() driver:run() end;
}

return exports
