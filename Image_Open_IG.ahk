#noEnv ; #warn
;#persistent
#singleinstance force
;#WinActivateForce
sendMode Input
setWorkingDir %a_scriptDir%
;DetectHiddenWindows, On

runwait "C:\Program Files\ImageGlas5\ImageGlass.exe" "%1%"
WinGet, hwnd, ID , ahk_EXE ImageGlass.exe
aa = ahk_id %hwnd%
winactivate, ahk_id %HWND%;
Exit
