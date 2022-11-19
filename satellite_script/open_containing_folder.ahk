#NoEnv ; 
;#Persistent 
#SingleInstance Force
Menu, Tray, NoStandard
Menu, Tray, Add, Open script folder, Open_script_folder,
Menu, Tray, Standard
Task_Sched:="mmc.exe taskschd.msc /s", Loc:=1, S:=1100 ; S sleep millisecs for handling explorer launch delay
NeedL=i)(\"([\w\d]*[\.]*[\w\d]*)([\.]*[a-z]{2,4})) ;o="a
File=%1% ; Passed Filename as argument from context menu
FileGetShortcut, %1% , OutTarget, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState
if errorlevel 
	Run %COMSPEC% /C explorer.exe /select`, "%1%",, hide ; if accessed from 'SEARCH RESULTS VIEW' *.* should open real location Invoked as it is not a shortcut.
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
Exitapp
}
return

Open_script_folder:	
Run %COMSPEC% /c explorer.exe /select`, "%a_scriptFullPath%",, hide
sleep %S%
sendInput {F5}
exitapp

/* old method  :/
; o:=comobjcreate("Shell.Application") ; splitpath,file,file,directory,ext ; if !errorlevel { 	; od:=o.namespace(directory) 	; of:=od.parsename(file) 	; if (containing_loc:=od.getdetailsof(of,203)) { ;202 - Link status: Unresolved 		; if containing_loc=C:\Windows\System32\schtasks.exe 		; { 			; Run %COMSPEC% /c %Task_Sched%,, Hide 	 ; } Else { 			; splitpath,containing_loc,file2,directory2,ext2 			; If !ext2 { 				; containing_loc:=od.getdetailsof(of,194) 			; } 			; Run %COMSPEC% /c explorer.exe /select`, %containing_loc%\,, Hide 			msgbox %containing_loc% pubes 		; } 	; } Else { 		; GINGER_PUBES:=od.getdetailsof(of,202) 		; Return 	; } ; }
*/
	