-- default desktop configuration for Fedora

import System.Posix.Env (getEnv)
import Data.Maybe (maybe)

import XMonad
--import XMonad.Config.Desktop
--import XMonad.Config.Gnome
--import XMonad.Config.Kde
import XMonad.Config.Xfce

main = do
     xmonad $ xfceConfig
     	    { terminal = "urxvt"
    	    , modMask  = mod3Mask
	    , startupHook = startup
    	    }

startup :: X()
startup = do
	spawn "xmodmap -e \"remove Mod4 = Hyper_L\" -e \"add Mod3 = Hyper_L\""

--main = do
--     session <- getEnv "DESKTOP_SESSION"
--     xmonad  $ maybe desktopConfig desktop session

--desktop "gnome" = gnomeConfig
--desktop "kde" = kde4Config
--desktop "xfce" = xfceConfig

--desktop "xmonad-mate" = gnomeConfig
--desktop _ = desktopConfig
