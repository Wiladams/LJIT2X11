package.path = package.path..";../src/?.lua"

local ffi = require("ffi")
local bit = require("bit")
local bor = bit.bor
local band = bit.band

local X11 = require("X11")()
     
--    #include <sys/utsname.h>
ffi.cdef[[
static const int __NEW_UTS_LEN = 64;

struct utsname {
  char sysname[__NEW_UTS_LEN + 1];
  char nodename[__NEW_UTS_LEN + 1];
  char release[__NEW_UTS_LEN + 1];
  char version[__NEW_UTS_LEN + 1];
  char machine[__NEW_UTS_LEN + 1];
  char domainname[__NEW_UTS_LEN + 1];
};

extern int uname (struct utsname *__name);

]]

local False = 0
local True = 1

local XK_Escape = 0xff1b;

local function main(argc, argv)
      local dpy = XOpenDisplay(nil);
      if (dpy == nil) then 
        io.write("Cannot open display\n");
        error(1);
      end
     
      local s = DefaultScreen(dpy);
      local win = XCreateSimpleWindow(dpy, RootWindow(dpy, s), 10, 10, 660, 200, 1,
                                       BlackPixel(dpy, s), WhitePixel(dpy, s));
      XSelectInput(dpy, win, bor(ExposureMask, KeyPressMask));
      XMapWindow(dpy, win);
     
      XStoreName(dpy, win, "Geeks3D.com - X11 window under Linux (Mint 10)");
      
      local res = XInternAtom(dpy, "WM_DELETE_WINDOW", False);
      local WM_DELETE_WINDOW = ffi.new("Atom[1]", res);
      XSetWMProtocols(dpy, win, WM_DELETE_WINDOW, 1);  

  
      local uname_ok = false;

      local sname = ffi.new("struct utsname");  
      local ret = ffi.C.uname(sname);
      uname_ok = (ret ~= -1);

      local e = ffi.new("XEvent");
      while (true) do 
      
        XNextEvent(dpy, e);
        if (e.type == Expose) then 
        
          local y_offset = 20;
          local s1 = "X11 test app under Linux";
          local s2 = "(C)2012 Geeks3D.com"; 

          XDrawString(dpy, win, DefaultGC(dpy, s), 10, y_offset, s1, #s1);
          y_offset = y_offset+20;
          XDrawString(dpy, win, DefaultGC(dpy, s), 10, y_offset, s2, #s2);
          y_offset = y_offset+20;

          if (uname_ok) then            
            local buf = "System information:";
            XDrawString(dpy, win, DefaultGC(dpy, s), 10, y_offset, buf, #buf);
            y_offset = y_offset+15;
     
            buf = string.format("- System: %s", ffi.string(sname.sysname));
            XDrawString(dpy, win, DefaultGC(dpy, s), 10, y_offset, buf, #buf);
            y_offset = y_offset + 15;

            buf = string.format("- Release: %s", ffi.string(sname.release));
            XDrawString(dpy, win, DefaultGC(dpy, s), 10, y_offset, buf, #buf);
            y_offset = y_offset + 15;
     
            buf = string.format("- Version: %s", ffi.string(sname.version));
            XDrawString(dpy, win, DefaultGC(dpy, s), 10, y_offset, buf, #buf);
            y_offset = y_offset + 15;
            
            buf = string.format("- Machine: %s", ffi.string(sname.machine));
            XDrawString(dpy, win, DefaultGC(dpy, s), 10, y_offset, buf, #buf);
            y_offset = y_offset + 20;
          end
     
          local wa = ffi.new("XWindowAttributes");
          XGetWindowAttributes(dpy, win, wa);
          local width = wa.width;
          local height = wa.height;

          buf = string.format("Current window size: %dx%d", width, height);
          XDrawString(dpy, win, DefaultGC(dpy, s), 10, y_offset, buf, #buf);
          y_offset = y_offset + 20;
        end
        
        if (e.type == KeyPress) then
          local buf = ffi.new("char[?]", 128);
          local keysym = ffi.new("KeySym[1]");
          local len = XLookupString(e.xkey, buf, ffi.sizeof(buf), keysym, nil);
          if (keysym[0] == XK_Escape) then
            break;
          end
        end
     
        if ((e.type == ClientMessage) and 
            (ffi.cast("unsigned int", e.xclient.data.l[0]) == WM_DELETE_WINDOW)) then
          break;
        end
      end
      
      XDestroyWindow(dpy, win);
      XCloseDisplay(dpy);

      return 0;
end

main(#arg, arg)
