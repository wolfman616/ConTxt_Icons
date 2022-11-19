/* 

METHOD Explorer_GetSelection
	Context menu
	[HKEY_CLASSES_ROOT\ImageGlass.AssocFile.PNG\shell\png2jpg]
	"muiverb"="CONVERT 2 JPG"
	[HKEY_CLASSES_ROOT\ImageGlass.AssocFile.PNG\shell\png2jpg\command]
	@="\"C:\\Program Files\\AHK\\AutoHotkey.exe\" \"C:\\\\script\\\\AHK\\\\z_ConTxt\\\\IMAGE2JPG.ahk\" \"%v\""

 */
#SingleInstance force
#NoTrayIcon
;#Persistent
/* 
fil3p4th=%1%
fil3Nam3:= (RegExReplace(fil3p4th, "^.+\\"))
sleep 100
n4me_MINUS_extensi0n:=  (RegExReplace(fil3Nam3, "....$"),"")   	; didnt know about splitpath LOL
RegExMatch(fil3p4th, "^.+\\", l0cation)
IGIVEUP="%fil3p4th%""
loca="%l0cation%%n4me_MINUS_extensi0n%.jpg"
 */
SplitPath, 1 , FileName, Dir, Extension, NameNoExt
inPath="%1%"
loca="%dir%\%NameNoExt%.jpg"
out_path=%dir%\%NameNoExt%Converted.jpg
Run, %comspec% /c magick convert %inPath% -format jpg -quality 99 %loca%,, hide

/*  

			crap
		;tooltip "magick convert %IGIVEUP% -format jpg %l0cation%%n4me_MINUS_extensi0n%.jpg"
		;ToolTip, %n4me_MINUS_extensi0n% Converted to a JPEG
		;clipboard=%l0cation%%n4me_MINUS_extensi0n%.jpg
		; magic convert C:\Users\ninj\Desktop\New folder\Clipboarder.2020.06.01.png -format jpg  C:\Users\ninj\Desktop\New folder\fuckingfil3p4th.jpg
		Clipboard := Explorer_GetSelection()
----------=================-----------=================-------------================------------

Buttons:
OK (that is, only an OK button is displayed) 	0 	0x0
OK/Cancel 	1 	0x1
Abort/Retry/Ignore 	2 	0x2
Yes/No/Cancel 	3 	0x3
Yes/No 	4 	0x4
Retry/Cancel 	5 	0x5
Cancel/Try Again/Continue 	6 	0x6
Group #2: Icon

Display icon:
Icon Hand (stop/error) 	16 	0x10
Icon Question 	32 	0x20
Icon Exclamation 	48 	0x30
Icon Asterisk (info) 	64 	0x40

Default Choice:
Makes the 2nd button the default 	256 	0x100
Makes the 3rd button the default 	512 	0x200
Makes the 4th button the default
(requires the Help button to be present) 	768 	0x300

Behaviour:
System Modal (always on top) 	4096 	0x1000
Task Modal 	8192 	0x2000
Always-on-top (style WS_EX_TOPMOST)
(like System Modal but omits title bar icon) 	262144 	0x40000

Other values:
Adds a Help button (see remarks below) 	16384 	0x4000
Make the text right-justified 	524288 	0x80000
Right-to-left reading order for Hebrew/Arabic 	1048576 	0x100000

 */
MsgBox,4,, Delete Original File?
IfMsgBox Yes
{
out_path2=%dir%\%NameNoExt%.jpg
    FileRecycle %1%
filemove out_path, out_path2
	TrayTip, Image 2 JPG, JPG created & in Clipboard.`nOriginal ReCycled
} else {
	traytip,Image 2 JPG, JPG created & in Clipboard.`
}
send {f5}
InvokeVerb("out_path", "cut")
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
    Return
sleep 100

exit

Explorer_GetSelection(hwnd="")  {
    WinGet, process, processName, % "ahk_id" hwnd := hwnd? hwnd:WinExist("A")
    WinGetClass class, ahk_id %hwnd%
    if (process = "explorer.exe")
        if (class ~= "Progman|WorkerW") {
            ControlGet, files, List, Selected Col1, SysListView321, ahk_class %class%
            Loop, Parse, files, `n, `r
                ToReturn .= A_Desktop "\" A_LoopField "`n"
        } else if (class ~= "(Cabinet|Explore)WClass") {
            for window in ComObjCreate("Shell.Application").Windows
			try
				{
				if (window.hwnd==hwnd)
					sel := window.Document.SelectedItems
				}
            catch
				return
	for item in sel
		ToReturn .= item.path "`n"
        }
    return Trim(ToReturn,"`n")
}