#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
/*	p_menu				= "MenuName" (e.g., Tray, etc.)
	p_item				= 1, ...
	p_bm_unchecked,
	p_bm_checked		= path to bitmap/false
	p_unchecked_face,
	p_checked_face		= true/false (i.e., true = pixels with same color as first pixel are transparent)
*/
Menu_AssignBitmap( p_menu, p_item, p_bm_unchecked, p_unchecked_face=false, p_bm_checked=false, p_checked_face=false )
{
	static	h_menuDummy
	
	if h_menuDummy=
	{
		Menu, menuDummy, Add
		Menu, menuDummy, DeleteAll
		
		Gui, 99:Menu, menuDummy
		Gui, 99:Show, Hide, guiDummy

		old_DetectHiddenWindows := A_DetectHiddenWindows
		DetectHiddenWindows, on

		Process, Exist
		h_menuDummy := DllCall( "GetMenu", "uint", WinExist( "guiDummy ahk_class AutoHotkeyGUI ahk_pid " ErrorLevel ) )
		if ReportError( ErrorLevel or h_menuDummy = 0, "Menu_AssignBitmap: GetMenu", "h_menuDummy = " h_menuDummy )
			return, false

		DetectHiddenWindows, %old_DetectHiddenWindows%
		
		Gui, 99:Menu
		Gui, 99:Destroy
	}
	
	Menu, menuDummy, Add, :%p_menu%
	
	h_menu := DllCall( "GetSubMenu", "uint", h_menuDummy, "int", 0 )
	if ReportError( ErrorLevel or h_menu = 0, "Menu_AssignBitmap: GetSubMenu", "h_menu = " h_menu )
		return, false

	success := DllCall( "RemoveMenu", "uint", h_menuDummy, "uint", 0, "uint", 0x400 )
	if ReportError( ErrorLevel or ! success,  "Menu_AssignBitmap: RemoveMenu", "success = " success )
		return, false
	Menu, menuDummy, Delete, :%p_menu%
	
	if ( p_bm_unchecked )
	{
		hbm_unchecked := DllCall( "LoadImage"
									, "uint", 0
									, "str", p_bm_unchecked
									, "uint", 0									; IMAGE_BITMAP
									, "int", 0
									, "int", 0
									, "uint", 0x10|( 0x20*p_unchecked_face ) )	; LR_LOADFROMFILE|LR_LOADTRANSPARENT
		if ReportError( ErrorLevel or ! hbm_unchecked, "Menu_AssignBitmap: LoadImage: unchecked", "hbm_unchecked = " hbm_unchecked )
			return, false
	}

	if ( p_bm_checked )
	{
		hbm_checked := DllCall( "LoadImage"
									, "uint", 0
									, "str", p_bm_checked
									, "uint", 0
									, "int", 0
									, "int", 0
									, "uint", 0x10|( 0x20*p_checked_face ) )
		if ReportError( ErrorLevel or ! hbm_checked, "Menu_AssignBitmap: LoadImage: checked", "hbm_checked = " hbm_checked )
			return, false
	}

	success := DllCall( "SetMenuItemBitmaps"
							, "uint", h_menu
							, "uint", p_item-1
							, "uint", 0x400										; MF_BYPOSITION
							, "uint", hbm_unchecked
							, "uint", hbm_checked )
	if ReportError( ErrorLevel or ! success, "Menu_AssignBitmap: SetMenuItemBitmaps", "success = " success )
		return, false
	
	return, true
}

ReportError( p_condition, p_title, p_extra )
{
	if p_condition
		MsgBox,
			( LTrim
				[Error] %p_title%
				EL = %ErrorLevel%, LE = %A_LastError%
				
				%p_extra%
			)
	
	return, p_condition
}