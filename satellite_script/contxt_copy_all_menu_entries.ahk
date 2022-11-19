^q:: ;Write out menu entries
WinGet, hWnd, ID, ahk_class #32768
if !hWnd
	return
SendMessage, 0x1E1, 0, 0, , ahk_class #32768 ;MN_GETHMENU
if !hMenu := ErrorLevel
	return
WinGet, vPID, PID, % "ahk_id " hWnd
;OpenProcess may not be needed to set an external menu item's icon to HBMMENU_MBAR_RESTORE
if !hProc := DllCall("OpenProcess", UInt,0x1F0FFF, Int,0, UInt,vPID, Ptr)
	return
Loop, % DllCall("GetMenuItemCount", Ptr,hMenu)
{
iniwrite, %vtext%, menuentries.txt, %A_Index%
vChars := DllCall("user32\GetMenuString", Ptr,hMenu, UInt,vIndex, Ptr,0, Int,0, UInt,0x400) + 1
	VarSetCapacity(vText, vChars << !!A_IsUnicode)
	DllCall("user32\GetMenuString", Ptr,hMenu, UInt,vIndex, Str,vText, Int,vChars, UInt,0x400) ;MF_BYPOSITION 
	vPos := A_Index-1
	vIndex := A_Index-1
	vSize := A_PtrSize=8?80:48
	VarSetCapacity(MENUITEMINFO, vSize, 0)
	DllCall("SetMenuItemInfo", Ptr,hMenu, UInt,vPos, Int,1, Ptr,&MENUITEMINFO)
}
DllCall("CloseHandle", Ptr,hProc)
return
