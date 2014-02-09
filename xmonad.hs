import XMonad
import XMonad.Config.Xfce
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders

main = do
     xmonad $ ewmh xfceConfig
		   { terminal = "urxvt"
    	    	   , modMask  = mod3Mask
	    	   , startupHook = startup
	    	   , handleEventHook = handleEventHook xfceConfig <+> fullscreenEventHook
		   , layoutHook=avoidStruts $ smartBorders $ layoutHook xfceConfig
    	    	   }

startup :: X()
startup = do
--	spawn "xmodmap -e \"remove Mod4 = Hyper_L\" -e \"add Mod3 = Hyper_L\""
	spawn "xrdb -merge ~/.Xresources"
