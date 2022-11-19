;#noenv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir "C:\Script\AHK\z_ConTxt"  ; Ensures a consistent starting directory.
;AutoHotkeyU32_UIA.exe
#include C:\Script\AHK\z_ConTxt\gdip.ahk
#singleinstance force 	;	#persistent
iniRead, Extensions_TEXT,	FileTypes.ini, Text, 	Extensions, %defT%
iniRead, Extensions_IMAGE,	FileTypes.ini, Image, Extensions, %defI%
in = %1%
SplitPath in,,, inEXT,cunt
inExt	:= ("." . inEXT)
defT	:=	".txt.nfo.cpp.lua.theme.log.ini.com.cmd.bat.js.au3.ahk.reg"
defI	:=	".png.jpg.bmp.gif.jpeg"

start:
if 0>1
{
	msgbox 0>1
	files = %1%, %2%
	CopySelectedFileContents()
} 
else 
if 0=1 
{
	if Extensions_IMAGE contains %inExt%
	{
		pToken	:= Gdip_Startup()
		pBitmap	:= Gdip_CreateBitmapFromFile(in)
		hBitmap	:= Gdip_CreateHBITMAPFromBitmap(pBitmap)
		Gdip_DisposeImage(pBitmap)
		Gdip_Shutdown(pToken)
		SetClipboardData(8, hBitmap)
		DllCall("DeleteObject", "Uint", hBitmap)
	} 
	else 
	if Extensions_TEXT contains %inExt%
	{
		FileRead, Clipboard, %1%
		tooltip Copied %cunt%
		settimer tooloff, -1000
	} else {
		MsgBox, 3, Unknown Type, Add %inExt% to Text?, Timeout
		IfMsgBox, yes, {
			Extensions_TEXT := (Extensions_TEXT . inEXT)
			IniWrite, %Extensions_TEXT%, FileTypes.ini, Text, Extensions
			FileRead, Clipboard, %1%
			tooltip Copied %cunt%
			settimer tooloff, -1000
		} else
		IfMsgBox, no, {
			MsgBox, 3, Unknown Type, Add %inExt% to Image?, Timeout
			IfMsgBox, yes, {
				Extensions_IMAGE := (Extensions_IMAGE . inEXT)
				IniWrite, %Extensions_IMAGE%, FileTypes.ini, Image, Extensions
				goto start
			}
		}
	}
}
exitapp

CopySelectedFileContents() {
content:=""
for i, file in files {
	FileRead, textB, %file%
	if i > 1
		content := content . "`n`n"
	content := content . textB
	}
Clipboard := content
}

SetClipboardData(nFormat, hBitmap) {
	DllCall("GetObject", "Uint", hBitmap, "int", VarSetCapacity(oi,84,0), "Uint", &oi)
	hDBI :=	DllCall("GlobalAlloc", "Uint", 2, "Uint", 40+NumGet(oi,44))
	pDBI :=	DllCall("GlobalLock", "Uint", hDBI)
	DllCall("RtlMoveMemory", "Uint", pDBI, "Uint", &oi+24, "Uint", 40)
	DllCall("RtlMoveMemory", "Uint", pDBI+40, "Uint", NumGet(oi,20), "Uint", NumGet(oi,44))
	DllCall("GlobalUnlock", "Uint", hDBI)
	DllCall("OpenClipboard", "Uint", 0)
	DllCall("EmptyClipboard")
	DllCall("SetClipboardData", "Uint", nFormat, "Uint", hDBI)
	DllCall("CloseClipboard")
}

tooloff:
tooltip
return
