--X11.lua

local ffi = require("ffi")

local X = require("X")
local Xlib = require("Xlib")
local Xutil = require("Xutil")
--Xos = require("Xos")

local Lib_X11 = ffi.load("X11")

local exports = {
	Lib_X11 = Lib_X11;

	X = X;
	Xlib = Xlib;
	Xutil = Xutil;	
}

setmetatable(exports, {
	__call = function(self, ...)
		self.X();
		self.Xlib();
		self.Xutil();

		return self;
	end,
})

return exports