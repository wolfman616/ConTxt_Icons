 #noEnv ; #warn
#persistent
#singleinstance force
sendMode Input

NeedL=i)(\"([\w\d]*[\.]*[\w\d]*)([\.]*[a-z]{2,4})) ;o="a
File=%1%
Task_Sched:="mmc.exe taskschd.msc /s", Loc:=1, S:=1100 ; S sleep millisecs for handling explorer launch delay

menu, tray, icon, C:\Icon\24\copy_32.ico
menu, tray, noStandard
menu, tray, add, Open Script Folder, Open_Script_Location,
menu, tray, standard
menu, tray, tip , Copy path %File% extraction for:`n%infile%

This_Path := Selected_Files()

Task_Sched:="mmc.exe taskschd.msc /s", Loc:=1, S:=1100 ; S sleep millisecs for handling explorer launch delay
NeedL=i)(\"([\w\d]*[\.]*[\w\d]*)([\.]*[a-z]{2,4})) ;o="a
File=%This_Path% ; Passed Filename as argument from context menu
FileGetShortcut, %This_Path% , OutTarget, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState
if errorlevel 
	msgbox mulu
else {
	if (OutTarget="C:\Windows\System32\schtasks.exe") { 
		Run %COMSPEC% /C %Task_Sched%,, hide			
		While an00s:=regexmatch(OutArgs, NeedL, Returning, loc) { ; to obtain commandline argument from scheduled task .lnk
			Loc := 999
			Sleep %S% ; Allow some ms to load task-sched...
			msgbox %Returning%" 	; o="a ; Next... show a "Hint"...( task argument  parameter .EXE )  Will index some common culprits into a list to show exe additional to task-sched.
		}
	} else {
		run %COMSPEC% /C explorer.exe /select`, "%OutTarget%",, hide
		sleep %S%
		sendinput {F5}
	}
	return
}
return



Selected_Files() {
	IfWinActive, ahk_class CabinetWClass ; Explorer
	{
		for window in ComObjCreate("Shell.Application").Windows
			if window.HWND = WinExist("A")
				This_window := window
			if(This_window.Document.SelectedItems.Count > 1) {    ; Multiple Items selected
				these_files := ""
				for item in This_window.Document.SelectedItems
				these_files .= item.Path . "`n"
				Return these_files
			} Else Return This_window.Document.FocusedItem.Path
	} Else {
		if(WinActive("ahk_class Progman") || WinActive("ahk_class WorkerW")) {  ;Desktop
			ControlGet, SelectedFiles, List, Selected Col1, SysListView321, A
			if InStr(SelectedFiles, "`n") {		; Multiple Items
				these_files := ""
				Loop, Parse, SelectedFiles, `n, `r
				these_files .= A_Desktop . "\" . A_LoopField . "`n"
				Return these_files
			} Else Return A_Desktop . "\" . SelectedFiles
		} Else Return False
	}
}



Open_Script_Location:	
Run %COMSPEC% /c explorer.exe /select`, "%a_scriptFullPath%",, hide
sleep %S%
sendInput {F5}
return
