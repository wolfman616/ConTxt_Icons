#persistent ;#singleinstance force ;menu, tray, icon, pic_2_icon.ico ;#NoTrayIcon
#NoEnv
SetWorkingDir %A_ScriptDir% 	
Temp_Dir=%A_ScriptDir%
fback=%Temp_Dir%\dir_back.png
ffront=%Temp_Dir%\dir_front.png
Dest_Dir := "C:\Icon\256"
RESIZE := "256,128,96,64,48,32,24,20,16", Folder_MULTIPLE := 0

OnExit, TidyUp
splitpath 1, inFileName, inDir, inExtension, inNameNoExt, inDrive
TEMP_FILE1=TEMP_FILE1.%inExtension%
filecopy, %1%, %Temp_Dir%\%TEMP_FILE1%
TEMP_FILE=TEMP_FILE.%inExtension%
TEMP_FILE1=%Temp_Dir%\%TEMP_FILE1%
out1=%TEMP_FILE1% 

temp1_eXist:
if (FileExist(TEMP_FILE1)) {
	Runwait, %comspec% /c convert %fback% %TEMP_FILE1% -compose over -composite %ffront% -compose over -composite %TEMP_FILE%,, Hide
} else {		sleep 250
	GoTo temp1_eXist
}

Temp_eXist:
if (FileExist(TEMP_FILE)) {
	1=%TEMP_FILE%
} else {
	sleep 250
	GoTo Temp_eXist
}

splitpath 1, inFileName, inDir, inExtension, , 
TEMP_FILE=TEMP_FILE.%inExtension%
filecopy, %1%, %Temp_Dir%\%TEMP_FILE%
TEMP_FILE=%Temp_Dir%\%TEMP_FILE%
out2=%inNameNoExt%.ico
out3=TEMP_FILE.png
out4=%Temp_Dir%\%inNameNoExt%.ico
out5="%out4%"
Dest_File=%Dest_Dir%\%inNameNoExt%.ico
Dests="%Dest_File%"

PNG_Create:
Runwait, %comspec% /c convert %out3% -resize "256x256^" -gravity center -crop 256x256+0+0 +repage -alpha Set -background none -depth 8 %out3%,, Hide

PNG_eXist:
if (FileExist(out3)) {
	RunWait, %comspec% /c convert %out3% -define icon:auto-resize=%resize% %Out4%,, Hide
} else {
	sleep 250
	GoTo PNG_eXist
}

Dest_EXIST:
if (FileExist(Out4)) {
	while (FileExist(Dest_File)) {
		Folder_MULTIPLE := Folder_MULTIPLE + 1
		Dest_File=%Dest_Dir%\%inNameNoExt%-%Folder_MULTIPLE%.ico 
		}
	FileMove, %Out4%, %Dest_File%
} else {
	sleep 250
	GoTo Dest_EXIST
}

Cutfile:
if (FileExist(Dest_File)) {
	InvokeVerb(Dest_File, "Cut") 
} else {
	msgbox, cutpaste error %Dest_File%
	sleep 250
	GoTo Cutfile
}

CutPath:
Clipboard:=Dest_File
Exit

TidyUp:
if FileExist(TEMP_FILE)	
	FileDelete %TEMP_FILE%
if FileExist(TEMP_FILE1)	
	FileDelete %TEMP_FILE1%
ExitApp
 
InvokeVerb(path, menu) {
	objShell := ComObjCreate("Shell.Application")
	if InStr(FileExist(path), "D") || InStr(path, "::{") {
		objFolder := objShell.NameSpace(path)   
		objFolderItem := objFolder.Self
		} else {
		SplitPath, path, name, dir
		objFolder := objShell.NameSpace(dir)
		objFolderItem := objFolder.ParseName(name)
		}
	 objFolderItem.InvokeVerbEx(Menu)
	}

