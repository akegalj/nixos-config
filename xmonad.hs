#!/usr/bin/env nix-shell
#!nix-shell -v --run "ghci repl" -p "haskellPackages.ghcWithPackages (p: with p; [ xmonad xmonad-contrib data-default ])
import Data.Char (toLower)
import Data.Default (def)
import System.Directory
  ( doesDirectoryExist,
    getHomeDirectory,
  )
import XMonad hiding (focus)
import XMonad.Actions.DynamicWorkspaceGroups
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Layout.NoBorders
import XMonad.StackSet
import XMonad.Util.EZConfig

main =
  xmonad . ewmhFullscreen . ewmh $
    def
      { focusFollowsMouse = False,
        normalBorderColor = "#000000",
        modMask = mod1Mask
      }
      `additionalKeysP` [ ("M-S-<Return>", spawnWithMaybeFocusedTerminal),
                          ("<XF86AudioMute>", spawn "amixer set 'Master' toggle"),
                          ("<XF86AudioLowerVolume>", spawn "amixer set 'Master' 5%-"),
                          ("<XF86AudioRaiseVolume>", spawn "amixer set 'Master' 5%+"),
                          ("<XF86MonBrightnessUp>", spawn "light -A 2"),
                          ("<XF86MonBrightnessDown>", spawn "light -U 2"),
                          ("M-y n", promptWSGroupAdd def "Name this group: "),
                          ("M-y g", promptWSGroupView def "Go to group: "),
                          ("M-y d", promptWSGroupForget def "Forget group: ")
                        ]
  where
    returnPath home = replaceTilda . safeTail . takeFrom ':'
      where
        replaceTilda [] = []
        replaceTilda p@(x : xs)
          | x == '~' = home ++ xs
          | otherwise = p
    safeTail xs = if null xs then xs else tail xs
    takeFrom c = dropWhile (not . (c ==))
    lowerCaseClassName = map toLower <$> className
    spawnSpecialTerminalIf b f
      | b = f
      | otherwise = io $ spawn terminal
    spawnWithMaybeFocusedTerminal = do
      mw <- withWindowSet $ return . peek
      case mw of
        Just pid -> flip runQuery pid $ do
          isTerminal <- lowerCaseClassName =? terminalName
          spawnSpecialTerminalIf isTerminal $ do
            home <- io getHomeDirectory
            let path = returnPath home <$> title
            isDirectory <- path >>= io . doesDirectoryExist
            spawnSpecialTerminalIf isDirectory $ path >>= io . spawn . terminalCd
            io $ spawn $ "echo " ++ show home ++ " " ++ show isDirectory ++ ">> ~/bla"
        Nothing -> spawn terminal
    terminal = terminalName ++ terminalOptions
    terminalCd dir = terminal ++ " -cd '" ++ dir ++ "'"
    terminalName = "urxvt"
    terminalOptions = "c" -- c stands for demon/client arhitecture
