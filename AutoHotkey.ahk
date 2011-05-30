;;; # = Win
;;; ^ = Ctrl
;;; ! = Alt
;;; + = Shift

;;; Setup
  #SingleInstance force
  #NoEnv
  ;#Warn All
  SendMode Input
  SetWorkingDir %A_ScriptDir%
  ListLines Off
  SetTitleMatchMode 2 ; Match anywhere in title
;;; End setup


;;;Sending any other way than SendPlay causes it to send on keyup rather than keydown
  #\::SendPlay c:\users\russell\

;;;
  #Escape::WinMinimize,A

;;;
  ^Escape::
    if WinActive("ahk_class MozillaUIWindowClass") {
      RunWait,firefox.exe -unfocus
      WinActivate ahk_class MozillaUIWindowClass
    }
  return

;;; Auto-reloads the script when you save it in an editor with CTRL-s
  ~^s::
    SetTitleMatchMode 2
    IfWinActive, .ahk
    {
        Sleep, 1000
        ToolTip, Reloading...
        Sleep, 500
        Reload
        ToolTip
    }
  return

;;; IntelliJ/PhpStorm fixes
  #IfWinActive, JetBrains ahk_class SunAwtFrame
    ^f::SendInput ^f^a ;;; Make ctrl+f not suck
  #IfWinActive

;;; Always-On-Top toggle
  #z::WinSet, AlwaysOnTop, Toggle, A

;;; Paste from saved clipboard files
  #v::
    Input, Key, L1,{Esc}{Enter}
    if (Key = "s")
        ClipFile=code-span.clip
    else if (Key = "d")
        ClipFile=code-div.clip
    else if (Key = "t")
        ClipFile=clipboard.txt
    else if (Key = "w") {
        FileAppend, %ClipboardAll%, C:\clipboard.txt ; The file extension doesn't matter.
        return
    } else {
        SoundBeep
        return
    }
    Clipboard := ClipFile

    ClipSave=%ClipboardAll%
    FileRead, Clipboard, *c %A_ScriptDir%\ahkclipboard\%ClipFile%
    Send ^v
    Clipboard=%ClipSave%
  return

;;;
  #q::Send !{F4}
;;;
  #^a::Run emeditor.exe c:\users\russell\dropbox\progs\ahk\AutoHotkey.ahk

;;; Run winamp, load media library, set to local media, focus search box
  #w::
    Run winamp.exe
    WinWaitActive ahk_class BaseWindow_RootWnd
    ControlFocus SysTreeView321 ;Media library
    Send l
    Sleep 100
    Send {Tab}
  return

#IfWinActive, ahk_class BaseWindow_RootWnd ;Winamp
  ;;; Override this script's default minimize behavior. Sending a minimize message to the active winamp
  ;;; window (ahk_class BaseWindow_RootWnd) causes weird behavior -- the winamp window only partially
  ;;; minimizes, and restoring it causes this other proxy window to initially gain the focus, which causes
  ;;; problems for this script. Minimizing the proxy window instead makes everything work normally.
  #Escape::WinMinimize ahk_class Winamp v1.x
  ^e::ControlFocus Winamp Playlist Editor
  ^m::ControlFocus SysTreeView321 ;Media library
#IfWinActive

;AppsKey::RWin
;AppsKey Up::
;  if (A_PriorKeyEvent = "RWin")
;    Send {Blind}{Ctrl}{RWin Up}{AppsKey}
;  else
;    Send {Blind}{RWin Up}
;return

;;; Make RWin by itself act as AppsKey
  RWin & Browser_Refresh::return
  RWin::AppsKey

;;; Remap browser buttons to mouse buttons
  Browser_Back::LButton
  Browser_Forward::RButton

;;; Switch between windows in the same app using VistaSwitcher
;;; (immediately activates windows rather than scrolling through a list)
  #IfWinActive ahk_class mintty
    +^Tab:: ;Fall through
  #IfWinActive
  +!CapsLock::
    Send #{F11}
    WinWaitActive ahk_class VistaSwitcher_SwitcherWnd
    Send {Blind}{End}{Space}
  return

  #IfWinActive ahk_class mintty
    ^Tab:: ;Fall through
  #IfWinActive
  !CapsLock::
    Critical ;Make sure the Up hotkeys don't fire before this is done
    Send #{F11}
    WinWaitActive ahk_class VistaSwitcher_SwitcherWnd
    if (Switching)
      Send {Blind}{Down}
    else
      Switching := True
    Send {Blind}{Space}
  return

  ~Ctrl Up::
    Switching := False
  return
  ~Alt Up::
    Switching := False
  return

  ;;; Make switcher go away when releasing alt
  ;#IfWinActive ahk_class VistaSwitcher_SwitcherWnd
    ;~Alt Up::Send {Space}
  ;#IfWinActive

;;;