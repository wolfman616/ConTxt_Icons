SendMode Input  
SetWorkingDir %A_ScriptDir% 
pic_2_icon.ico  
#Persistent
#Singleinstance force
SetWinDelay, -1
setbatchlines -1
DetectHiddenWindows on
Global II
Global TT
Global Opacity
Global Restore_Previous_Versions_Entry
Global Open_Containing_Entry
Global Paste_MP3_Entry
;II=1
;TT=1
;Opacity=17
bgrColor := "220040"
hWnd2:=
Paste_MP3_Command=%appdata%\\z_WMP\z_WMP_Paste.exe
TargetICO=C:\\Icon\\20\\target.ico, 0
StarICO=C:\\ICON\\24\\Star (5).ico,0
Gosub LoadSettingsFromINI

;Paste_MP3_Command=\"C:\\Program Files\\AHK\\AutoHotkey.exe\" \"C:\\script\\AHK\\Z_MIDI_IN_OUT\\wmp_paste.ahk\" \"%V\"\\

;SYSTRAY MENU 
;==============================================================================
Menu, Tray, NoStandard
Menu, Tray, Icon, Context32.ico
;==============================================================================
Menu, submenu1, Add, Toggle Trans, TT
if TT=1
Menu, submenu1, Check, Toggle Trans
;==============================================================================
Menu, submenu1, Add, Toggle Icon Injector DLL, II
if II=1
Menu, submenu1, Check, Toggle Icon Injector DLL
;==============================================================================
Menu, submenu1, Add, open_containing_folder_entry, open_containing
if open_containing = 1
Menu, submenu1, Check, open_containing_folder_entry
;==============================================================================
Menu, submenu1, Add, Restore_Previous_Versions_Entry, Restore_Previous_Versions
if Restore_Previous_Versions_Entry=1
Menu, submenu1, Check, Restore_Previous_Versions_Entry,
;==============================================================================
Menu, submenu1, Add, Paste_MP3, Paste_MP3
if Paste_MP3=1
Menu, submenu1, Check, Paste_MP3,
;===============Enable=Defined=Menu=System=&=Re-add= Standard=items=below=======
Menu, Tray, Add, Settings, :submenu1
Menu, Tray, Standard
;==============================================================================

global EVENT_SYSTEM_MENUPOPUPSTART := 0x0006

OnExit("SaveSettingstoINI")

OnPopupMenu(hWinEventHook, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
;controlGet, hWnd2, Hwnd ,, ToolBarWindow321, hWnd
bgrColor := "220040"
If (TT=7)
	return
Else
	SetAcrylicGlassEffect(bgrColor, 17, ahk_id, hWnd)
}

SetAcrylicGlassEffect(thisColor, thisAlpha, ahk_id, hWnd) {
  
    initialAlpha := thisAlpha
    If (thisAlpha<2)
       thisAlpha := 1
    Else If (thisAlpha>250)
       thisAlpha := 255


    thisColor := ConvertToBGRfromRGB(thisColor)
    thisAlpha := Format("{1:#x}", thisAlpha)
    gradient_color := thisAlpha . thisColor

    Static init, accent_state := 4, ver := DllCall("GetVersion") & 0xff < 10
    Static pad := A_PtrSize = 8 ? 4 : 0, WCA_ACCENT_POLICY := 19
    accent_size := VarSetCapacity(ACCENT_POLICY, 16, 0)
    NumPut(accent_state, ACCENT_POLICY, 0, "int")

    If (RegExMatch(gradient_color, "0x[[:xdigit:]]{8}"))
       NumPut(gradient_color, ACCENT_POLICY, 8, "int")

    VarSetCapacity(WINCOMPATTRDATA, 4 + pad + A_PtrSize + 4 + pad, 0)
    && NumPut(WCA_ACCENT_POLICY, WINCOMPATTRDATA, 0, "int")
    && NumPut(&ACCENT_POLICY, WINCOMPATTRDATA, 4 + pad, "ptr")
    && NumPut(accent_size, WINCOMPATTRDATA, 4 + pad + A_PtrSize, "uint")
    If !(DllCall("user32\SetWindowCompositionAttribute", "ptr", hWnd, "ptr", &WINCOMPATTRDATA))
       Return
;tooltip, size %accent_size% %gradient_color%

    thisOpacity := 200
    ;WinSet, Transparent, 50, hWindow
;WinSet, Transparent, 50 , ahk_id %hWnd%
    Return
}
ConvertToBGRfromRGB(RGB) { ; Get numeric BGR value from numeric RGB value or HTML color name
  ; HEX values
  BGR := SubStr(RGB, -1, 2) SubStr(RGB, 1, 4) 
  Return BGR 
}

;run SetWindowCompositionAttribute.exe class 32768 active 1
;pause
;WinGet, hWnd, ID, ahk_class #32768
	
;WinSet, Transparent, 150 , ahk_id %hWnd%

 AtExit()
{
WinSet, Transparent, 100 , ahk_id %hWnd%
	global hWinEventHook, lpfnWinEventProc
	if (hWinEventHook)
		DllCall("UnhookWinEvent", "Ptr", hWinEventHook), hWinEventHook := 0
	if (lpfnWinEventProc)
		DllCall("GlobalFree", "Ptr", lpfnWinEventProc, "Ptr"), lpfnWinEventProc := 0	
	return 0
}

OnExit("AtExit")

hWinEventHook := DllCall("SetWinEventHook", "UInt", EVENT_SYSTEM_MENUPOPUPSTART, "UInt", EVENT_SYSTEM_MENUPOPUPSTART, "Ptr", 0, "Ptr", (lpfnWinEventProc := RegisterCallback("OnPopupMenu", "")), "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002)

exit


Restore_Previous_Versions:
if Restore_Previous_Versions_Entry=1
{
setbatchlines, 20
traytip, Context Menus, Restore Previous Versions entry enabled
RegDelete, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked, {596AB062-B4D2-4215-9F74-E9109B0A8153},
setbatchlines, -1
global Restore_Previous_Versions_Entry=7
Menu, submenu1, UnCheck, Restore_Previous_Versions_Entry
return
}
if Restore_Previous_Versions_Entry=7
{
setbatchlines, 20
traytip, Context Menus, Restore Previous Versions entry removed (Explorer Restart Required)
RegWrite, REG_BINARY, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked, {596AB062-B4D2-4215-9F74-E9109B0A8153},
setbatchlines, -1
global Restore_Previous_Versions_Entry=1
Menu, submenu1, Check, Restore_Previous_Versions_Entry
return
}

Open_Containing:
if Open_Containing_Entry=1
{
setbatchlines, 20
RegDelete, HKEY_CLASSES_ROOT\*\shell\Windows.OpenContainingFolder.opencontaining, CanonicalName,
RegDelete, HKEY_CLASSES_ROOT\*\shell\Windows.OpenContainingFolder.opencontaining, CommandStateHandler,
RegDelete, HKEY_CLASSES_ROOT\*\shell\Windows.OpenContainingFolder.opencontaining, CommandStateSync,
RegDelete, HKEY_CLASSES_ROOT\*\shell\Windows.OpenContainingFolder.opencontaining, InvokeCommandOnSelection,
RegDelete, HKEY_CLASSES_ROOT\*\shell\Windows.OpenContainingFolder.opencontaining, VerbHandler,
RegDelete, HKEY_CLASSES_ROOT\*\shell\Windows.OpenContainingFolder.opencontaining, VerbName,
RegDelete, HKEY_CLASSES_ROOT\*\shell\Windows.OpenContainingFolder.opencontaining, Position,
RegDelete, HKEY_CLASSES_ROOT\*\shell\Windows.OpenContainingFolder.opencontaining, SeparatorBefore,
RegDelete, HKEY_CLASSES_ROOT\*\shell\Windows.OpenContainingFolder.opencontaining, SeparatorAfter,
RegDelete, HKEY_CLASSES_ROOT\*\shell\Windows.OpenContainingFolder.opencontaining, MUIVerb,
RegDelete, HKEY_CLASSES_ROOT\*\shell\Windows.OpenContainingFolder.opencontaining, Icon,
RegDelete, HKEY_CLASSES_ROOT\*\shell, Windows.OpenContainingFolder.opencontaining,
setbatchlines, -1
global Open_Containing_Entry=7
Menu, submenu1, UnCheck, Open_Containing_Entry

return
}
if Open_Containing_Entry=7
{
setbatchlines, 20
open_containing_folder_icon= % TargetICO
RegWrite, REG_SZ, 		HKEY_CLASSES_ROOT\*\shell\Windows.OpenContainingFolder.opencontaining, CanonicalName, {2ff6f967-213a-49a8-985a-9b3178df4b0a},
RegWrite, REG_SZ, 		HKEY_CLASSES_ROOT\*\shell\Windows.OpenContainingFolder.opencontaining, CommandStateHandler, {3B1599F9-E00A-4BBF-AD3E-B3F99FA87779},
RegWrite, REG_SZ, 		HKEY_CLASSES_ROOT\*\shell\Windows.OpenContainingFolder.opencontaining, CommandStateSync, ,
RegWrite, REG_DWORD, HKEY_CLASSES_ROOT\*\shell\Windows.OpenContainingFolder.opencontaining, InvokeCommandOnSelection, 00000001,
RegWrite, REG_SZ, 		HKEY_CLASSES_ROOT\*\shell\Windows.OpenContainingFolder.opencontaining, VerbHandler, {37ea3a21-7493-4208-a011-7f9ea79ce9f5},
RegWrite, REG_SZ, 		HKEY_CLASSES_ROOT\*\shell\Windows.OpenContainingFolder.opencontaining, VerbName, opencontaining,
RegWrite, REG_SZ, 		HKEY_CLASSES_ROOT\*\shell\Windows.OpenContainingFolder.opencontaining, Position, top,
RegWrite, REG_SZ, 		HKEY_CLASSES_ROOT\*\shell\Windows.OpenContainingFolder.opencontaining, SeparatorBefore, ,
RegWrite, REG_SZ, 		HKEY_CLASSES_ROOT\*\shell\Windows.OpenContainingFolder.opencontaining, SeparatorAfter, ,
RegWrite, REG_SZ, 		HKEY_CLASSES_ROOT\*\shell\Windows.OpenContainingFolder.opencontaining, MUIVerb, Open File Location,
RegWrite, REG_SZ, 		HKEY_CLASSES_ROOT\*\shell\Windows.OpenContainingFolder.opencontaining, Icon, %open_containing_folder_icon%,
setbatchlines, -1
global Open_Containing_Entry=1
Menu, submenu1, Check, Open_Containing_Entry
return
}

Paste_MP3:
if Paste_MP3_Entry=1 
{ 				; entry enabled - hence disable entry below
setbatchlines, 20
RegDelete, HKEY_CLASSES_ROOT\Folder\shell\{aa02e1e0-7b98-42f1-8868-3aee99e926e1}, @,
RegDelete, HKEY_CLASSES_ROOT\Folder\shell\{aa02e1e0-7b98-42f1-8868-3aee99e926e1}, Icon,
RegDelete, HKEY_CLASSES_ROOT\Folder\shell\{aa02e1e0-7b98-42f1-8868-3aee99e926e1}, Position,
RegDelete, HKEY_CLASSES_ROOT\Folder\shell\{aa02e1e0-7b98-42f1-8868-3aee99e926e1}\Command, @,
RegDelete, HKEY_CLASSES_ROOT\Directory\Background\shell\{aa02e1e0-7b98-42f1-8868-3aee99e926e1}, @,
RegDelete, HKEY_CLASSES_ROOT\Directory\Background\shell\{aa02e1e0-7b98-42f1-8868-3aee99e926e1}, Icon,
RegDelete, HKEY_CLASSES_ROOT\Directory\Background\shell\{aa02e1e0-7b98-42f1-8868-3aee99e926e1}, Position,
RegDelete, HKEY_CLASSES_ROOT\Directory\Background\shell\{aa02e1e0-7b98-42f1-8868-3aee99e926e1}\Command, @,
setbatchlines, -1
global Paste_MP3_Entry=7
Menu, submenu1, UnCheck, Paste_MP3_Entry
return
}
if Paste_MP3_Entry=7 
{   				;else entry is disabled and will need to be enabled
setbatchlines, 20
Paste_mp3_icon=% StarICO
RegWrite, REG_SZ, HKEY_CLASSES_ROOT\Folder\shell\{aa02e1e0-7b98-42f1-8868-3aee99e926e1}, @, Move Mp3 Here,
RegWrite, REG_SZ, HKEY_CLASSES_ROOT\Folder\shell\{aa02e1e0-7b98-42f1-8868-3aee99e926e1}, Icon, %Paste_mp3_icon%
RegWrite, REG_SZ, HKEY_CLASSES_ROOT\Folder\shell\{aa02e1e0-7b98-42f1-8868-3aee99e926e1}, Position, Top
RegWrite, REG_SZ, HKEY_CLASSES_ROOT\Folder\shell\{aa02e1e0-7b98-42f1-8868-3aee99e926e1}\Command, @, %Paste_MP3_Command%,
RegWrite, REG_SZ, HKEY_CLASSES_ROOT\Directory\Background\shell\{aa02e1e0-7b98-42f1-8868-3aee99e926e1}, @, Move Mp3 Here,
RegWrite, REG_SZ, HKEY_CLASSES_ROOT\Directory\Background\shell\{aa02e1e0-7b98-42f1-8868-3aee99e926e1}, Icon, %Paste_mp3_icon%
RegWrite, REG_SZ, HKEY_CLASSES_ROOT\Directory\Background\shell\{aa02e1e0-7b98-42f1-8868-3aee99e926e1}, Position, Top
RegWrite, REG_SZ, HKEY_CLASSES_ROOT\Directory\Background\shell\{aa02e1e0-7b98-42f1-8868-3aee99e926e1}\Command, @, %Paste_MP3_Command%,
setbatchlines, -1
global Paste_MP3_Entry=1
Menu, submenu1, Check, Paste_MP3_Entry
return
}

II:
if II=1
{
global II=7
RunWait, %comspec% /c "regsvr32 /u ContextIcons.dll"
Menu, submenu1, UnCheck, Toggle Icon Injector DLL
}
if II=7
{
global II=1
RunWait, %comspec% /c "regsvr32 ContextIcons.dll"
Menu, submenu1, Check, Toggle Icon Injector DLL
}
Return

TT:
if TT=1
{
global TT=7
Menu, submenu1, UnCheck, Toggle Trans
return
}
if TT=7
{
global TT=1
Menu, submenu1, Check, Toggle Trans
return
}

^#T::
gosub TT
return

LoadSettingsFromINI:
iniread, Opacity, z_ConTxt.ini , Opacity, Opacity, 17
iniread, TT, z_ConTxt.ini , TransToggle, TT, 1
iniread, II, z_ConTxt.ini , IconInjector, II, 7
iniread, Restore_Previous_Versions_Entry, z_ConTxt.ini , Restore_Previous_Versions_Entry, Restore_Previous_Versions_Entry, 7
iniread, Open_Containing_Entry, z_ConTxt.ini , Open_Containing_Entry, Open_Containing_Entry, 7
iniread, Paste_MP3_Entry, z_ConTxt.ini , Paste_MP3_Entry, Paste_MP3_Entry, 7
Return

SaveSettingstoINI()
	{
	iniwrite, %II% , z_ConTxt.ini , IconInjector, II
	iniwrite, %TT% , z_ConTxt.ini , TransToggle, TT
	iniWrite, %Opacity% , z_ConTxt.ini , Opacity, Opacity
	iniWrite, %Restore_Previous_Versions_Entry% , z_ConTxt.ini , Restore_Previous_Versions_Entry, Restore_Previous_Versions_Entry
	iniWrite, %Open_Containing_Entry% , z_ConTxt.ini , Open_Containing_Entry, Open_Containing_Entry
	iniWrite, %Paste_MP3_Entry% , z_ConTxt.ini , Paste_MP3_Entry , Paste_MP3_Entry
Return
	}