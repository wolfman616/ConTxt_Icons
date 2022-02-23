Temp_Loc:="C:\OUT\output\ICON256"
SetWorkingDir %Temp_Loc%
Temp_Loc:="C:\OUT\output\ICON256\"
#persistent
#singleinstance force
;menu, tray, icon, pic_2_icon.ico   128,96,80
RESIZE=256,64,48,40,32,24,20,16
splitpath 1, inFileName, inDir, inExtension, inNameNoExt, inDrive
outdir=%Temp_Loc%
DUMMY=DUMMY.%inExtension%
filecopy, %1%, %Temp_Loc%%DUMMY%
Input_File=%Temp_Loc%\%DUMMY%
out1=%Temp_Loc%\DUMMY.png 
out2=%inNameNoExt%.ico
out3=DUMMY.png
out4=%Temp_Loc%\%inNameNoExt%.ico
out5="%out4%"

PNG_Create:
Runwait, %comspec% /c convert %out3% -resize "256x256^" -gravity center -crop 256x256+0+0 +repage -alpha Set -background none -depth 8  %out3%,,HIDE
PNG_eXist:
try {
	if FileExist(out3)
		RunWait, %comspec% /c convert %out3% -define icon:auto-resize=%resize% %out5%,,HIDE
	} catch {
	sleep 50
	gosub PNG_eXist
}
filedelete %out1%
;InvokeVerb(Out4, "Cut")
clipboard:=out4
exitapp
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
TrayTip, image 2 Ic0n, created icon and clipboarded
exitapp

