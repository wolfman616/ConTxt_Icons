#noEnv ; #warn ; only use with Autohotkey\AutoHotkeyA32_UIA.exe 
;#persistent
#SingleInstance off
sendMode Input
setWorkingDir %a_scriptDir%
menu, tray, add, Open Script Folder, Open_ScriptDir,
menu, tray, standard

if 		0 	!= 	1 	; Not run with parameter
	ImagePath   := 	"D:\Documents\My Pictures\i_poop.png"
else if 0 	= 	1	; run with parameter from menus
	ImagePath 	= %1%
if !(fileexist(ImagePath)) {
	msgbox,,% "Error",% "Cant find `n" ImagePath
	FileSelectFile, ImagePath, Options, D:\Documents\My Pictures\, Title,% "Portable Network Graphics PNG (*.png)"
} 
Gui, +LastFound -Caption +E0x80000
hGui := WinExist()

pToken   := Gdip_Startup()
pImage   := Gdip_LoadImageFromFile(ImagePath)
nW   := Gdip_GetImageWidth(pImage)
nH   := Gdip_GetImageHeight(pImage)

mDC   := Gdi_CreateCompatibleDC(0)
mBM   := Gdi_CreateDIBSection(mDC, nW, nH, 32)
oBM   := Gdi_SelectObject(mDC, mBM)

Gdip_DrawImageRectI(pGraphics:=Gdip_CreateFromHDC(mDC), pImage, 0, 0, nW, nH)
DllCall("UpdateLayeredWindow", "Uint", hGui, "Uint", 0, "Uint", 0, "int64P", nW|nH<<32, "Uint", mDC, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)

GDI_SelectObject(mDC, oBM)
Gdi_DeleteObject(mBM)
Gdi_DeleteDC(mDC)

Gdip_DeleteGraphics(pGraphics)
Gdip_DisposeImage(pImage)
Gdip_Shutdown(pToken)

Gui, Show, Center W%nW% H%nH% , MIDI
	gui, -Caption +AlwaysOnTop
Return

~escape::
GuiClose:
GuiEscape:
ExitApp

Gdi_CreateCompatibleDC(hDC = 0)
{
   Return   DllCall("gdi32\CreateCompatibleDC", "Uint", hDC)
}

Gdi_CreateDIBSection(hDC, nW, nH, bpp = 32, ByRef pBits = "")
{
   NumPut(VarSetCapacity(bi, 40, 0), bi)
   NumPut(nW, bi, 4)
   NumPut(nH, bi, 8)
   NumPut(bpp, NumPut(1, bi, 12, "UShort"), 0, "Ushort")
 
   Return   DllCall("gdi32\CreateDIBSection", "Uint", hDC, "Uint", &bi, "Uint", DIB_RGB_COLORS:=0, "UintP", pBits, "Uint", 0, "Uint", 0)
}

Gdi_SelectObject(hDC, hGdiObj)
{
   Return   DllCall("gdi32\SelectObject", "Uint", hDC, "Uint", hGdiObj)
}

Gdi_DeleteObject(hGdiObj)
{
   Return   DllCall("gdi32\DeleteObject", "Uint", hGdiObj)
}

Gdi_DeleteDC(hDC)
{
   Return   DllCall("gdi32\DeleteDC", "Uint", hDC)
}

Gdip_Startup()
{
   If Not   DllCall("GetModuleHandle", "str", "gdiplus")
      DllCall("LoadLibrary"    , "str", "gdiplus")
   VarSetCapacity(si, 16, 0), si := Chr(1)
   DllCall("gdiplus\GdiplusStartup", "UintP", pToken, "Uint", &si, "Uint", 0)
   Return   pToken
}

Gdip_Shutdown(pToken)
{
   DllCall("gdiplus\GdiplusShutdown", "Uint", pToken)
   If   hModule :=   DllCall("GetModuleHandle", "str", "gdiplus")
         DllCall("FreeLibrary", "Uint", hModule)
   Return   0
}

Gdip_CreateFromHDC(hDC)
{
   DllCall("gdiplus\GdipCreateFromHDC", "Uint", hDC, "UintP", pGraphics)
   Return   pGraphics
}

Gdip_DeleteGraphics(pGraphics)
{
   Return   DllCall("gdiplus\GdipDeleteGraphics", "Uint", pGraphics)
}

Gdip_LoadImageFromFile(ImagePath)
{
   VarSetCapacity(wFile, 1023)
   DllCall("kernel32\MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &ImagePath, "int", -1, "Uint", &wFile, "int", 512)
   DllCall("gdiplus\GdipLoadImageFromFile", "Uint", &wFile, "UintP", pImage)
   Return   pImage
}

Gdip_DisposeImage(pImage)
{
   Return   DllCall("gdiplus\GdipDisposeImage", "Uint", pImage)
}

Gdip_GetImageWidth(pImage)
{
   DllCall("gdiplus\GdipGetImageWidth", "Uint", pImage, "UintP", nW)
   Return   nW
}

Gdip_GetImageHeight(pImage)
{
   DllCall("gdiplus\GdipGetImageHeight", "Uint", pImage, "UintP", nH)
   Return   nH
}

Gdip_DrawImageRectI(pGraphics, pImage, nL, nT, nW, nH)
{
   Return   DllCall("gdiplus\GdipDrawImageRectI", "Uint", pGraphics, "Uint", pImage, "int", nL, "int", nT, "int", nW, "int", nH)
}

return,

Open_ScriptDir:
toolTip %a_scriptFullPath%
z=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %z%,, hide
sleep 1250

ToolOff:
toolTip,
return
