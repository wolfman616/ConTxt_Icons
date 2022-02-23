#noEnv ; #warn
;#persistent
#singleinstance force
;#WinActivateForce
sendMode Input
setWorkingDir %a_scriptDir%
DetectHiddenWindows, On

menu, tray, add, Open Script Folder, Open_Script_Location,
menu, tray, standard

runwait "C:\Program Files\ImageGlas5\ImageGlass.exe" "%1%"
WinGet, hwnd, ID , ahk_EXE ImageGlass.exe
aa = ahk_id %hwnd%
winactivate, ahk_id %HWND%;
Exit

Open_Script_Location: ;run %a_scriptDir%
toolTip %a_scriptFullPath%
E=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %E%,, hide
return