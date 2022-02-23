#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include menu_Item_master.ahk
q:: ;set context menu icons to 'restore icon'
poo:="C:\Icon\24\nv.ico"
p_checked_face=false
hBitmap := LoadPicture(poo)
;hBitmap := 2 ;HBMMENU_MBAR_RESTORE := 2
WinGet, hWnd, ID, ahk_class #32768
if !hWnd {
tooltip cunt
	return
}
;WinGet, vPName, ProcessName, % "ahk_id " hWnd
;if !(vPName = "notepad.exe") && !(vPName = "explorer.exe")
;	return
SendMessage, 0x1E1, 0, 0, , ahk_class #32768 ;MN_GETHMENU
if !hMenu := ErrorLevel
	return
WinGet, vPID, PID, % "ahk_id " hWnd
;OpenProcess may not be needed to set an external menu item's icon to HBMMENU_MBAR_RESTORE
if !hProc := DllCall("OpenProcess", UInt,0x1F0FFF, Int,TRUE, UInt,vPID, Ptr)
	return
Loop, % DllCall("GetMenuItemCount", Ptr,hMenu)
{
p_bm_checked:="C:\Icon\20\copy-1.bmp"
hbm_checked := DllCall( "LoadImage"
									, "uint", 0
									, "str", p_bm_checked
									, "uint", 0
									, "int", 24
									, "int", 24
									, "uint",  0x8050  )
	success := DllCall( "SetMenuItemBitmaps"
							, "uint", hWnd
							, "uint", A_Index
							, "uint", 0x400										; MF_BYPOSITION
							, "uint", hbm_checked
							, "uint", hbm_checked )
	vPos := A_Index
	vSize := A_PtrSize=8?80:48
	VarSetCapacity(MENUITEMINFO, vSize, 0)
	NumPut(vSize, MENUITEMINFO, 0, "UInt") ;cbSize
	NumPut(0x88, MENUITEMINFO, 4, "UInt") ;fMask
	NumPut(hbm_checked, MENUITEMINFO, A_PtrSize=8?72:44, "Ptr") ;hBitmap
	DllCall("SetMenuItemInfo", Ptr,hMenu, UInt,vPos, Int,1, Ptr,&MENUITEMINFO)
tooltip twat=%A_Index%

}

DllCall("CloseHandle", Ptr,hProc)
return