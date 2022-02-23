#NoEnv 
#Persistent
#SingleInstance FORCE
SetWorkingDir %A_ScriptDir% 
fullpath=%1%
SplitPath, 1 , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
concat:="c:\out\temp.txt"
Gui, GuiName:new , , Poop
Gui +HwndMyGuiHwnd
Gui, Add, Text,, Start Pos Min:
Gui, Add, Edit, w80 Center R1 Number vStart_Min
Gui, Add, Text,, Start Pos Sec:
Gui, Add, Edit, w80 Center R1 Number vStart_Sec
GuiControl,, Start_Min, 0
GuiControl,, Start_Sec, 0
Gui, Add, Text,, End Pos Min:
Gui, Add, Edit, w80 Center R1 Number vEnd_Min
Gui, Add, Text,, End Pos Sec:
Gui, Add, Edit, w80 Center R1 Number vEnd_Sec
GuiControl,, End_Min, 0
GuiControl,, End_Sec, 0
Gui, Add, CheckBox, center vRemove, Remove
Gui, Add, Button, Center w80 gSub, OK
Gui, Show , Center, Poop
Return

Sub:
Gui, Submit
Gui, Destroy ;Start_Min:=Start_Min * 60	;Start_Pos:=Start_Min + Start_Sec	;End_Min:=End_Min * 60	;End_pos:=End_Min + End_Sec
Time_Start=00:%Start_Min%:%Start_Sec%
Time_End=00:%End_Min%:%End_Sec%
if Remove
{
o:=comobjcreate("Shell.Application")
rape=%1%
splitpath,rape,Pdfile,Pddirectory
if errorlevel
	exit
twonker:
od:=o.namespace(Pddirectory)
of:=od.parsename(Pdfile)
turd:=% ((append:=od.getdetailsof(of,27))?27 " - " od.getdetailsof("",27) ": " append "":"")
sleep 75
Output_Duration := RegExReplace(turd, "^.............")
if !Output_Duration
	goto twonker
else {
		FirstHalf=%OutDir%\%OutNameNoExt% - Trimmed first half.%OutExtension%
		SecondHalf=%OutDir%\%OutNameNoExt% - Trimmed 2nd half.%OutExtension%
		RunWait, %comspec% /c ffmpeg -i "%FullPath%" -ss 0:0:0 -to %Time_Start% -c:v copy -c:a copy "%FirstHalf%"
		RunWait, %comspec% /c ffmpeg -i "%FullPath%" -ss %Time_End% -to %Output_Duration% -c:v copy -c:a copy "%SecondHalf%"
		FileAppend , file '%FirstHalf%'`n, %concat%
		FileAppend , file '%SecondHalf%'`n, %concat%
		sleep 1500
		Output_Filename_Full=%OutDir%\%OutNameNoExt% - Trimmed.%OutExtension%
		RunWait, %comspec% /c ffmpeg -f concat -safe 0 -i "%concat%" -c copy "%Output_Filename_Full%"
		FileDelete, %FirstHalf%
		FileDelete, %SecondHalf%
		FileDelete, %concat%
		FileGetTime, Old_D8 , %FullPath%, m
		FileSetTime, Old_D8 , %Output_Filename_Full%, m
		FileRecycle, %FullPath%
		Bugga:
		sleep 500
		if !fileExist(FullPath)
		FileMove, Output_Filename_Full, FullPath
		sleep 100
		InvokeVerb(Output_Filename_Full, "Cut", True)
		}
}
else 
{
	Process_Type:="Extracted", 	Process_Action:="-tO"
Output_Prefix=%OutDir%\%OutNameNoExt% - %Process_Type%
Output_Filename_Full=%Output_Prefix%.%OutExtension%
while FileExist(Output_Filename_Full) { ; Check_Folder
	Multiple_Num := Multiple_Num + 1
	Output_Filename_Full=%Output_Prefix%-%Multiple_Num%.%OutExtension%
	}
RunWait, %comspec% /c ffmpeg -i "%1%" -ss %Time_Start% %Process_Action% %Time_End% -c:v copy -c:a copy "%Output_Filename_Full%"
InvokeVerb(Output_Filename_Full, "Cut", True)
Exit
}
Escape::ExitApp

InvokeVerb(path, menu, validate=True) {
    objShell := ComObjCreate("Shell.Application")
    if InStr(FileExist(path), "D") || InStr(path, "::{") {
        objFolder := objShell.NameSpace(path)   
        objFolderItem := objFolder.Self
    } else {
        SplitPath, path, name, dir
        objFolder := objShell.NameSpace(dir)
        objFolderItem := objFolder.ParseName(name)
		}
    if validate {
        colVerbs := objFolderItem.Verbs   
        loop % colVerbs.Count {
            verb := colVerbs.Item(A_Index - 1)
            retMenu := verb.name
            StringReplace, retMenu, retMenu, &       
            if (retMenu = menu) {
                verb.DoIt
                Return True
            }
        }
		Return False
    } else
        objFolderItem.InvokeVerbEx(Menu)
} 
