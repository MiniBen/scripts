import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import XMonad.Layout.SimplestFloat
import XMonad.Layout.ThreeColumns
import XMonad.Layout.NoBorders
import System.IO
import XMonad.Hooks.EwmhDesktops

myWorkspaces = ["web", "term", "edit", "ssh", "music", "extra", "steam"] ++ map show [8..9]
myManageHook = composeAll . concat $
               [ [ className =? c --> doFloat | c <- cFloats ]
               , [ title =? t --> doFloat | t <- tFloats ]
	       , [className =? "Steam" --> doShift "steam"]]
  where cFloats = ["NES"]
        tFloats = ["Firefox Preferences", "Downloads", "Add-ons", "Rename", "Create" ]
myLayout = avoidStruts (
    ThreeColMid 1 (3/100) (1/2) |||
    Tall 1 (3/100) (1/2) |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    Full)
main = do
     xmproc <- spawnPipe "/usr/bin/xmobar"
     xmonad $ defaultConfig
     	    	    { borderWidth = 2
	    	    , terminal 	= "xterm -rv"
                    , workspaces = myWorkspaces
		    , normalBorderColor = "#cccccc"
		    , focusedBorderColor = "#112255"
		    , focusFollowsMouse = False
		    , handleEventHook = handleEventHook defaultConfig <+> fullscreenEventHook
		    , manageHook = myManageHook <+> manageDocks <+> manageHook defaultConfig
		    ,layoutHook = smartBorders $ myLayout
		    , logHook = dynamicLogWithPP xmobarPP
		      { ppOutput = hPutStrLn xmproc
		      ,	ppTitle = xmobarColor "green" "" . shorten 50
		      , ppLayout = const "" -- to disable the layout info on xmobar
		      }
		    , modMask = mod4Mask}
		    `additionalKeysP`
		    [("M-f", spawn "firefox")
		    ,("M-e", spawn "emacs")
		    ,("<XF86AudioRaiseVolume>", spawn  "amixer -q set Master 5+")
                    ,("<XF86AudioLowerVolume>", spawn  "amixer -q set Master 5-")
                    ,("<XF86AudioMute>", spawn  "amixer -q set Master toggle")
		    ,("M-S-=", spawn  "sudo pm-suspend")
		    ,("M-S-l", spawn  "xscreensaver-command --lock")]
