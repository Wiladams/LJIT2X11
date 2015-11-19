local ffi = require("ffi")
local Xutil = require("x11.Xutil")
local Xlib = require("x11.Xlib")


--[[
extern int XDestroyImage(
        XImage *ximage);
extern unsigned long XGetPixel(
        XImage *ximage,
        int x, int y);
extern int XPutPixel(
        XImage *ximage,
        int x, int y,
        unsigned long pixel);
extern XImage *XSubImage(
        XImage *ximage,
        int x, int y,
        unsigned int width, unsigned int height);
extern int XAddPixel(
        XImage *ximage,
        long value);

extern XImage *XCreateImage(
    Display*		/* display */,
    Visual*		/* visual */,
    unsigned int	/* depth */,
    int			/* format */,
    int			/* offset */,
    char*		/* data */,
    unsigned int	/* width */,
    unsigned int	/* height */,
    int			/* bitmap_pad */,
    int			/* bytes_per_line */
);
extern Status XInitImage(
    XImage*		/* image */
);
--]]

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

	local img = Xlib.XCreateImage(display, visual, depth, format, offset, data, width, height, bitmap_pad, bytes_per_line)
	
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