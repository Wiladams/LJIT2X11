--X11.lua

local ffi = require("ffi")

local X = require("x11.X")
local Xlib = require("x11.Xlib")
local Xutil = require("x11.Xutil")
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

	__index = function(self, key)
		-- First, see if it's one of the functions or constants
		-- in the library
		local success, value = pcall(function() return ffi.C[key] end)
		if success then
			rawset(self, key, value)
			return value;
		end

		-- try to find the key as a type
		success, value = pcall(function() return ffi.typeof(key) end)
		if success then
			rawset(key, value)
			return value;
		end

		-- finally, return nil if it's nothing we can get to easily
		return nil;
	end,
})

return exports
