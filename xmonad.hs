import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig(additionalKeysP)
import XMonad.Layout.NoBorders(smartBorders)
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Run(spawnPipe)
import System.IO

myShiftHook = composeAll . concat $
               [ [className =? "Steam" --> doShift "steam"]
	       , [className =? "Google Play Music Desktop Player" --> doShift "music"]
	       , [className =? "Firefox" --> doShift "web"]]

myConfig = defaultConfig
	{ manageHook = ( isFullscreen --> doFullFloat ) <+> myShiftHook <+> manageDocks <+> manageHook defaultConfig 
	, layoutHook = smartBorders (avoidStruts $  layoutHook defaultConfig)
	, terminal = "xterm -rv"
	, borderWidth = 2
        , focusFollowsMouse = False
	, focusedBorderColor = "#112255"
        , workspaces = ["web", "term", "edit", "ssh", "music", "extra", "steam"] ++ map show [8..9]
	, modMask = mod4Mask
	} `additionalKeysP`
	[("M-f", spawn "firefox")
		    ,("M-c", spawn "chromium")
		    ,("<XF86AudioRaiseVolume>", spawn  "amixer -q set Master 2+")
                    ,("<XF86AudioLowerVolume>", spawn  "amixer -q set Master 2-")
                    ,("<XF86AudioMute>", spawn  "pactl set-sink-mute 0 toggle")
		    ,("M-S-=", spawn  "sudo pm-suspend")
		    ,("M-S-0", spawn  "sudo pm-hibernate")
		    ,("M-S--", spawn  "sleep 1; xset s activate")
		    ,("M-S-l", spawn  "xscreensaver-command --lock")]

-- The main function.
main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

-- Incase I need to launch something other than xmobar
myBar = "xmobar"

-- What is written to xmobar
myPP = xmobarPP { ppCurrent = xmobarColor "green" "" . wrap "<" ">" . shorten 68
		 , ppLayout = const "" }

toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_s)
