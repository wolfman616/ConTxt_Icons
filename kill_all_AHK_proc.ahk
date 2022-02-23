pic_2_icon.ico  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
processes=AutoHotkeyU32 - Admin.exe, AutoHotkeyA32_UIA.exe, AutoHotkeyA32_UIA - aDMIN.exe, AutoHotkeyA32.exe, AutoHotkeyA32 - Admin.exe,autohotkey.exe,AutoHotkey - Admin.exe;firefox.exe,Chrome.exe
Loop, parse, processes, `,
{
	Loop
	{
		Process, Close, %A_LoopField%
		Process, Exist, %A_LoopField%
	}	Until	!ErrorLevel
}
return