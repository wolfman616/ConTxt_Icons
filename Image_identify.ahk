#NoTrayIcon
#noEnv
#persistent
sendMode Input
setWorkingDir %a_scriptDir%

global OutStr

DllCall("AllocConsole")
WinHide % "ahk_id " DllCall("GetConsoleWindow", "ptr")

inputP 				= 		%1%
; MagStr 			= 		magick identify -verbose "%inputP%"
MagStr 				= 		magick identify "%inputP%"
FullStr 				:= 	RunWaitOne(MagStr)
LengthP 			:= 	((StrLen(inputP)) + 2)
LengthS 			:= 	StrLen(FullStr)
OutStr 				:=  	SubStr(FullStr, LengthP , (LengthS - LengthP))

tooltip % OutStr := 	OutStr . "`n CLICK 2 COPY"
settimer xout, -6666
return

; ~LButton:: 
; MouseGetPos, , , OutputVarWin
; WinGetClass, cla55, ahk_id %OutputVarWin%
; if (cla55="tooltips_class32") 
	; Clipboard := OutStr
; sleep 666
; Exitapp

RunWaitOne(command) {
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec(ComSpec " /C " command)
    return exec.StdOut.ReadAll()
}



return,

xout:
exitapp

Open_Script_Location: ;run %a_scriptDir%
toolTip %a_scriptFullPath%
E=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %E%,, hide
return