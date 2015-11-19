--guiapp1.lua
package.path = package.path..";../?.lua"

local gap = require("GuiApplication")
local DrawingContext = require("DrawingContext")
local colors = require("colors")

local awidth = 640;
local aheight = 480;

local dc = nil;

function setup()
	print("setup")
	local data = gap.size(awidth,aheight)
	dc = DrawingContext(awidth, aheight, data)
end

local count = 1;

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
