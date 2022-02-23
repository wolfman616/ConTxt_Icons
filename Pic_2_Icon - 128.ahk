;#persistent ;#singleinstance force ;menu, tray, icon, pic_2_icon.ico ;#NoTrayIcon
#NoEnv
SetWorkingDir %A_ScriptDir% 	
RESIZE:="256,128,96,64,48,32,24,20,16"
Dest_Dir:="C:\Icon\256"
Temp_Dir=%A_ScriptDir%

OnExit, FoaD
splitpath 1, inFileName, inDir, inExtension, inNameNoExt, inDrive
TEMP_FILE=TEMP_FILE.%inExtension%
filecopy, %1%, %Temp_Dir%\%TEMP_FILE%
TEMP_FILE=%Temp_Dir%\%TEMP_FILE%
out2=%inNameNoExt%.ico
out3=TEMP_FILE.png
out4=%Temp_Dir%\%inNameNoExt%.ico
out5="%out4%"
NIGSSSS="%Dest_Dir%\%inNameNoExt%.ico"
PNG_Create:
Runwait, %comspec% /c convert %out3% -resize "256x256^" -gravity center -crop 256x256+0+0 +repage -alpha Set -background none -depth 8  %out3%

PNG_eXist:
loop {
	if FileExist(out3) {
		RunWait, %comspec% /c convert %out3% -define icon:auto-resize=%resize% %NIGSSSS%
		break
	} else {
		sleep 250
		goto PNG_eXist
		}
	}
loop 5 
	{
	if FileExist(Out4) {
		FileMove, Out4, Dest_Dir
		break
		}
	else
		sleep 20
	}
Dest_File=%Dest_Dir%\%inNameNoExt%.ico
loop 2 	
	{
	if InvokeVerb(Dest_File, "Cut") {
		msgbox %errorlevel% error %A_Index%
		break
		}
	Clipboard:=Dest_File
	}
ExitApp

FoaD:
if FileExist(TEMP_FILE)	
	FileDelete %TEMP_FILE%
Else sleep 300
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

