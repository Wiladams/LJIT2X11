local ffi = require("ffi")
local bit = require("bit")
local lshift = bit.lshift
local rshift = bit.rshift

-- The most primitive base types
-- can get some more from Xdefs.h if needed
ffi.cdef[[
typedef char *XPointer;
typedef int Bool;
typedef int Status;
]]


ffi.cdef[[

typedef unsigned long XID;
typedef unsigned long Mask;
typedef unsigned long Atom;

typedef unsigned long VisualID;
typedef unsigned long Time;
]]

-- Most useful handle types
ffi.cdef[[
typedef XID Window;
typedef XID Drawable;
typedef XID Font;
typedef XID Pixmap;
typedef XID Cursor;
typedef XID Colormap;
typedef XID GContext;
typedef XID KeySym;

typedef unsigned char KeyCode;
]]

local exports = {}
setmetatable(exports, {
	__call = function(self, ...)
		for k,v in pairs(exports) do
			_G[k] = v;
		end

		return self;
	end,
})


--/*****************************************************************
-- * RESERVED RESOURCE AND CONSTANT DEFINITIONS
-- *****************************************************************/


exports.None                = 0;	-- universal null resource or null atom

--[[
#define ParentRelative       1L	/* background pixmap in CreateWindow
				    and ChangeWindowAttributes */

#define CopyFromParent       0L	/* border pixmap in CreateWindow
				       and ChangeWindowAttributes
				   special VisualID and special window
				       class passed to CreateWindow */

#define PointerWindow        0L	/* destination window in SendEvent */
#define InputFocus           1L	/* destination window in SendEvent */

#define PointerRoot          1L	/* focus window in SetInputFocus */

#define AnyPropertyType      0L	/* special Atom, passed to GetProperty */

#define AnyKey		     0L	/* special Key Code, passed to GrabKey */

#define AnyButton            0L	/* special Button Code, passed to GrabButton */

#define AllTemporary         0L	/* special Resource ID passed to KillClient */

#define CurrentTime          0L	/* special Time */

#define NoSymbol	     0L	/* special KeySym */
--]]

--[[
/***************************************************************** 
 * EVENT DEFINITIONS 
 *****************************************************************/
--]]

-- Input Event Masks. Used as event-mask window attribute and as arguments
--   to Grab requests.  Not to be confused with event names.

exports.NoEventMask				= 0
exports.KeyPressMask			= lshift(1, 0)  
exports.KeyReleaseMask			= lshift(1, 1)  
exports.ButtonPressMask			= lshift(1, 2)  
exports.ButtonReleaseMask		= lshift(1, 3)  
exports.EnterWindowMask			= lshift(1, 4)  
exports.LeaveWindowMask			= lshift(1, 5)  
exports.PointerMotionMask		= lshift(1, 6)  
exports.PointerMotionHintMask	= lshift(1, 7)  
exports.Button1MotionMask		= lshift(1, 8)  
exports.Button2MotionMask		= lshift(1, 9)  
exports.Button3MotionMask		= lshift(1, 10) 
exports.Button4MotionMask		= lshift(1, 11) 
exports.Button5MotionMask		= lshift(1, 12) 
exports.ButtonMotionMask		= lshift(1, 13) 
exports.KeymapStateMask			= lshift(1, 14)
exports.ExposureMask			= lshift(1, 15) 
exports.VisibilityChangeMask	= lshift(1, 16) 
exports.StructureNotifyMask		= lshift(1, 17) 
exports.ResizeRedirectMask		= lshift(1, 18) 
exports.SubstructureNotifyMask	= lshift(1, 19) 
exports.SubstructureRedirectMask	= lshift(1, 20) 
exports.FocusChangeMask			= lshift(1, 21) 
exports.PropertyChangeMask		= lshift(1, 22) 
exports.ColormapChangeMask		= lshift(1, 23) 
exports.OwnerGrabButtonMask		= lshift(1, 24) 



ffi.cdef[[

/* Event names.  Used in "type" field in XEvent structures.  Not to be
confused with event masks above.  They start from 2 because 0 and 1
are reserved in the protocol for errors and replies. */

static const int KeyPress		=2;
static const int KeyRelease		=3;
static const int ButtonPress		=4;
static const int ButtonRelease	=	5;
static const int MotionNotify	=	6;
static const int EnterNotify		=7;
static const int LeaveNotify		=8;
static const int FocusIn			=9;
static const int FocusOut		=10;
static const int KeymapNotify	=	11;
static const int Expose			=12;
static const int GraphicsExpose	=	13;
static const int NoExpose		=14;
static const int VisibilityNotify=	15;
static const int CreateNotify	=	16;
static const int DestroyNotify	=	17;
static const int UnmapNotify		=18;
static const int MapNotify		=19;
static const int MapRequest		=20;
static const int ReparentNotify	=	21;
static const int ConfigureNotify	=	22;
static const int ConfigureRequest=	23;
static const int GravityNotify	=	24;
static const int ResizeRequest	=	25;
static const int CirculateNotify	=	26;
static const int CirculateRequest=	27;
static const int PropertyNotify	=	28;
static const int SelectionClear	=	29;
static const int SelectionRequest=	30;
static const int SelectionNotify	=	31;
static const int ColormapNotify	=	32;
static const int ClientMessage	=	33;
static const int MappingNotify	=	34;
static const int GenericEvent	=	35;
static const int LASTEvent		= 36;	// must be bigger than any event #
]]

ffi.cdef[[
/* Key masks. Used as modifiers to GrabButton and GrabKey, results of QueryPointer,
   state in various key-, mouse-, and button-related events. */

static const int ShiftMask		=(1<<0);
static const int LockMask		=(1<<1);
static const int ControlMask		=(1<<2);
static const int Mod1Mask		=(1<<3);
static const int Mod2Mask		=(1<<4);
static const int Mod3Mask		=(1<<5);
static const int Mod4Mask		=(1<<6);
static const int Mod5Mask		=(1<<7);
]]

--[[
/* modifier names.  Used to build a SetModifierMapping request or
   to read a GetModifierMapping request.  These correspond to the
   masks defined above. */
#define ShiftMapIndex		0
#define LockMapIndex		1
#define ControlMapIndex		2
#define Mod1MapIndex		3
#define Mod2MapIndex		4
#define Mod3MapIndex		5
#define Mod4MapIndex		6
#define Mod5MapIndex		7


/* button masks.  Used in same manner as Key masks above. Not to be confused
   with button names below. */

#define Button1Mask		(1<<8)
#define Button2Mask		(1<<9)
#define Button3Mask		(1<<10)
#define Button4Mask		(1<<11)
#define Button5Mask		(1<<12)

#define AnyModifier		(1<<15)  /* used in GrabButton, GrabKey */


/* button names. Used as arguments to GrabButton and as detail in ButtonPress
   and ButtonRelease events.  Not to be confused with button masks above.
   Note that 0 is already defined above as "AnyButton".  */

#define Button1			1
#define Button2			2
#define Button3			3
#define Button4			4
#define Button5			5

/* Notify modes */

#define NotifyNormal		0
#define NotifyGrab		1
#define NotifyUngrab		2
#define NotifyWhileGrabbed	3

#define NotifyHint		1	/* for MotionNotify events */
		       
/* Notify detail */

#define NotifyAncestor		0
#define NotifyVirtual		1
#define NotifyInferior		2
#define NotifyNonlinear		3
#define NotifyNonlinearVirtual	4
#define NotifyPointer		5
#define NotifyPointerRoot	6
#define NotifyDetailNone	7

/* Visibility notify */

#define VisibilityUnobscured		0
#define VisibilityPartiallyObscured	1
#define VisibilityFullyObscured		2

/* Circulation request */

#define PlaceOnTop		0
#define PlaceOnBottom		1

/* protocol families */

#define FamilyInternet		0	/* IPv4 */
#define FamilyDECnet		1
#define FamilyChaos		2
#define FamilyInternet6		6	/* IPv6 */

/* authentication families not tied to a specific protocol */
#define FamilyServerInterpreted 5

/* Property notification */

#define PropertyNewValue	0
#define PropertyDelete		1

/* Color Map notification */

#define ColormapUninstalled	0
#define ColormapInstalled	1

/* GrabPointer, GrabButton, GrabKeyboard, GrabKey Modes */

#define GrabModeSync		0
#define GrabModeAsync		1

/* GrabPointer, GrabKeyboard reply status */

#define GrabSuccess		0
#define AlreadyGrabbed		1
#define GrabInvalidTime		2
#define GrabNotViewable		3
#define GrabFrozen		4

/* AllowEvents modes */

#define AsyncPointer		0
#define SyncPointer		1
#define ReplayPointer		2
#define AsyncKeyboard		3
#define SyncKeyboard		4
#define ReplayKeyboard		5
#define AsyncBoth		6
#define SyncBoth		7

/* Used in SetInputFocus, GetInputFocus */

#define RevertToNone		(int)None
#define RevertToPointerRoot	(int)PointerRoot
#define RevertToParent		2
--]]

--[[
/*****************************************************************
 * ERROR CODES 
 *****************************************************************/

#define Success		   0	/* everything's okay */
#define BadRequest	   1	/* bad request code */
#define BadValue	   2	/* int parameter out of range */
#define BadWindow	   3	/* parameter not a Window */
#define BadPixmap	   4	/* parameter not a Pixmap */
#define BadAtom		   5	/* parameter not an Atom */
#define BadCursor	   6	/* parameter not a Cursor */
#define BadFont		   7	/* parameter not a Font */
#define BadMatch	   8	/* parameter mismatch */
#define BadDrawable	   9	/* parameter not a Pixmap or Window */
#define BadAccess	  10	/* depending on context:
				 - key/button already grabbed
				 - attempt to free an illegal 
				   cmap entry 
				- attempt to store into a read-only 
				   color map entry.
 				- attempt to modify the access control
				   list from other than the local host.
				*/
#define BadAlloc	  11	/* insufficient resources */
#define BadColor	  12	/* no such colormap */
#define BadGC		  13	/* parameter not a GC */
#define BadIDChoice	  14	/* choice not in range or already used */
#define BadName		  15	/* font or color name doesn't exist */
#define BadLength	  16	/* Request length incorrect */
#define BadImplementation 17	/* server is defective */

#define FirstExtensionError	128
#define LastExtensionError	255
--]]

ffi.cdef[[
/*****************************************************************
 * WINDOW DEFINITIONS 
 *****************************************************************/

/* Window classes used by CreateWindow */
/* Note that CopyFromParent is already defined as 0 above */

static const int InputOutput		=1;
static const int InputOnly		=2;

/* Window attributes for CreateWindow and ChangeWindowAttributes */

static const int CWBackPixmap		=(1<<0);
static const int CWBackPixel		=(1<<1);
static const int CWBorderPixmap		=(1<<2);
static const int CWBorderPixel      =     (1<<3);
static const int CWBitGravity		=(1<<4);
static const int CWWinGravity		=(1<<5);
static const int CWBackingStore     =     (1<<6);
static const int CWBackingPlanes	=        (1<<7);
static const int CWBackingPixel	    =    (1<<8);
static const int CWOverrideRedirect	=(1<<9);
static const int CWSaveUnder		=(1<<10);
static const int CWEventMask		=(1<<11);
static const int CWDontPropagate	       = (1<<12);
static const int CWColormap		=(1<<13);
static const int CWCursor	     =   (1<<14);

/* ConfigureWindow structure */

static const int CWX			=(1<<0);
static const int CWY			=(1<<1);
static const int CWWidth		=	(1<<2);
static const int CWHeight		=(1<<3);
static const int CWBorderWidth	=	(1<<4);
static const int CWSibling		=(1<<5);
static const int CWStackMode		=(1<<6);


/* Bit Gravity */

static const int ForgetGravity		=0;
static const int NorthWestGravity	=1;
static const int NorthGravity		=2;
static const int NorthEastGravity	=3;
static const int WestGravity		=4;
static const int CenterGravity		=5;
static const int EastGravity		=6;
static const int SouthWestGravity	=7;
static const int SouthGravity		=8;
static const int SouthEastGravity	=9;
static const int StaticGravity		=10;

/* Window gravity + bit gravity above */

static const int UnmapGravity		=0;

/* Used in CreateWindow for backing-store hint */

static const int NotUseful              = 0;
static const int WhenMapped             = 1;
static const int Always                 = 2;

/* Used in GetWindowAttributes reply */

static const int IsUnmapped		=0;
static const int IsUnviewable	=1;
static const int IsViewable		=2;

/* Used in ChangeSaveSet */

static const int SetModeInsert          = 0;
static const int SetModeDelete          = 1;

/* Used in ChangeCloseDownMode */

static const int DestroyAll             = 0;
static const int RetainPermanent        = 1;
static const int RetainTemporary        = 2;

/* Window stacking method (in configureWindow) */

static const int Above                  = 0;
static const int Below                  = 1;
static const int TopIf                  = 2;
static const int BottomIf               = 3;
static const int Opposite               = 4;

/* Circulation direction */

static const int RaiseLowest            = 0;
static const int LowerHighest           = 1;

/* Property modes */

static const int PropModeReplace        = 0;
static const int PropModePrepend        = 1;
static const int PropModeAppend         = 2;
]]

--[[
/*****************************************************************
 * GRAPHICS DEFINITIONS
 *****************************************************************/

/* graphics functions, as in GC.alu */

#define	GXclear			0x0		/* 0 */
#define GXand			0x1		/* src AND dst */
#define GXandReverse		0x2		/* src AND NOT dst */
#define GXcopy			0x3		/* src */
#define GXandInverted		0x4		/* NOT src AND dst */
#define	GXnoop			0x5		/* dst */
#define GXxor			0x6		/* src XOR dst */
#define GXor			0x7		/* src OR dst */
#define GXnor			0x8		/* NOT src AND NOT dst */
#define GXequiv			0x9		/* NOT src XOR dst */
#define GXinvert		0xa		/* NOT dst */
#define GXorReverse		0xb		/* src OR NOT dst */
#define GXcopyInverted		0xc		/* NOT src */
#define GXorInverted		0xd		/* NOT src OR dst */
#define GXnand			0xe		/* NOT src OR NOT dst */
#define GXset			0xf		/* 1 */

/* LineStyle */

#define LineSolid		0
#define LineOnOffDash		1
#define LineDoubleDash		2

/* capStyle */

#define CapNotLast		0
#define CapButt			1
#define CapRound		2
#define CapProjecting		3

/* joinStyle */

#define JoinMiter		0
#define JoinRound		1
#define JoinBevel		2

/* fillStyle */

#define FillSolid		0
#define FillTiled		1
#define FillStippled		2
#define FillOpaqueStippled	3

/* fillRule */

#define EvenOddRule		0
#define WindingRule		1

/* subwindow mode */

#define ClipByChildren		0
#define IncludeInferiors	1

/* SetClipRectangles ordering */

#define Unsorted		0
#define YSorted			1
#define YXSorted		2
#define YXBanded		3

/* CoordinateMode for drawing routines */

#define CoordModeOrigin		0	/* relative to the origin */
#define CoordModePrevious       1	/* relative to previous point */

/* Polygon shapes */

#define Complex			0	/* paths may intersect */
#define Nonconvex		1	/* no paths intersect, but not convex */
#define Convex			2	/* wholly convex */

/* Arc modes for PolyFillArc */

#define ArcChord		0	/* join endpoints of arc */
#define ArcPieSlice		1	/* join endpoints to center of arc */

/* GC components: masks used in CreateGC, CopyGC, ChangeGC, OR'ed into
   GC.stateChanges */

#define GCFunction              (1L<<0)
#define GCPlaneMask             (1L<<1)
#define GCForeground            (1L<<2)
#define GCBackground            (1L<<3)
#define GCLineWidth             (1L<<4)
#define GCLineStyle             (1L<<5)
#define GCCapStyle              (1L<<6)
#define GCJoinStyle		(1L<<7)
#define GCFillStyle		(1L<<8)
#define GCFillRule		(1L<<9) 
#define GCTile			(1L<<10)
#define GCStipple		(1L<<11)
#define GCTileStipXOrigin	(1L<<12)
#define GCTileStipYOrigin	(1L<<13)
#define GCFont 			(1L<<14)
#define GCSubwindowMode		(1L<<15)
#define GCGraphicsExposures     (1L<<16)
#define GCClipXOrigin		(1L<<17)
#define GCClipYOrigin		(1L<<18)
#define GCClipMask		(1L<<19)
#define GCDashOffset		(1L<<20)
#define GCDashList		(1L<<21)
#define GCArcMode		(1L<<22)

#define GCLastBit		22
]]

ffi.cdef[[
/*****************************************************************
 * FONTS 
 *****************************************************************/

/* used in QueryFont -- draw direction */
static const int FontLeftToRight	=	0;
static const int FontRightToLeft	=	1;

static const int FontChange		=255;
]]

ffi.cdef[[
/*****************************************************************
 *  IMAGING 
 *****************************************************************/

/* ImageFormat -- PutImage, GetImage */

static const int XYBitmap		= 0;	/* depth 1, XYFormat */
static const int XYPixmap		= 1;	/* depth == drawable depth */
static const int ZPixmap		= 2;	/* depth == drawable depth */
]]

--[[
/*****************************************************************
 *  COLOR MAP STUFF 
 *****************************************************************/

/* For CreateColormap */

#define AllocNone		0	/* create map with no entries */
#define AllocAll		1	/* allocate entire map writeable */


/* Flags used in StoreNamedColor, StoreColors */

#define DoRed			(1<<0)
#define DoGreen			(1<<1)
#define DoBlue			(1<<2)

/*****************************************************************
 * CURSOR STUFF
 *****************************************************************/

/* QueryBestSize Class */

#define CursorShape		0	/* largest size that can be displayed */
#define TileShape		1	/* size tiled fastest */
#define StippleShape		2	/* size stippled fastest */

/***************************************************************** 
 * KEYBOARD/POINTER STUFF
 *****************************************************************/

#define AutoRepeatModeOff	0
#define AutoRepeatModeOn	1
#define AutoRepeatModeDefault	2

#define LedModeOff		0
#define LedModeOn		1

/* masks for ChangeKeyboardControl */

#define KBKeyClickPercent	(1L<<0)
#define KBBellPercent		(1L<<1)
#define KBBellPitch		(1L<<2)
#define KBBellDuration		(1L<<3)
#define KBLed			(1L<<4)
#define KBLedMode		(1L<<5)
#define KBKey			(1L<<6)
#define KBAutoRepeatMode	(1L<<7)

#define MappingSuccess     	0
#define MappingBusy        	1
#define MappingFailed		2

#define MappingModifier		0
#define MappingKeyboard		1
#define MappingPointer		2
--]]

ffi.cdef[[
/*****************************************************************
 * SCREEN SAVER STUFF 
 *****************************************************************/

static const int DontPreferBlanking	= 0;
static const int PreferBlanking		= 1;
static const int DefaultBlanking		= 2;

static const int DisableScreenSaver	= 0;
static const int DisableScreenInterval	= 0;

static const int DontAllowExposures	= 0;
static const int AllowExposures		= 1;
static const int DefaultExposures	= 2;

/* for ForceScreenSaver */

static const int ScreenSaverReset = 0;
static const int ScreenSaverActive = 1;
]]

ffi.cdef[[
/*****************************************************************
 * HOSTS AND CONNECTIONS
 *****************************************************************/

/* for ChangeHosts */

static const int HostInsert		= 0;
static const int HostDelete		= 1;

/* for ChangeAccessControl */

static const int EnableAccess		= 1;      
static const int DisableAccess		= 0;
]]

ffi.cdef[[
/* Display classes  used in opening the connection 
 * Note that the statically allocated ones are even numbered and the
 * dynamically changeable ones are odd numbered */

static const int StaticGray		= 0;
static const int GrayScale		= 1;
static const int StaticColor		= 2;
static const int PseudoColor		= 3;
static const int TrueColor		= 4;
static const int DirectColor		= 5;


/* Byte order  used in imageByteOrder and bitmapBitOrder */

static const int LSBFirst		= 0;
static const int MSBFirst		= 1;
]]


return exports
