--gen_keysymdef.lua
-- take keysymdef.h as input and turn the #defines into
-- 'static const int' for usage in a ffi.cdef

local pattern = "^#define%s*(%g+)%s*(%g+)"
local scomment = "/%*.*%*/"
for line in io.lines("keysymdef.h") do
	local name, value = line:match(pattern)
	if name and value then
		io.write(string.format("static const int %-32s = %s;\n", name, value))
	else
		local comm = line:match(scomment)
		if comm ~= nil then
			print(comm)
		end
		--print(line)
	end
end
