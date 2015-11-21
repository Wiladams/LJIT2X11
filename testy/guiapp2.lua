#!/usr/bin/env luajit

--guiapp1.lua
package.path = package.path..";../?.lua"

local gap = require("GuiApp")
local DrawingContext = require("DrawingContext")
local colors = require("colors")

local awidth = 640;
local aheight = 480;

local dc = nil;

--[[
	Mouse Activity functions.  Implement whichever
	ones of these are appropriate for your application.

	It is ok to not implement them as well, if your
	application doesn't require any mouse activity.
--]]
function mousePressed()
	print("mousePressed(): ", mouseButton)
end

function mouseReleased()
	print("mouseReleased(): ", mouseButton)
end

function mouseDragged()
	print("mouse drag: ", mouseX, mouseY)
end

function mouseMoved()
	print("mouse move: ", mouseX, mouseY)
end

--[[
	Keyboard Activity functions.

	Implement as many of these as your application needs.
--]]
function keyPressed()
	print("keyPressed(): ", keyCode)
end

function keyReleased()
	print("keyReleased(): ", keyCode)
end

function keyTyped(achar)
	--print("keyTyped: ", achar)

	if keyChar ~= nil then
		print(keyChar);
	end
end

-- A setup function isn't strictly required, but 
-- you MUST at least call gap.size(), or no window
-- will be created.
function setup()
	print("setup")
	local data = size(awidth,aheight)
	dc = DrawingContext(awidth, aheight, data)
end

local count = 1;

-- the loop function will be called every time through the 
-- event loop, regardless of any frame rate.  This might be
-- fine when you don't mind stalling the loop, and you don't
-- particularly care about frame rate.
function loop()
	--print("loop: ", count)
	count = count + 1;
	dc:setPixel(10, 10, colors.white)

	dc:hline(10, 20, 100, colors.white)

	dc:rect(10, 30, 100, 100, colors.red)
	dc:rect(110, 30, 100, 100, colors.green)
	dc:rect(210, 30, 100, 100, colors.blue)
end


gap.run()
