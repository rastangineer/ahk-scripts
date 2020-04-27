#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
Menu, Tray, Icon, shell32.dll, 283 ;tray icon is now a little keyboard, or piece of paper or something

;; close all Explorer windows when Winkey x pressed
;; https://autohotkey.com/board/topic/88648-close-all-explorer-windows/
GroupAdd,ExplorerGroup, ahk_class CabinetWClass
GroupAdd,ExplorerGroup, ahk_class ExploreWClass
#x::
  if ( WinExist("ahk_group ExplorerGroup") )
    WinClose,ahk_group ExplorerGroup
return

;;EXPLORER KEYS
#IfWinActive ahk_class CabinetWClass 
F3::
    WinClose, ahk_class CabinetWClass  ;  closes any explorer window https://stackoverflow.com/questions/39601787/close-windows-explorer-window-with-auto-hotkey
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
;F4::send {mButton} ; middle mouse button, which opens a link in a new tab.

;;CHROME KEYS
#IfWinActive ahk_exe chrome.exe
F1::send ^{pgup} ;control shift tab, which goes to the next tab
F2::send ^{pgdn} ;control tab, which goes to the previous tab
F3::send ^w ;control w, which closes a tab

;;VISUAL STUDIO CODE KEYS
#ifwinactive ahk_exe Code.exe
; F1::send ^{pgup} ;control shift tab, which goes to the next tab
; F2::send ^{pgdn} ;control tab, which goes to the previous tab
F3::send ^w ;control w, which closes a tab
^r:: ;Reload this script, https://github.com/TaranVH/2nd-keyboard/blob/master/ALL_MULTIPLE_KEYBOARD_ASSIGNMENTS.ahk#L2290
send ^s
sleep 10
Soundbeep, 1000, 10
Reload
Return
