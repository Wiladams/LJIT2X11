local ffi = require("ffi")
local Xutil = require("x11.Xutil")
local Xlib = require("x11.Xlib")


local LXImage = {}
setmetatable(LXImage, {
	__call = function(self, ...)
		return self:new(...)
	end,
})
local LXImage_mt = {
	__index = LXImage;
}

function LXImage.init(self, img)
	local obj = {
		Handle = img;
	}
	setmetatable(obj, LXImage_mt)

	return obj;
end

function LXImage.new(self, width, height, depth, data, display, visual, format, offset, bitmap_pad, bytes_per_line)
	bytes_per_line = bytes_per_line or 0

	local img = Xlib.XCreateImage(display, visual, depth, format, offset, 
		ffi.cast("char *",data), 
		width, height, 
		bitmap_pad, 
		bytes_per_line)
	
	if img == nil then
		return nil;
	end

	ffi.gc(img, Xutil.XDestroyImage);

	-- MUST call XIniImage for images the client creates
	local status = Xlib.XInitImage(img);
	if status == 0 then return nil end
	
	return self:init(img)
end

function LXImage.setPixel(self, x, y, value)
	Xutil.XPutPixel(self.Handle, x, y, value);
end


return LXImage