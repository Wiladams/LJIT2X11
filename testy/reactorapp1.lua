#!/usr/bin/env luajit

--guiapp2.lua
package.path = package.path..";../?.lua"


--[[
	Test using the GuiApp concept, whereby the interactor
	is a pluggable component.
--]]
local gap = require("GuiReactor")
local colors = require("colors")

local awidth = 640;
local aheight = 480;

local graphPort = nil;


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
	graphPort = size(awidth,aheight)
end

function loop()
	graphPort:setPixel(10, 10, colors.white)

	graphPort:hline(10, 20, 100, colors.white)

	graphPort:rect(10, 30, 100, 100, colors.red)
	graphPort:rect(110, 30, 100, 100, colors.green)
	graphPort:rect(210, 30, 100, 100, colors.blue)
end


run()
