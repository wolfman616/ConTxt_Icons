;#noenv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir "C:\Script\AHK\z_ConTxt"  ; Ensures a consistent starting directory.
#include C:\Script\AHK\z_ConTxt\gdip.ahk
#SingleInstance force
#persistent
;GLOBAL TEXTA


sFile=%1%
if 0=2
{
	files = %1%, %2%
	CopySelectedFileContents()
} 
else if 0=1 
{
	if (instr(sFile, .png)) || (instr(sFile, .jpg)) || (instr(sFile, .bmp)) || (instr(sFile, .gif)) || (instr(sFile, .webm)) {
		pToken	:= Gdip_Startup()
		pBitmap	:= Gdip_CreateBitmapFromFile(sFile)
		hBitmap	:= Gdip_CreateHBITMAPFromBitmap(pBitmap)
		Gdip_DisposeImage(pBitmap)
		Gdip_Shutdown(pToken)
		SetClipboardData(8, hBitmap)
		DllCall("DeleteObject", "Uint", hBitmap)
	}
	else if (instr(sFile, .reg)) || (instr(sFile, .ahk)) || (instr(sFile, .js)) || (instr(sFile, .au3)) || (instr(sFile, .bat)) || (instr(sFile, .cmd)) || (instr(sFile, .com)) || (instr(sFile, .ini)) || (instr(sFile, .log)) || (instr(sFile, .theme)) || (instr(sFile, .lua)) || (instr(sFile, .cpp)) || (instr(sFile, .nfo)) {
		FileRead, Clipboard, %sFile%
		;SLEEP 1000
		;Clipboard := textA
	}
	else msgbox UNKNOWN FILE TYPE
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