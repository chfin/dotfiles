import XMonad
import XMonad.Config.Xfce
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders
import qualified XMonad.StackSet as W
import XMonad.Hooks.ManageHelpers
import XMonad.Util.EZConfig
import qualified Data.Map as M
import System.Exit
import XMonad.Actions.CycleWS
import XMonad.Layout.Circle
import XMonad.Layout.Dwindle as LDw
import XMonad.Layout.Grid
import XMonad.Hooks.DynamicLog

main = do
     xmonad $ docks $ ewmh xfceConfig
		   { terminal = "urxvt"
    	    	   , modMask  = mod3Mask
	    	   , startupHook = startup
	    	   , handleEventHook = handleEventHook xfceConfig <+> fullscreenEventHook
		   , layoutHook = avoidStruts $ smartBorders $ myLayout
		   , manageHook = manageHook xfceConfig <+> myManageHooks
                   , keys = myKeys
                   , logHook = dynamicLogString myPP >>= xmonadPropLog
    	    	   }

myLayout = (layoutHook defaultConfig) ||| Circle ||| Dwindle R LDw.CW (3/2) (11/10) ||| Grid

myManageHooks = composeAll
--	   [ isFullscreen --> (doF W.focusDown <+> doFullFloat)
           [ isFullscreen --> doFullFloat
           , appName =? "synapse" --> doIgnore
           --, appName =? "albert" --> doIgnore
           , className =? "backup" --> doFloat
           , appName =? "xfce4-notifyd" --> doIgnore
	   ]

startup :: X()
startup = do
--	spawn "xmodmap -e \"remove Mod4 = Hyper_L\" -e \"add Mod3 = Hyper_L\""
	spawn "xrdb -merge ~/.Xresources"
        spawn "killall xfce4-panel xmobar trayer"
        spawn "xfdesktop --quit"
        spawn "feh --bg-scale /home/chfin/Bilder/Maraetaibeforesunrise.jpg"
        spawn "xmobar"
        spawn "trayer --edge top --align right --expand true --width 5 --transparent true --tint 0x333333 --alpha 0 --height 28 --monitor 1"
--	spawn "/bin/sh -c 'ln -s -f \"$XAUTHORITY\" /home/chfin/.Xauthority'"

myFg    = "#dfdfdf"
myFgAlt = "#777"
myPrim  = "#ffb52a"
mySec   = "#0a81f5"
myOk    = "#55aa55"
myAlert = "#bd2c40"
myBg    = "#333"

myPP :: PP
myPP = def { ppCurrent = xmobarColor myPrim ""
           , ppVisible = xmobarColor mySec ""
           , ppHidden  = id -- fg color
           , ppHiddenNoWindows = xmobarColor myFgAlt ""
           , ppUrgent  = xmobarColor myAlert ""
           , ppTitle = shorten 40
           , ppLayout = xmobarColor myFgAlt "" .
                        (\ x -> case x of
                            "Tall" -> "\xe002"
                            "Mirror Tall" -> "\xe003"
                            "Full" -> "\xe000"
                            "Circle" -> "\xe026"
                            "Grid" -> "\xe005"
                            'D':'w':'i':_ -> "\xe007"
                            _ -> x)
           , ppSep = "  "
           }

myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    -- launching and killing programs
    [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf) -- %! Launch terminal
--    , ((modMask,               xK_semicolon), spawn "dmenu_run") -- %! Launch dmenu
--    , ((modMask .|. shiftMask, xK_semicolon), spawn "gmrun") -- %! Launch gmrun
    , ((modMask .|. shiftMask, xK_c     ), kill) -- %! Close the focused window
    , ((modMask .|. shiftMask, xK_z     ), kill) -- %! Close the focused window

    , ((modMask,               xK_space ), sendMessage NextLayout) -- %! Rotate through the available layout algorithms
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf) -- %!  Reset the layouts on the current workspace to default

    , ((modMask,               xK_k     ), refresh) -- %! Resize viewed windows to the correct size

    -- move focus up or down the window stack
    , ((modMask,               xK_Tab   ), windows W.focusDown) -- %! Move focus to the next window
    , ((modMask .|. shiftMask, xK_Tab   ), windows W.focusUp  ) -- %! Move focus to the previous window
    , ((modMask,               xK_n     ), windows W.focusDown) -- %! Move focus to the next window
    , ((modMask,               xK_e     ), windows W.focusUp  ) -- %! Move focus to the previous window
    , ((modMask,               xK_m     ), windows W.focusMaster  ) -- %! Move focus to the master window

    -- modifying the window order
    , ((modMask,               xK_Return), windows W.swapMaster) -- %! Swap the focused window and the master window
    , ((modMask .|. shiftMask, xK_n     ), windows W.swapDown  ) -- %! Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_e     ), windows W.swapUp    ) -- %! Swap the focused window with the previous window

    -- resizing the master/slave ratio
    , ((modMask,               xK_h     ), sendMessage Shrink) -- %! Shrink the master area
    , ((modMask,               xK_i     ), sendMessage Expand) -- %! Expand the master area

    -- floating layer support
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink) -- %! Push window back into tiling

    -- increase or decrease number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1)) -- %! Increment the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1))) -- %! Deincrement the number of windows in the master area

    -- quit, or restart
    , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess)) -- %! Quit xmonad
    , ((modMask              , xK_q     ), spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi") -- %! Restart xmonad

    -- cycle workspaces
    , ((modMask              , xK_Left  ), prevWS)
    , ((modMask              , xK_Right ), nextWS)
    , ((modMask .|. shiftMask, xK_Left  ), shiftToPrev >> prevWS)
    , ((modMask .|. shiftMask, xK_Right ), shiftToNext >> nextWS)
    , ((modMask              , xK_Down  ), nextScreen)
    , ((modMask              , xK_Up    ), prevScreen)
    , ((modMask .|. shiftMask, xK_Down  ), shiftNextScreen)
    , ((modMask .|. shiftMask, xK_Up    ), shiftPrevScreen)
    , ((modMask              , xK_a     ), toggleWS)

--    , ((modMask .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -")) -- %! Run xmessage with a summary of the default keybindings (useful for beginners)
    -- repeat the binding for non-American layout keyboards
--    , ((modMask              , xK_question), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
    ++
    -- mod-[1..9] %! Switch to workspace N
    -- mod-shift-[1..9] %! Move client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    -- mod-{w,e,r} %! Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r} %! Move client to screen 1, 2, or 3
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_f, xK_p] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
