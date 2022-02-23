	;	Spleeter context menu for shell
	;	requires conda and spleeter
#noEnv
#singleInstance Force
setWorkingDir %a_scriptDir%
InputFile=%1% 		; 	"%l" see below
component=%2% 	; 	accompaniment or vocals called as 2nd argument ie; 
	;  	autohotkey.exe "C:\Script\AHK\z_ConTxt\SPLEET.ahk" "%l" "vocals" 
	;	Found in:
	; 	Computer\HKEY_CLASSES_ROOT\WMP11.AssocFile.MP3\shell\Audio_proc\shell\Spleet_Vox\command
splitPath,1,infile,indir,inext,NameNoExt
menu, tray, icon, DNA.ico
menu, tray, tip , Spleeter %component% extraction for:`n%infile%
menu, tray, add, Open script dir, Open_Script_Location,
menu, tray, standard
if component = vocals
	dildo = Vox
else if component = accompaniment
	dildo = Inst
else msgbox argument error %component% error

; Main 
run, conda run spleeter separate -c mp3 -b 192k "%InputFile%",,hidden
winwaitactive, ahk_exe conda.exe
winhide, ahk_exe conda.exe
Spleet_Result=C:\Users\ninj\AppData\Local\Temp\separated_audio\%NameNoExt%\%component%.mp3	
MsgBox , 1, spleeter %dildo% separation , separation in progress`nPlease allow a few moments..., 5

Wait_loop:	
loop 25 {
		sleep 2800
	if fileexist(Spleet_Result) 
		break
}

if !fileexist(Spleet_Result) {
	msgbox ,0,spleeter %dildo% separation, %Spleet_Result%`ndoes not exist
	sleep 1000
	goto Wait_loop

} else {
	Target=%indir%\%NameNoExt% - %dildo%.mp3
	fileMove %Spleet_Result%, %Target%
	if !errorlevel {
		InvokeVerb(Target, "cut", validate=True) 		
			msgbox, 0, %NameNoExt% %dildo%, %NameNoExt% %dildo%`n Separation complete`, encoded and clipboarded`nThis message will self destruct in 3 seconds,3
		sleep 5000
		return

	} else
		msgbox argument error`ncomponent %component% error`n%Target% error 	; 	ffmpeg -i "C:\Users\ninj\AppData\Local\Temp\separated_audio\01 the horses mouth\vocals.mp3" -vn -ar 44100 -ac 2 -b:a 192k output.mp3
return
}

InvokeVerb(path, menu, validate=True) {
    objShell := ComObjCreate("Shell.Application")
    if InStr(FileExist(path), "D") || InStr(path, "::{") {
        objFolder := objShell.NameSpace(path)   
        objFolderItem := objFolder.Self
    } else {
        splitPath, path, name, dir
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

Open_Script_Location: 
toolTip %a_scriptDir% 	; 	run %a_scriptDir%
E=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %E%,, hide
return