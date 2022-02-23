#NoEnv 
#Persistent
#SingleInstance FORCE
TempPath:="c:\temp\0output.mp4"
FullPath=%1%
SplitPath, FullPath, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
SetWorkingDir %OutDir% 
RunWait, %comspec% /c FFMpeg -i %OutFileName% -c copy -metadata:s:v:0 rotate=0 %TempPath% 
try { if TempPath {
	FileGetTime, Old_D8 , % FullPath, M
	FileDelete, % FullPath
	FileMove, % TempPath, % FullPath
	FileSetTime, Old_D8 , % TempPath, M ;
;=>Send window message torefresh
	}
}
catch {
	sleep 100
}
;InvokeVerb(FullPath, "Cut", True)
Exit

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
