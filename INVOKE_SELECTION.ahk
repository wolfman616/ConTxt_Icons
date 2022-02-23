pic_2_icon.ico  ; Recommended for performance and compatibility with future AutoHotkey 
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#Persistent
; Get selected files in explorer and more:
; http://www.autohotkey.com/board/topic/60985-get-paths-of-selected-items-in-an-explorer-window/
SelectByRegEx()
return

SelectByRegEx()
{
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
