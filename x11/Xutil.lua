
local ffi = require("ffi")

local Xlib = require("x11.Xlib")

ffi.cdef[[
/*
 * new version containing base_width, base_height, and win_gravity fields;
 * used with WM_NORMAL_HINTS.
 */
typedef struct {
    	long flags;	/* marks which fields in this structure are defined */
	int x, y;		/* obsolete for new window mgrs, but clients */
	int width, height;	/* should set so old wm's don't mess up */
	int min_width, min_height;
	int max_width, max_height;
    	int width_inc, height_inc;
	struct {
		int x;	/* numerator */
		int y;	/* denominator */
	} min_aspect, max_aspect;
	int base_width, base_height;		/* added by ICCCM version 1 */
	int win_gravity;			/* added by ICCCM version 1 */
} XSizeHints;
]]

ffi.cdef[[
/*
 * The next block of definitions are for window manager properties that
 * clients and applications use for communication.
 */

/* flags argument in size hints */
static const int USPosition	= (1 << 0); /* user specified x, y */
static const int USSize		= (1 << 1); /* user specified width, height */

static const int PPosition	= (1 << 2); /* program specified position */
static const int PSize		= (1 << 3); /* program specified size */
static const int PMinSize	= (1 << 4); /* program specified minimum size */
static const int PMaxSize	= (1 << 5); /* program specified maximum size */
static const int PResizeInc	= (1 << 6); /* program specified resize increments */
static const int PAspect		= (1 << 7); /* program specified min and max aspect ratios */
static const int PBaseSize	= (1 << 8); /* program specified base for incrementing */
static const int PWinGravity	= (1 << 9); /* program specified window gravity */
]]



ffi.cdef[[
typedef struct {
	long flags;	/* marks which fields in this structure are defined */
	Bool input;	/* does this application rely on the window manager to
			get keyboard input? */
	int initial_state;	/* see below */
	Pixmap icon_pixmap;	/* pixmap to be used as icon */
	Window icon_window; 	/* window to be used as icon */
	int icon_x, icon_y; 	/* initial position of icon */
	Pixmap icon_mask;	/* icon mask bitmap */
	XID window_group;	/* id of related window group */
	/* this structure may be extended in the future */
} XWMHints;
]]

ffi.cdef[[
/* definition for flags of XWMHints */

static const int InputHint 	=	(1 << 0);
static const int StateHint 	=	(1 << 1);
static const int IconPixmapHint	=	(1 << 2);
static const int IconWindowHint	=	(1 << 3);
static const int IconPositionHint =	(1 << 4);
static const int IconMaskHint	=	(1 << 5);
static const int WindowGroupHint	=	(1 << 6);
static const int AllHints = (InputHint|StateHint|IconPixmapHint|IconWindowHint| IconPositionHint|IconMaskHint|WindowGroupHint);
static const int XUrgencyHint	=	(1 << 8);

/* definitions for initial window state */
static const int WithdrawnState = 0;	/* for windows that are not mapped */
static const int NormalState = 1;	/* most applications want to start this way */
static const int IconicState = 3;	/* application wants to start as an icon */
]]

ffi.cdef[[
/*
 * new structure for manipulating TEXT properties; used with WM_NAME,
 * WM_ICON_NAME, WM_CLIENT_MACHINE, and WM_COMMAND.
 */
typedef struct {
    unsigned char *value;		/* same as Property routines */
    Atom encoding;			/* prop type */
    int format;				/* prop data format: 8, 16, or 32 */
    unsigned long nitems;		/* number of data items in value */
} XTextProperty;

static const int XNoMemory = -1;
static const int XLocaleNotSupported = -2;
static const int XConverterNotFound = -3;

typedef enum {
    XStringStyle,		/* STRING */
    XCompoundTextStyle,		/* COMPOUND_TEXT */
    XTextStyle,			/* text in owner's encoding (current locale)*/
    XStdICCTextStyle,		/* STRING, else COMPOUND_TEXT */
    /* The following is an XFree86 extension, introduced in November 2000 */
    XUTF8StringStyle		/* UTF8_STRING */
} XICCEncodingStyle;

typedef struct {
	int min_width, min_height;
	int max_width, max_height;
	int width_inc, height_inc;
} XIconSize;

typedef struct {
	char *res_name;
	char *res_class;
} XClassHint;
]]

ffi.cdef[[
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
]]

--[[
/*
 * These macros are used to give some sugar to the image routines so that
 * naive people are more comfortable with them.
 */
#define XDestroyImage(ximage) \
	((*((ximage)->f.destroy_image))((ximage)))
#define XGetPixel(ximage, x, y) \
	((*((ximage)->f.get_pixel))((ximage), (x), (y)))
#define XPutPixel(ximage, x, y, pixel) \
	((*((ximage)->f.put_pixel))((ximage), (x), (y), (pixel)))
#define XSubImage(ximage, x, y, width, height)  \
	((*((ximage)->f.sub_image))((ximage), (x), (y), (width), (height)))
#define XAddPixel(ximage, value) \
	((*((ximage)->f.add_pixel))((ximage), (value)))
#endif
--]]

ffi.cdef[[
/*
 * Compose sequence status structure, used in calling XLookupString.
 */
typedef struct _XComposeStatus {
    XPointer compose_ptr;	/* state table pointer */
    int chars_matched;		/* match state */
} XComposeStatus;
]]

--[[
/*
 * Keysym macros, used on Keysyms to test for classes of symbols
 */
#define IsKeypadKey(keysym) \
  (((KeySym)(keysym) >= XK_KP_Space) && ((KeySym)(keysym) <= XK_KP_Equal))

#define IsPrivateKeypadKey(keysym) \
  (((KeySym)(keysym) >= 0x11000000) && ((KeySym)(keysym) <= 0x1100FFFF))

#define IsCursorKey(keysym) \
  (((KeySym)(keysym) >= XK_Home)     && ((KeySym)(keysym) <  XK_Select))

#define IsPFKey(keysym) \
  (((KeySym)(keysym) >= XK_KP_F1)     && ((KeySym)(keysym) <= XK_KP_F4))

#define IsFunctionKey(keysym) \
  (((KeySym)(keysym) >= XK_F1)       && ((KeySym)(keysym) <= XK_F35))

#define IsMiscFunctionKey(keysym) \
  (((KeySym)(keysym) >= XK_Select)   && ((KeySym)(keysym) <= XK_Break))

#ifdef XK_XKB_KEYS
#define IsModifierKey(keysym) \
  ((((KeySym)(keysym) >= XK_Shift_L) && ((KeySym)(keysym) <= XK_Hyper_R)) \
   || (((KeySym)(keysym) >= XK_ISO_Lock) && \
       ((KeySym)(keysym) <= XK_ISO_Level5_Lock)) \
   || ((KeySym)(keysym) == XK_Mode_switch) \
   || ((KeySym)(keysym) == XK_Num_Lock))
#else
#define IsModifierKey(keysym) \
  ((((KeySym)(keysym) >= XK_Shift_L) && ((KeySym)(keysym) <= XK_Hyper_R)) \
   || ((KeySym)(keysym) == XK_Mode_switch) \
   || ((KeySym)(keysym) == XK_Num_Lock))
#endif
--]]

ffi.cdef[[
/*
 * opaque reference to Region data type
 */
typedef struct _XRegion *Region;
]]

--[[
/* Return values from XRectInRegion() */

#define RectangleOut 0
#define RectangleIn  1
#define RectanglePart 2
--]]

ffi.cdef[[
/*
 * Information used by the visual utility routines to find desired visual
 * type from the many visuals a display may support.
 */

typedef struct {
  Visual *visual;
  VisualID visualid;
  int screen;
  int depth;
  int class;
  unsigned long red_mask;
  unsigned long green_mask;
  unsigned long blue_mask;
  int colormap_size;
  int bits_per_rgb;
} XVisualInfo;
]]

--[[
#define VisualNoMask		0x0
#define VisualIDMask 		0x1
#define VisualScreenMask	0x2
#define VisualDepthMask		0x4
#define VisualClassMask		0x8
#define VisualRedMaskMask	0x10
#define VisualGreenMaskMask	0x20
#define VisualBlueMaskMask	0x40
#define VisualColormapSizeMask	0x80
#define VisualBitsPerRGBMask	0x100
#define VisualAllMask		0x1FF
--]]

ffi.cdef[[
/*
 * This defines a window manager property that clients may use to
 * share standard color maps of type RGB_COLOR_MAP:
 */
typedef struct {
	Colormap colormap;
	unsigned long red_max;
	unsigned long red_mult;
	unsigned long green_max;
	unsigned long green_mult;
	unsigned long blue_max;
	unsigned long blue_mult;
	unsigned long base_pixel;
	VisualID visualid;		/* added by ICCCM version 1 */
	XID killid;			/* added by ICCCM version 1 */
} XStandardColormap;
]]

--[[
#define ReleaseByFreeingColormap ((XID) 1L)  /* for killid field above */


/*
 * return codes for XReadBitmapFile and XWriteBitmapFile
 */
#define BitmapSuccess		0
#define BitmapOpenFailed 	1
#define BitmapFileInvalid 	2
#define BitmapNoMemory		3
--]]

-- Context Management
ffi.cdef[[
typedef int XContext;
]]

--#define XUniqueContext()       ((XContext) XrmUniqueQuark())
--#define XStringToContext(string)   ((XContext) XrmStringToQuark(string))


ffi.cdef[[
/* The following declarations are alphabetized. */

XClassHint *XAllocClassHint (
    void
);

XIconSize *XAllocIconSize (
    void
);

XSizeHints *XAllocSizeHints (
    void
);

XStandardColormap *XAllocStandardColormap (
    void
);

XWMHints *XAllocWMHints (
    void
);

int XClipBox(
    Region		/* r */,
    XRectangle*		/* rect_return */
);

Region XCreateRegion(
    void
);

const char *XDefaultString (void);

int XDeleteContext(
    Display*		/* display */,
    XID			/* rid */,
    XContext		/* context */
);

int XDestroyRegion(
    Region		/* r */
);

int XEmptyRegion(
    Region		/* r */
);

int XEqualRegion(
    Region		/* r1 */,
    Region		/* r2 */
);

int XFindContext(
    Display*		/* display */,
    XID			/* rid */,
    XContext		/* context */,
    XPointer*		/* data_return */
);

Status XGetClassHint(
    Display*		/* display */,
    Window		/* w */,
    XClassHint*		/* class_hints_return */
);

Status XGetIconSizes(
    Display*		/* display */,
    Window		/* w */,
    XIconSize**		/* size_list_return */,
    int*		/* count_return */
);

Status XGetNormalHints(
    Display*		/* display */,
    Window		/* w */,
    XSizeHints*		/* hints_return */
);

Status XGetRGBColormaps(
    Display*		/* display */,
    Window		/* w */,
    XStandardColormap** /* stdcmap_return */,
    int*		/* count_return */,
    Atom		/* property */
);

Status XGetSizeHints(
    Display*		/* display */,
    Window		/* w */,
    XSizeHints*		/* hints_return */,
    Atom		/* property */
);

Status XGetStandardColormap(
    Display*		/* display */,
    Window		/* w */,
    XStandardColormap*	/* colormap_return */,
    Atom		/* property */
);

Status XGetTextProperty(
    Display*		/* display */,
    Window		/* window */,
    XTextProperty*	/* text_prop_return */,
    Atom		/* property */
);

XVisualInfo *XGetVisualInfo(
    Display*		/* display */,
    long		/* vinfo_mask */,
    XVisualInfo*	/* vinfo_template */,
    int*		/* nitems_return */
);

Status XGetWMClientMachine(
    Display*		/* display */,
    Window		/* w */,
    XTextProperty*	/* text_prop_return */
);

XWMHints *XGetWMHints(
    Display*		/* display */,
    Window		/* w */
);

Status XGetWMIconName(
    Display*		/* display */,
    Window		/* w */,
    XTextProperty*	/* text_prop_return */
);

Status XGetWMName(
    Display*		/* display */,
    Window		/* w */,
    XTextProperty*	/* text_prop_return */
);

Status XGetWMNormalHints(
    Display*		/* display */,
    Window		/* w */,
    XSizeHints*		/* hints_return */,
    long*		/* supplied_return */
);

Status XGetWMSizeHints(
    Display*		/* display */,
    Window		/* w */,
    XSizeHints*		/* hints_return */,
    long*		/* supplied_return */,
    Atom		/* property */
);

Status XGetZoomHints(
    Display*		/* display */,
    Window		/* w */,
    XSizeHints*		/* zhints_return */
);

int XIntersectRegion(
    Region		/* sra */,
    Region		/* srb */,
    Region		/* dr_return */
);

void XConvertCase(
    KeySym		/* sym */,
    KeySym*		/* lower */,
    KeySym*		/* upper */
);

int XLookupString(
    XKeyEvent*		/* event_struct */,
    char*		/* buffer_return */,
    int			/* bytes_buffer */,
    KeySym*		/* keysym_return */,
    XComposeStatus*	/* status_in_out */
);

Status XMatchVisualInfo(
    Display*		/* display */,
    int			/* screen */,
    int			/* depth */,
    int			/* class */,
    XVisualInfo*	/* vinfo_return */
);

int XOffsetRegion(
    Region		/* r */,
    int			/* dx */,
    int			/* dy */
);

Bool XPointInRegion(
    Region		/* r */,
    int			/* x */,
    int			/* y */
);

Region XPolygonRegion(
    XPoint*		/* points */,
    int			/* n */,
    int			/* fill_rule */
);

int XRectInRegion(
    Region		/* r */,
    int			/* x */,
    int			/* y */,
    unsigned int	/* width */,
    unsigned int	/* height */
);

int XSaveContext(
    Display*		/* display */,
    XID			/* rid */,
    XContext		/* context */,
    const char*	/* data */
);

int XSetClassHint(
    Display*		/* display */,
    Window		/* w */,
    XClassHint*		/* class_hints */
);

int XSetIconSizes(
    Display*		/* display */,
    Window		/* w */,
    XIconSize*		/* size_list */,
    int			/* count */
);

int XSetNormalHints(
    Display*		/* display */,
    Window		/* w */,
    XSizeHints*		/* hints */
);

void XSetRGBColormaps(
    Display*		/* display */,
    Window		/* w */,
    XStandardColormap*	/* stdcmaps */,
    int			/* count */,
    Atom		/* property */
);

int XSetSizeHints(
    Display*		/* display */,
    Window		/* w */,
    XSizeHints*		/* hints */,
    Atom		/* property */
);

int XSetStandardProperties(
    Display*		/* display */,
    Window		/* w */,
    const char*	/* window_name */,
    const char*	/* icon_name */,
    Pixmap		/* icon_pixmap */,
    char**		/* argv */,
    int			/* argc */,
    XSizeHints*		/* hints */
);

void XSetTextProperty(
    Display*		/* display */,
    Window		/* w */,
    XTextProperty*	/* text_prop */,
    Atom		/* property */
);

void XSetWMClientMachine(
    Display*		/* display */,
    Window		/* w */,
    XTextProperty*	/* text_prop */
);

int XSetWMHints(
    Display*		/* display */,
    Window		/* w */,
    XWMHints*		/* wm_hints */
);

void XSetWMIconName(
    Display*		/* display */,
    Window		/* w */,
    XTextProperty*	/* text_prop */
);

void XSetWMName(
    Display*		/* display */,
    Window		/* w */,
    XTextProperty*	/* text_prop */
);

void XSetWMNormalHints(
    Display*		/* display */,
    Window		/* w */,
    XSizeHints*		/* hints */
);

void XSetWMProperties(
    Display*		/* display */,
    Window		/* w */,
    XTextProperty*	/* window_name */,
    XTextProperty*	/* icon_name */,
    char**		/* argv */,
    int			/* argc */,
    XSizeHints*		/* normal_hints */,
    XWMHints*		/* wm_hints */,
    XClassHint*		/* class_hints */
);

void XmbSetWMProperties(
    Display*		/* display */,
    Window		/* w */,
    const char*	/* window_name */,
    const char*	/* icon_name */,
    char**		/* argv */,
    int			/* argc */,
    XSizeHints*		/* normal_hints */,
    XWMHints*		/* wm_hints */,
    XClassHint*		/* class_hints */
);

void Xutf8SetWMProperties(
    Display*		/* display */,
    Window		/* w */,
    const char*	/* window_name */,
    const char*	/* icon_name */,
    char**		/* argv */,
    int			/* argc */,
    XSizeHints*		/* normal_hints */,
    XWMHints*		/* wm_hints */,
    XClassHint*		/* class_hints */
);

void XSetWMSizeHints(
    Display*		/* display */,
    Window		/* w */,
    XSizeHints*		/* hints */,
    Atom		/* property */
);

int XSetRegion(
    Display*		/* display */,
    GC			/* gc */,
    Region		/* r */
);

void XSetStandardColormap(
    Display*		/* display */,
    Window		/* w */,
    XStandardColormap*	/* colormap */,
    Atom		/* property */
);

int XSetZoomHints(
    Display*		/* display */,
    Window		/* w */,
    XSizeHints*		/* zhints */
);

int XShrinkRegion(
    Region		/* r */,
    int			/* dx */,
    int			/* dy */
);

Status XStringListToTextProperty(
    char**		/* list */,
    int			/* count */,
    XTextProperty*	/* text_prop_return */
);

int XSubtractRegion(
    Region		/* sra */,
    Region		/* srb */,
    Region		/* dr_return */
);

int XmbTextListToTextProperty(
    Display*		display,
    char**		list,
    int			count,
    XICCEncodingStyle	style,
    XTextProperty*	text_prop_return
);

int XwcTextListToTextProperty(
    Display*		display,
    wchar_t**		list,
    int			count,
    XICCEncodingStyle	style,
    XTextProperty*	text_prop_return
);

int Xutf8TextListToTextProperty(
    Display*		display,
    char**		list,
    int			count,
    XICCEncodingStyle	style,
    XTextProperty*	text_prop_return
);

void XwcFreeStringList(
    wchar_t**		list
);

Status XTextPropertyToStringList(
    XTextProperty*	/* text_prop */,
    char***		/* list_return */,
    int*		/* count_return */
);

int XmbTextPropertyToTextList(
    Display*		display,
    const XTextProperty* text_prop,
    char***		list_return,
    int*		count_return
);

int XwcTextPropertyToTextList(
    Display*		display,
    const XTextProperty* text_prop,
    wchar_t***		list_return,
    int*		count_return
);

int Xutf8TextPropertyToTextList(
    Display*		display,
    const XTextProperty* text_prop,
    char***		list_return,
    int*		count_return
);

int XUnionRectWithRegion(
    XRectangle*		/* rectangle */,
    Region		/* src_region */,
    Region		/* dest_region_return */
);

int XUnionRegion(
    Region		/* sra */,
    Region		/* srb */,
    Region		/* dr_return */
);

int XWMGeometry(
    Display*		/* display */,
    int			/* screen_number */,
    const char*	/* user_geometry */,
    const char*	/* default_geometry */,
    unsigned int	/* border_width */,
    XSizeHints*		/* hints */,
    int*		/* x_return */,
    int*		/* y_return */,
    int*		/* width_return */,
    int*		/* height_return */,
    int*		/* gravity_return */
);

int XXorRegion(
    Region		/* sra */,
    Region		/* srb */,
    Region		/* dr_return */
);
]]

local Lib_X11 = ffi.load("X11")

local exports = {
    Lib_X11 = Lib_X11;

-- Bitmask returned by XParseGeometry().  Each bit tells if the corresponding
-- value (x, y, width, height) was found in the parsed string.

    NoValue    = 0x0000;
    XValue     = 0x0001;
    YValue     = 0x0002;
    WidthValue     = 0x0004;
    HeightValue    = 0x0008;
    AllValues  = 0x000F;
    XNegative  = 0x0010;
    YNegative  = 0x0020;



    -- Associative lookup table return codes
    XCSUCCESS = 0;    -- No error.
    XCNOMEM  = 1;    -- Out of memory
    XCNOENT  = 2;    -- No entry in table

    -- library functions
    XLookupString = Lib_X11.XLookupString;
    XPutPixel = Lib_X11.XPutPixel;
    XSetStandardProperties = Lib_X11.XSetStandardProperties;
}

setmetatable(exports, {
    __call = function(self, ...)
        for k,v in pairs(exports) do
            _G[k] = v;
        end

        return self;
    end,
})

return exports
