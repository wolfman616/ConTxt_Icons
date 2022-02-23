#noEnv ; #warn
sendMode Input
#persistent
#singleinstance force
setWorkingDir %a_scriptDir%

menu, tray, add, Open Script Folder, Open_Script_Location,
menu, tray, add, Open Script Folder, Open_Script_Location,
menu, tray, standard
procarray := []
classarray := []
titarray := []
global Array_ProcList 		:= []
global Array_TitleList 		:= []
global Array_ClassList 	:= []
global TClass, global TTitle, global TProcName, global delim, global delim2, global TitleCount, global ClassCount, global ProcCount, global style, global exstyle, delim := "µ", delim2 := "»"

SysMenu		:= 	"Title (+ & X Conrols) (SysMenu)"
Maxbox 		:= 	"Maximise Button (□)"
MinBox 		:= 	"Minimise Button (_)"
LeftScroll 		:= 	"Left Scroll Orientation"
ClickThru 		:= 	"Click-through"
RightAlign		:= 	"Generic Right-alignment"
RightoLeft		:= 	"Right-to-Left reading"
AppWindow	:= 	"Taskbar Item (not 100%)"
Save 			:= 	"Save window style preferences"
Reset 			:= 	"Reset window style preferences"

stylekey 		:= "HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles"
wintitlekey 		:= stylekey . "\wintitle"
procnamekey := stylekey . "\procname"
classnamekey := stylekey . "\classname"
td := Style . "»" . exStyle . "»" . "µ" . save_new_ProcName . "µ" . save_new_Title . "µ" .  "µ" . save_new_Class

gosub RegRead
return

~g:: ; later to attatch to winevent hook
WinGetActiveTitle, title_1
active := WinExist("A")
titlex := "ahk_id " . active
WinGetClass, class_1 , % titlex
WinGet, OutputVar, ProcessName , % titlex
if FoundPos := InStr(Style_wintitleList2, title_1)
	Loop % titarray.Length()
		if FoundPos := InStr(titarray[A_Index], title_1) {
			MsgBox % titarray[A_Index]		
		}
return


!rButton:: 	; 	Alt & RMB
TargetHandle := "", style:=""
if Dix
	Menu F, DeleteAll
Dix:= true



MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
TargetHandle = ahk_id %OutputVarWin% 	 ; 	TargetHandle := WinExist("A"), 

WinGetTitle, TargetTitle, ahk_id %OutputVarWin%
if !TargetTitle 
return

WinGet, Style, Style, ahk_id %OutputVarWin%
WinGet, ExStyle, ExStyle, ahk_id %OutputVarWin%

MainMenu:
Menu F, 	add, %TargetTitle%, donothing,
Menu F, 	Disable, %TargetTitle%
Menu F,	add , , , 

Menu F, 	add, % sysmenu, toggle_sysmenu
if (Style & 0x00080000)
	Menu F, check, % SysMenu
else	Menu F, uncheck, % SysMenu

Menu F, 	add, % Clickthru, toggle_Clickthru
if (ExStyle & 0x00000001)
	Menu F, check, % Clickthru
else 	Menu F, uncheck, % Clickthru

Menu F, 	add, % AppWindow, toggle_AppWindow
if (ExStyle & 0x00040000)
	Menu F, check, % AppWindow
else 	Menu F, uncheck, % AppWindow
goto Sumenu_items

Submenus:
Menu F, 	add, Frame / & X Controls, 	:S1
Menu F, 	add, Scrollbars, 					:S2
Menu F, 	add, Layout, 						:S3
goto othermenus

Sumenu_items:
Menu S1, 	add, DLG Frame, toggle_DLGFRAME
if (Style & 0x00400000) 
	Menu S1, check, DLG Frame
else Menu S1, uncheck, DLG Frame
	
Menu S1, 	add, THICK Frame, toggle_thickframe
if (Style & 0x00040000) 
	Menu S1, check, THICK Frame,
else Menu S1, uncheck, THICK Frame
	
Menu S1, 	add, Modal Frame, toggle_Modalframe
if (ExStyle & 0x00000001) 
	Menu S1, check, Modal Frame,
else Menu S1, uncheck, Modal Frame
	
Menu S1, 	add, Static edge, toggle_staticedge
if (ExStyle & 0x00020000) 
	Menu S1, check, Static edge,
else Menu S1, uncheck, Static edge

Menu S1, 	add, %Maxbox%, toggle_Maxbox
if (Style & 0x00010000) 
	Menu S1, check, % Maxbox
else Menu S1,uncheck, % Maxbox

Menu S1, 	add, %MinBox%, toggle_MinBox
if (Style & 0x00020000) 
	Menu S1, check, % MinBox
else Menu S1, uncheck, % MinBox

Menu S2, 	add, HScroll, toggle_hscroll
if (Style & 0x00100000)
	Menu S2, check, HScroll 
else Menu S2, uncheck, HScroll 

Menu S2, 	add, VScroll, toggle_hscroll
if (Style & 0x00200000)
	Menu S2, check, VScroll 
else Menu S2, uncheck, VScroll 

Menu S2, 	add, %LeftScroll%, toggle_LeftScroll
if (ExStyle & 0x00004000)
	Menu S2, check, % LeftScroll 
else Menu S2, uncheck, % LeftScroll 
	
Menu S3, 	add, %RightAlign%, toggle_RightAlign
if (ExStyle & 0x00001000)
	Menu S3, check, % RightAlign 
else Menu S3, uncheck, % RightAlign 
	
Menu S3, 	add, %RightoLeft%, toggle_RightoLeft
if (ExStyle & 0x00002000)
	Menu S3, check, % RightoLeft 
else Menu S3, uncheck, % RightoLeft 
gosub Submenus

Menu F, Show
return

othermenus: ; below submenus
Menu F, 	add, % Save, Savegui
return
;-~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_
donothing:
return

toggle_sysmenu:
WinSet, Style, ^0x00080000, ahk_id %OutputVarWin%
goto ResetMenu

toggle_DLGFRAME:
WinSet, Style, ^0x00400000, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_thickframe:
WinSet, Style, ^0x00040000, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_modalframe:
WinSet, ExStyle, ^0x00000001, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_border:
WinSet, Style, ^0x00040000, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_raisededge:
WinSet, ExStyle, ^0x00000100, ahk_id %OutputVarWin%
goto ResetMenu

toggle_sunkenedge:
WinSet, ExStyle, ^0x00000100, ahk_id %OutputVarWin%
goto ResetMenu

toggle_staticedge:
WinSet, ExStyle, ^0x00020000, ahk_id %OutputVarWin%
goto ResetMenu

toggle_3dedge:
WinSet, ExStyle, ^0x00020000, ahk_id %OutputVarWin%
goto ResetMenu

toggle_MinBox:
WinSet, Style, ^0x00020000, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_Maxbox:
WinSet, Style, ^0x00010000, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_hscroll:
WinSet, Style, ^0x00100000, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_vscroll:
WinSet, Style, ^0x00200000, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_LeftScroll:
WinSet, ExStyle, ^0x00004000, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_Clickthru:
WinSet, ExStyle, ^0x00000020, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_RightAlign:
WinSet, ExStyle, ^0x00001000, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_RightoLeft:
WinSet, ExStyle, ^0x00002000, ahk_id %OutputVarWin% 
goto ResetMenu

toggle_AppWindow:
WinSet, ExStyle, ^0x00040000, ahk_id %OutputVarWin% 
goto ResetMenu

SAVEGUI:
winGet save_new_ProcName, ProcessName, ahk_id %OutputVarWin%
winGetTitle save_new_Title, ahk_id %OutputVarWin%
winGetClass save_new_Class, ahk_id %OutputVarWin%
WinGet, Style, Style, ahk_id %OutputVarWin%
WinGet, ExStyle, ExStyle, ahk_id %OutputVarWin%
if !Style or !ExStyle
	msgbox error
gui, SaveGuI:new , , SAVE WINDOW STYLES
gui +hwndSaveGuI_hWnd
gui, SaveGuI:add, checkbox, vTProcName ,Process %save_new_ProcName%
gui, SaveGuI:add, checkbox, vTTitle ,WindowTitle %save_new_Title%
gui, SaveGuI:add, checkbox, vTClass ,save Class %save_new_Class%
gui, SaveGuI:add, button, default gSaveGUISubmit w80, Save (Enter)
gui, SaveGuI:add, button, w80 gSaveGUIDestroy, Cancel (Esc)
gui, show, center, SAVE WINDOW STYLES
OnMessage(0x200, "Help")
return

SaveGUISubmit: 	; keyname will contain unique information as a search key and allow for other combinations such as different classnamed windows for the same target app without duplication
gui, SaveGuI:Submit

PushNewSave: 	
if TProcName {
regWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles\procname, 	% Style . "»" . exStyle . "»" . "µ" . save_new_ProcName . "µ" . save_new_Title . "µ" . save_new_Class, % save_new_ProcName
} 
if TTitle {
regWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles\wintitle, 		% Style . "»" . exStyle . "»" . "µ" . save_new_ProcName . "µ" . save_new_Title . "µ" . save_new_Class, % save_new_Title
} 
if TClass {
regWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles\classname, 	% Style . "»" . exStyle . "»" . "µ" . save_new_ProcName . "µ" . save_new_Title . "µ" . save_new_Class, % save_new_Class
}
return

SaveGUIDestroy:
gui, SaveGuI:destroy
TProcName := "", TTitle := "", TClass := ""
return

ResetMenu:
Menu F, DeleteAll
return

RegRead:
Loop, Reg, % wintitlekey
{
    if (A_LoopRegType = "REG_SZ") {
        value1 := A_LoopRegKey . "\" . A_LoopRegSubKey
        regRead, value2, %value1%, %A_LoopRegName%
		Style_wintitleList2 := Style_wintitleList2 . value2 . "‡"	
		FoundPos := RegExMatch(A_LoopRegName, "^0.{9}" , ret_style, p0s := 1)
		FoundPos := RegExMatch(A_LoopRegName, "(\»)\K(.{10})" , ret_exstyle, p0s := 1)
		classarray.push(ret_style . "»" . ret_exstyle . "»" . "µ" . value2)
		}
}
Loop, Reg, % procnamekey
{
    if (A_LoopRegType = "REG_SZ") {
        value1 := A_LoopRegKey . "\" . A_LoopRegSubKey
        regRead, value2, %value1%, %A_LoopRegName%
		Style_procnameList2 := Style_procnameList2 . value2 . "‡"	
		FoundPos := RegExMatch(A_LoopRegName, "^0.{9}" , ret_style, p0s := 1)
		FoundPos := RegExMatch(A_LoopRegName, "(\»)\K(.{10})" , ret_exstyle, p0s := 1)
		classarray.push(ret_style . "»" . ret_exstyle . "»" . "µ" . value2)
		}
}
Loop, Reg, % classnamekey
{
    if (A_LoopRegType = "REG_SZ") {
        value1 := A_LoopRegKey . "\" . A_LoopRegSubKey
        regRead, value2, %value1%, %A_LoopRegName%
		Style_ClassnameList2 := Style_ClassnameList2 . value2 . "‡"	
		FoundPos := RegExMatch(A_LoopRegName, "^0.{9}" , ret_style, p0s := 1)
		FoundPos := RegExMatch(A_LoopRegName, "(\»)\K(.{10})" , ret_exstyle, p0s := 1)
		classarray.push(ret_style . "»" . ret_exstyle . "»" . "µ" . value2)
		msgbox % classarrayclassarray[1]
	}
}
return

if InStr(Style_ClassnameList2, class)  {
msgbox
	for index, value in Array_ClassList
		if InStr(value, class) {
			if FoundPos 	:= RegExMatch(value, "(\µ)\K(.*)" , ret_classname, p0s := 1) {
				FoundPos := RegExMatch(value, "^0.{9}" , ret_style, p0s := 1)
				FoundPos := RegExMatch(value, "(\»)\K(.{10})" , ret_exstyle, p0s := 1)
				WinSet, Style, 		%ret_style%, 		ahk_id %OutputVarWin% 
				WinSet, ExStyle, 	%ret_exstyle%, 	ahk_id %OutputVarWin% 
				msgbox %class% detected`n%ret_style%`n%ret_exstyle%
			} else msgbox error
		}
		}

Open_Script_Location: ;run %a_scriptDir%
toolTip %a_scriptFullPath%
E=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %E%,, hide
return

/* 	
ParsingArrayTolLst:
for index, value in Array_ClassList
	Style_ClassList := Style_ClassList . delim . value
for index, value in Array_ProcList
	style_ProcessList := style_ProcessList . delim . value
for index, value in Array_TitleList
	style_TitleList := style_TitleList . delim . value
 */
 
/* 
listParse:
loop, Parse, style_ProcessList, %delim% 
{
	Array_ProcList[%A_Index%] := A_LoopField
	ProcCount := A_Index
}
loop, Parse, Style_ClassList, %delim%
{
	Array_ClassList[%A_Index%] := A_LoopField
	ClassCount := A_Index
}
loop, Parse, style_TitleList, %delim%
{
	TitleCount := A_Index
	Array_TitleList[%A_Index%] := A_LoopField
}
return
 */
 
 /* 
RegRead:
regRead, style_ClassList, HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles, Style_ClassList
regRead, style_ProcessList, HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles, style_ProcessList
regRead, style_TitleList, HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles, style_TitleList

RegWrite:
regWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles, Style_ClassList, %Style_ClassList%
regWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles, style_ProcessList, %style_ProcessList%
regWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\_Mouse2Drag\Styles, style_TitleList, %style_TitleList%
 */