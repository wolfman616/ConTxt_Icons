pic_2_icon.ico  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#persistent
#singleinstance force
GroupAdd, FileListers, ahk_class CabinetWClass
GroupAdd, FileListers, ahk_class WorkerW
GroupAdd, FileListers, ahk_class #32770, ShellView

    Clipboard := JoinArrayContents(Explorer_GetSelected())
    Return

; Get selected files in explorer and more:
; http://www.autohotkey.com/board/topic/60985-get-paths-of-selected-items-in-an-explorer-window/
#0::
 CopySelectedFileContents() {
        files := Explorer_GetSelected()
        content := ""
        for i, file in files {
            FileRead, text, %file%
            if i > 1
                content := content . "`n`n"
            content := content . text
        }
        Clipboard := content
    }


#IfWinActive ahk_group FileListers
^r::
SelectByRegEx() {
    static selectionPattern := ""
    WinGetPos, wx, wy
    ControlGetPos, cx, cy, cw, , DirectUIHWND3
    x := wx + cx + cw/2 - 200
    y := wy + cy
    InputBox, selectionPattern, Select by regex
        , Enter regex pattern to select files that CONTAIN it (Empty to select all)
        , , 400, 150, %x%, %y%, , , %selectionPattern%
    if ErrorLevel
        Return
    for window in ComObjCreate("Shell.Application").Windows
        if WinActive("ahk_id " . window.hwnd) {
            pattern := "S)" . selectionPattern
            items := window.document.Folder.Items
            total := items.Count()
            i := 0
            showProgress := total > 160
            if (showProgress)
                Progress, b w200, , Matching...
            for item in items {
                match := RegExMatch(item.Name, pattern) ? 17 : 0
                window.document.SelectItem(item, match)
                if (showProgress) {
                    i := i + 100
                    Progress, % i / total
                }
            }
            Break
        }
    Progress, Off
}

JoinArrayContents(arr, delimiter="`n") {
    content := ""
    for index, item in arr {
        if index > 1
            content := content . delimiter
        content := content . item
    }
    return content
}

active_hwnd := WinActive("ahk_class CabinetWClass")
If (active_hwnd) {
    for window in ComObjCreate("Shell.Application").Windows
        If (active_hwnd == window.hwnd) {
            parent := uriDecode(StrReplace(window.LocationURL, "file:///", "", , 1))
            ShowGui()
        }
}

ShowGui() {
    global active_hwnd, parent, SourcePattern, TargetPattern, WindowListView
    Gui, Font, s10 q5, Segoe UI
    Gui, Margin, 6, 6
    Gui, +Owner%active_hwnd%
    Gui, Add, Text, , Search pattern:
    Gui, Add, Edit, r1 w300 vSourcePattern gInputChanged -WantReturn X+6 Section
    Gui, Add, Text, X+6, Full regex is supported
    Gui, Add, Text, XM, Replacement:
    Gui, Add, Edit, r1 w300 vTargetPattern gInputChanged -WantReturn XS YP
    Gui, Add, Text, X+6, Use $1, $2, ${10}, ${named}, $U1, $U{10}, $L2, $T0 etc.
    Gui, Add, Button, Default gDoRename XM w80, Apply
    Gui, Add, Button, gShowHelp X+6 w80, Help
    Gui, Add, ListView, Grid r12 w800 vWindowListView XM, Replacements|Current name|Renamed to

    imList := IL_Create(2)
    LV_SetImageList(imList)
    IL_Add(imList, "check.png", 0xFFFFFF, 1)
    IL_Add(imList, "error.png", 0xFFFFFF, 1)
    ; IL_Add(imList, "shell32.dll", 145)
    ; IL_Add(imList, "shell32.dll", 234)

    Gui, Show, , Rename with Regex: %parent%
}

InputChanged() {
    global parent, SourcePattern, TargetPattern
    GuiControlGet, SourcePattern
    GuiControlGet, TargetPattern
    LV_Delete()
    Loop, Files, %parent%\*, FD
    {
        toName := RegExReplace(A_LoopFileName, SourcePattern, TargetPattern, count)
        icon := 1
        If (A_LoopFileName == toName)
            icon := 3
        Else if (FileExist(parent . "/" . toName))
            icon := 2
        LV_Add("Icon" . icon, count, A_LoopFileName, toName)
    }
    LV_ModifyCol()
}

DoRename() {
    global parent, SourcePattern, TargetPattern
    Gui, Submit

    If (SourcePattern != "")
        Loop %parent%\* {
            toName := RegExReplace(A_LoopFileName, SourcePattern, TargetPattern)
            FileMove, %parent%\%A_LoopFileName%, %parent%\%toName%
        }

    GuiClose()
}

GuiEscape() {
    GuiClose()
}

GuiClose() {
    ExitApp
}

uriDecode(str) {
    Loop
        If RegExMatch(str, "i)(?<=%)[\da-f]{1,2}", hex)
            StringReplace, str, str, `%%hex%, % Chr("0x" . hex), All
        Else Break
    Return, str
}

ShowHelp() {
    help=
    (
## Pattern:

The pattern to search for, which is a Perl-compatible regular expression (PCRE). The pattern's options (if any) must be included at the beginning of the string followed by a close-parenthesis. For example, the pattern "i)abc.*123" would turn on the case-insensitive option and search for "abc", followed by zero or more occurrences of any character, followed by "123". If there are no options, the ")" is optional; for example, ")abc" is equivalent to "abc".

## Replacement:

The string to be substituted for each match, which is plain text (not a regular expression). It may include backreferences like $1, which brings in the substring from Haystack that matched the first subpattern. The simplest backreferences are $0 through $9, where $0 is the substring that matched the entire pattern, $1 is the substring that matched the first subpattern, $2 is the second, and so on. For backreferences above 9 (and optionally those below 9), enclose the number in braces; e.g. ${10}, ${11}, and so on. For named subpatterns, enclose the name in braces; e.g. ${SubpatternName}. To specify a literal $, use $$ (this is the only character that needs such special treatment; backslashes are never needed to escape anything).

To convert the case of a subpattern, follow the $ with one of the following characters: U or u (uppercase), L or l (lowercase), T or t (title case, in which the first letter of each word is capitalized but all others are made lowercase). For example, both $U1 and $U{1} transcribe an uppercase version of the first subpattern.

Nonexistent backreferences and those that did not match anything in Haystack -- such as one of the subpatterns in "(abc)|(xyz)" -- are transcribed as empty strings.
)
MsgBox, %help%
}

	path := Explorer_GetPath()
	all := Explorer_GetAll()
	sel := Explorer_GetSelected()
	MsgBox % path
	MsgBox % all
	MsgBox % sel

return 

Explorer_GetPath(hwnd="")
{
	if !(window := Explorer_GetWindow(hwnd))
		return ErrorLevel := "ERROR"
	if (window="desktop")
		return A_Desktop
	path := window.LocationURL
	path := RegExReplace(path, "ftp://.*@","ftp://")
	StringReplace, path, path, file:///
	StringReplace, path, path, /, \, All 
	
	; thanks to polyethene
	Loop
		If RegExMatch(path, "i)(?<=%)[\da-f]{1,2}", hex)
			StringReplace, path, path, `%%hex%, % Chr("0x" . hex), All
		Else Break
	return path
}
Explorer_GetAll(hwnd="")
{
	return Explorer_Get(hwnd)
}
Explorer_GetSelected(hwnd="")
{
	return Explorer_Get(hwnd,true)
}

Explorer_GetWindow(hwnd="")
{
	; thanks to jethrow for some pointers here
    WinGet, process, processName, % "ahk_id" hwnd := hwnd? hwnd:WinExist("A")
    WinGetClass class, ahk_id %hwnd%
	
	if (process!="explorer.exe")
		return
	if (class ~= "(Cabinet|Explore)WClass")
	{
		for window in ComObjCreate("Shell.Application").Windows
			if (window.hwnd==hwnd)
				return window
	}
	else if (class ~= "Progman|WorkerW") 
		return "desktop" ; desktop found
}
Explorer_Get(hwnd="",selection=false)
{
	if !(window := Explorer_GetWindow(hwnd))
		return ErrorLevel := "ERROR"
	if (window="desktop")
	{
		ControlGet, hwWindow, HWND,, SysListView321, ahk_class Progman
		if !hwWindow ; #D mode
			ControlGet, hwWindow, HWND,, SysListView321, A
		ControlGet, files, List, % ( selection ? "Selected":"") "Col1",,ahk_id %hwWindow%
		base := SubStr(A_Desktop,0,1)=="\" ? SubStr(A_Desktop,1,-1) : A_Desktop
		Loop, Parse, files, `n, `r
		{
			path := base "\" A_LoopField
			IfExist %path% ; ignore special icons like Computer (at least for now)
				ret .= path "`n"
		}
	}
	else
	{
		if selection
			collection := window.document.SelectedItems
		else
			collection := window.document.Folder.Items
		for item in collection
			ret .= item.path "`n"
	}
	return Trim(ret,"`n")
}