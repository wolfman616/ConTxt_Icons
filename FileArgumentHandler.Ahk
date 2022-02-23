#noEnv ; #warn
#persistent
#singleinstance force
sendMode Input
DetectHiddenWindows on
SetTitleMatchMode slow

This_Path := Selected_Files()
msgbox % This_Path
Action=%1% ; first arument passed in will be the desired outcome

switch Action {
	case "Normalize":
	{
		Loop, Parse, This_Path , `n,
		{
			if !ListofFiles
				ListofFiles = "%A_LoopField%"
			else 
				ListofFiles = %ListofFiles% "%A_LoopField%"
		}
				;	FileListStr_array := (StrSplit(FileListStr, "`n"))
			clipboard := ListofFiles
			;runwait %comspec% /c ffmpeg-normalize %ListofFiles% --tp 0
			msgbox ListofFiles
			return
	}
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
