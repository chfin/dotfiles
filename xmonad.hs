import XMonad
import XMonad.Config.Xfce
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders
import qualified XMonad.StackSet as W
import XMonad.Hooks.ManageHelpers
import XMonad.Util.EZConfig

main = do
     xmonad $ ewmh xfceConfig
		   { terminal = "urxvt"
    	    	   , modMask  = mod3Mask
	    	   , startupHook = startup
	    	   , handleEventHook = handleEventHook xfceConfig <+> fullscreenEventHook
		   , layoutHook=avoidStruts $ smartBorders $ layoutHook xfceConfig
		   , manageHook = manageHook xfceConfig <+> myManageHooks
    	    	   }

myManageHooks = composeAll
--	   [ isFullscreen --> (doF W.focusDown <+> doFullFloat)
           [ isFullscreen --> doFullFloat
           , resource =? "synapse" --> doIgnore
           , className =? "backup" --> doFloat
	   ]

startup :: X()
startup = do
--	spawn "xmodmap -e \"remove Mod4 = Hyper_L\" -e \"add Mod3 = Hyper_L\""
	spawn "xrdb -merge ~/.Xresources"
--	spawn "/bin/sh -c 'ln -s -f \"$XAUTHORITY\" /home/chfin/.Xauthority'"
