	; 	Imagemagick command line convert bmp to bmp5 format
#NoEnv ; #Persistent  
#SingleInstance Force
File=%1% ; Passed Filename as argument from context menu
SplitPath,File,FileName,Dir,Extension,NameNoExt		
Menu, tray, noStandard
Menu, tray, add, Open script folder, Open_script_folder,
Menu, tray, standard
menu, tray, tip , bmp5 conversion for:`n%FileName%
menu, tray, icon, C:\Script\AHK\z_ConTxt\DNA.ico

S:=1100 ; S sleep millisecs for handling explorer launch delay
appendage:=" converted"
NF=%Dir%\%NameNoExt%%Appendage%.%Extension%
Global NewFile := NF
FileGetShortcut, %File% , OutTarget, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState
if errorlevel {
	SetWorkingDir %Dir%
	MsgBox,4,, Replace Original File?
	IfMsgBox Yes 	
	{		
		if fileexist(NewFile)
		{
			msgbox, bmp5 Already Exists
			exit
	  } else {
			run %COMSPEC% /C magick convert "%File%" bmp5:"%NewFile%",,, hide
			sleep % S

			confirm:		
			if fileexist(NewFile)
				fileRecycle %File%
			else {
				sleep % S
				goto confirm
			}

			confirm2:
			if !(fileexist(File)) {
				filemove %NewFile%, %File%
				
			} else {
				sleep 500
				goto confirm2
			}

			sleep % S
			if fileexist(File)
				InvokeVerb(File, "Cut", True)
			else {
				sleep % S
				goto confirm2
			}
			trayTip, bmp 2 bmp, bmp5 replaced & in clipboard.
		}

	} else {
		IfMsgBox No
		run %COMSPEC% /C magick convert "%File%" bmp5:"%NewFile%",,, hide		
		sleep % S
		confirm3:
		if Atts:=fileexist(NewFile) {
			InvokeVerb(NewFile, "Cut", True)
		} else {
			tooltip son of biiitch `ncan not find %NewFile%`n Attributes = " %Atts% "
			sleep 1200
			goto confirm3
		}
		msgbox, 0, %FileName% to bmp5, %FileName%`nConverted to bmp5 & in clipboard.`nThis message will self destruct in 3 seconds,3
		exit
	}
	return
}
return


Open_script_folder:	
runwait %COMSPEC% /C explorer.exe /select`, "%a_scriptFullPath%",, hide
sleep %S%
sendInput {F5}
return

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
                return True
            }
        }
		return False
    } else
        objFolderItem.InvokeVerbEx(Menu)
} 
sleep, 5000
exitApp
