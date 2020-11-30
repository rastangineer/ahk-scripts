SendMode Input
SetWorkingDir, %A_ScriptDir%
Menu, Tray, Icon, shell32.dll, 283 ;tray icon is now a little keyboard, or piece of paper or something


#SingleInstance, Force
#UseHook
#InstallKeybdHook

;; basically includes personal text macros
#include custom_texts.ahk 



GroupAdd,ExplorerGroup, ahk_class CabinetWClass
GroupAdd,ExplorerGroup, ahk_class ExploreWClass



;; How to disable Office Hot Key
;; https://superuser.com/questions/1457073/how-do-i-disable-specific-windows-10-office-keyboard-shortcut-ctrlshiftwinal

;; deactivate capslock completely
SetCapslockState, AlwaysOff

;; remap capslock to hyper
;; if capslock is toggled, remap it to esc

;; note: must use tidle prefix to fire hotkey once it is pressed
;; not until the hotkey is released
~Capslock::
    ;; must use downtemp to emulate hyper key, you cannot use down in this case 
    ;; according to https://autohotkey.com/docs/commands/Send.htm, downtemp is as same as down except for ctrl/alt/shift/win keys
    ;; in those cases, downtemp tells subsequent sends that the key is not permanently down, and may be 
    ;; released whenever a keystroke calls for it.
    ;; for example, Send {Ctrl Downtemp} followed later by Send {Left} would produce a normal {Left}
    ;; keystroke, not a Ctrl{Left} keystroke
    Send {Ctrl DownTemp}{Shift DownTemp}{Alt DownTemp}{LWin DownTemp}
    KeyWait, Capslock
    Send {Ctrl Up}{Shift Up}{Alt Up}{LWin Up}
    if (A_PriorKey = "Capslock") {
        Send {Esc}
    }
return

;; Zoom Meeting shortcut
~Capslock & 3::
Send !^+{z}
;; NOTE: On Zoom settings, enable the following keyboard shortcut: Navigate Among Zoom Popup Windows
Return

;; Slack shortcut
~Capslock & 4::
IfWinActive ahk_exe slack.exe
{
  send +!{Up} ;shift alt up
}
Else
{
  IfWinNotExist ahk_exe slack.exe
    run, "C:\Users\%A_UserName%\AppData\Local\slack\slack.exe"
  WinWait, ahk_exe slack.exe
  winactivate, ahk_exe slack.exe
}
Return

;; vim navigation with hyper
~Capslock & h:: Send {Left}
~Capslock & l:: Send {Right}
~Capslock & k:: Send {Up}
~Capslock & j:: Send {Down}

;; popular hotkeys with hyper
~Capslock & c:: Send ^{c}
~Capslock & v:: Send ^{v}

;; create tick tick task with selected text
~Capslock & 0::
  Send ^{c} ;; ctrl + c
  sleep 300
  Send ^+{a} ;; ctrl + shift + a
  sleep 300
  Send ^{v} ;; ctrl + v
  Send {Space}{#}work{Enter}
Return

;; gtranslate selected text to spanish
~Capslock & i::
  Send ^c ;; ctrl + c
  ; sleep 100
  ClipWait, 2 ; wait for the clipboard to change
  t2translate := clipboard
  Run https://translate.google.com/?hl=es#view=home&op=translate&sl=auto&tl=es&text=%t2translate%
Return


;; GLOBAL HOTKEYS

;;Connect to VPN
!+p:: ;shift+alt+p
  Run, C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\vpnui.exe
  sleep 2000
  send {Enter}
  sleep 3000
  send ^!a

Return

;;Disconnect from VPN
!+o:: ;shift+alt+p
  Run, C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\vpnui.exe
  sleep 1000
  send {Enter}
Return

;;Remap Win+Space (switch keyboard languades) to Alt+Space (launchy)
##Space::
  send !{Space}
return

;;Disable Win+Tab (show desktops)
##Tab:: return

;; close all Explorer windows when Winkey x pressed
;; https://autohotkey.com/board/topic/88648-close-all-explorer-windows/
#x:: ;; Win + x , close all explorer windows
  if ( WinExist("ahk_group ExplorerGroup") )
    WinClose,ahk_group ExplorerGroup ; 
return

#t:: ;; Win + T , set current window on top 
  WinSet, AlwaysOnTop, Toggle,A
Return

;;Close any other window
F3::
  PostMessage, 0x112, 0xF060,,, A
Return

F4:: ;; F4 , Open/Bring Slack, if window is active go to previous non-read message
IfWinActive ahk_exe slack.exe
{
  send +!{Up} ;shift alt up
}
Else
{
  IfWinNotExist ahk_exe slack.exe
    run, "C:\Users\%A_UserName%\AppData\Local\slack\slack.exe"
  WinWait, ahk_exe slack.exe
  winactivate, ahk_exe slack.exe
}
Return

;;EXPLORER KEYS
#IfWinActive ahk_class CabinetWClass 
F3:: ;  closes any explorer window https://stackoverflow.com/questions/39601787/close-windows-explorer-window-with-auto-hotkey
  WinClose, ahk_class CabinetWClass  
return

;;OUTLOOK KEYS
#IfWinActive ahk_exe OUTLOOK.EXE
F3::send !4 ; alt + 4, make sure the fourth option on Outlok Quick Access Toolbar is set to Mark All as Read, https://superuser.com/questions/385173/is-there-a-shortcut-for-mark-all-messages-as-read-in-outlook
return

;;FIREFOX KEYS
#IfWinActive ahk_class MozillaWindowClass ;or ahk_class Chrome_WidgetWin_1
F1::send ^{pgup} ;control shift tab, which goes to the next tab
F2::send ^{pgdn} ;control tab, which goes to the previous tab
F3::send ^w ;control w, which closes a tab
$F9:: ;https://www.autohotkey.com/boards/viewtopic.php?t=72431
  #include local_vars.ahk
  Clipboard := ""
  Send {F6}
  while !Clipboard {
      Sleep, 50
      Send ^c
  }
  Send {F6}
  WinGetActiveTitle, title
  Clipboard := "* [" . title . "](" . Clipboard . ")"
  ; MsgBox, % Clipboard
  Clipboard := StrReplace(Clipboard, "Mozilla Firefox")

  ;https://www.autohotkey.com/boards/viewtopic.php?t=61744
  FileRead, currentLinks, %linksFilePath%
  currentLinks := "" . Clipboard . "`r`n`r`n" . currentLinks
  FileDelete, %linksFilePath%
  FileAppend, %currentLinks%, %linksFilePath%
Return

^!c:: ; ctrl+alt+c
  #include local_vars.ahk
  Clipboard := ""
  Send {F6}
  while !Clipboard {
      Sleep, 50
      Send ^c
  }
  Send {F6}
  WinGetActiveTitle, title
  title := StrReplace(title, "Mozilla Firefox")
  MsgBox, % title
  Clipboard := "[" . title . "](" . Clipboard . ")"
  ; Clipboard := StrReplace(Clipboard, " — Mozilla Firefox")
  MsgBox, % Clipboard

Return ; ends a multiline command


;;CHROME KEYS
#IfWinActive ahk_exe chrome.exe
F1::send ^{pgup} ;control shift tab, which goes to the next tab
F2::send ^{pgdn} ;control tab, which goes to the previous tab
F3::send ^w ;control w, which closes a tab

;;VISUAL STUDIO CODE KEYS
#ifwinactive ahk_exe Code.exe
F1::send ^{pgup} ;control shift tab, which goes to the next tab
F2::send ^{pgdn} ;control tab, which goes to the previous tab
F3::send ^w ;control w, which closes a tab
^r:: ;; control + R , Reload this script, https://github.com/TaranVH/2nd-keyboard/blob/master/ALL_MULTIPLE_KEYBOARD_ASSIGNMENTS.ahk#L2290
  send ^s
  sleep 10
  Soundbeep, 1000, 10
  Reload
Return




