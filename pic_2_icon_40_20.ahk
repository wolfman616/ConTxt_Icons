SetWorkingDir %a_scriptdir%
#persistent
;menu, tray, icon, pic2icon.ico
#singleinstance force
RESIZE=48,24
Input_File="%1%"

splitpath 1, inFileName, inDir, inExtension, inNameNoExt, inDrive
cunt=cunt.%inExtension%
filecopy, %1%, %indir%\%cunt%
outdir=%indir%\
Input_File=%indir%\%cunt%
out1=%inDir%\cunt.png 
out2=%inDir%\%inNameNoExt%.ico
out3=%inDir%\cunt.png
out4=%inDir%\%inNameNoExt%.ico
PNG_Create:
Runwait, %comspec% /c convert %Input_File% -resize "40x40^" -gravity center -crop 40x40+0+0 +repage -alpha Set -background none -depth 8  %out1%
 
PNG_eXist:
try 
	{
	if FileExist(out1)
	RunWait, %comspec% /c convert %out3% -define icon:auto-resize=%resize% %out4%
	}
catch
	{
	sleep 50
	gosub PNG_eXist
	}
filedelete %indir%\%cunt%

if InvokeVerb(out2, "Cut")
    traytip, File, Link Source Cut

InvokeVerb(path, menu, validate=True) {
	;by A_Samurai
	;v 1.0.1 http://sites.google.com/site/ahkref/custom-functions/invokeverb
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
traytip, image 2 Ic0n, created icon and clipboarded
exitapp