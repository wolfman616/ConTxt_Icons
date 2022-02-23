#noEnv ; #warn
#persistent
#SingleInstance force
coordmode, tooltip, mouse
coordmode, mouse, screen
sendMode Input
setWorkingDir %a_scriptDir%

;#notrayicon
#include	C:\Script\AHK\- LiB\GDI+_All.ahk
#NoEnv
SetBatchLines, -1
menu, tray, add, Open Script Folder, Open_ScriptDir
menu, tray, standard  ; #Include Gdip_All.ahk
global col := 0x000000

if 		0 != 1 	; Not run with parameter
	filePath := "D:\Documents\My Pictures\6pkB.gif" ; specify the file path to gif
else if 0 = 1	; run with parameter from menus
	filePath 	= %1%
if !(fileexist(filePath)) {
	msgbox,,% "Error",% "Cant find `n" filePath
	FileSelectFile, filePath , Options, D:\Documents\My Pictures\, Title,% "Portable Network Graphics PNG (*.png)"
}
pToken 	:= 	Gdip_Startup()
OnExit, Exit
OnMessage(0x201, "WM_LBUTTONDOWN")

exStyles := (WS_EX_COMPOSITED := 0x02000000) | (WS_EX_LAYERED := 0x80000)
Gui, gif1: New, +E%exStyles% -Caption -DPIScale +AlwaysOnTop +toolwindow +owner +owndialogs, midi
Gui, gif1:+LastFound -Caption ;+E0x80000
gui, gif1:color, 000001
;winSet, Transcolor, 000000 
   winSet, Transcolor, 000001 

Gui, gif1: Add, Picture, y10 hwndhwndGif1, % filePath
Gui, gif1: Add, Button, xp y+10 w80 h24 gPlayPause hwndhwndPlayPause, Pause
gif1 := new Gif(filePath, hwndGif1)
mousegetpos, x, y
xx:= "x" . (x-50)
yy:= "y" . (y-180)
Gui, gif1: Show,%xx% %yy%, midi
tooltip, Esc2Quit , (xx-100), (yy-20)
settimer tooloff, -1000 
   gif1.Play()

return

WM_LBUTTONDOWN() {
 ;settimer exit, -4000
;exitapp
col := ~col
gui, gif1:color,% col
Gui, gif1: Show,%xx% %yy%, midi

 }

#z::
mousegetpos, x, y
xx:= "x" . (x-50)
yy:= "y" . (y-180)
Gui, gif1: Show,%xx% %yy%, midi
   gif1.Play()
return

~esc::
GuiClose:
   ExitApp

;######################################################

PlayPause:
isPlaying := gif1.isPlaying
GuiControl,, % hwndPlayPause, % (isPlaying) ? "Play" : "Pause"
if (!isPlaying) {
   gif1.Play()
} else {
   gif1.Pause()
}
return 

;######################################################

Exit:
Gdip_ShutDown(pToken)
ExitApp
return

;######################################################

class Gif
{   
   __New(file, hwnd, cycle := true)
   {
      this.file := file
      this.hwnd := hwnd
      this.cycle := cycle
      this.pBitmap := Gdip_CreateBitmapFromFile(this.file)
      Gdip_GetImageDimensions(this.pBitmap, width, height)
      this.width := width, this.height := height
      this.isPlaying := false      
      DllCall("Gdiplus\GdipImageGetFrameDimensionsCount", "ptr", this.pBitmap, "uptr*", frameDimensions)
      this.SetCapacity("dimensionIDs", 16*frameDimensions)
      DllCall("Gdiplus\GdipImageGetFrameDimensionsList", "ptr", this.pBitmap, "uptr", this.GetAddress("dimensionIDs"), "int", frameDimensions)
      DllCall("Gdiplus\GdipImageGetFrameCount", "ptr", this.pBitmap, "uptr", this.GetAddress("dimensionIDs"), "int*", count)
      this.frameCount := count
      this.frameCurrent := -1
      this.frameDelay := this.GetFrameDelay(this.pBitmap)
      this._Play("")
   }

   ; Return a zero-based array, containing the frames delay (in milliseconds)
   GetFrameDelay(pImage) {
      static PropertyTagFrameDelay := 0x5100

      DllCall("Gdiplus\GdipGetPropertyItemSize", "Ptr", pImage, "UInt", PropertyTagFrameDelay, "UInt*", ItemSize)
      VarSetCapacity(Item, ItemSize, 0)
      DllCall("Gdiplus\GdipGetPropertyItem"    , "Ptr", pImage, "UInt", PropertyTagFrameDelay, "UInt", ItemSize, "Ptr", &Item)

      PropLen := NumGet(Item, 4, "UInt")
      PropVal := NumGet(Item, 8 + A_PtrSize, "UPtr")

      outArray := []
      Loop, % PropLen//4 {
         if !n := NumGet(PropVal+0, (A_Index-1)*4, "UInt")
            n := 10
         outArray[A_Index-1] := n * 10
      }
      return outArray
   }
   
   Play()
   {
      this.isPlaying := true
      fn := this._Play.Bind(this)
      this._fn := fn
      SetTimer, % fn, -1
   }
   
   Pause()
   {
      this.isPlaying := false
      fn := this._fn
      SetTimer, % fn, Delete
   }
   
   _Play(mode := "set")
   {
      this.frameCurrent := mod(++this.frameCurrent, this.frameCount)
      DllCall("Gdiplus\GdipImageSelectActiveFrame", "ptr", this.pBitmap, "uptr", this.GetAddress("dimensionIDs"), "int", this.frameCurrent)
      hBitmap := Gdip_CreateHBITMAPFromBitmap(this.pBitmap)
      SetImage(this.hwnd, hBitmap)
      DeleteObject(hBitmap)
      if (mode = "set" && this.frameCurrent < (this.cycle ? 0xFFFFFFFF : this.frameCount - 1)) {
         fn := this._fn
         SetTimer, % fn, % -1 * this.frameDelay[this.frameCurrent]
      }
   }
   
   __Delete()
   {
      Gdip_DisposeImage(this.pBitmap)
      Object.Delete("dimensionIDs")
   }
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
