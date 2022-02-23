#SingleInstance force
SETBATCHLINES -1
;critical
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;Menu, Tray, Icon, C:\ICON\32\akaiapc_32.ico
;#notrayicon ;this ruins everything
;#persistent
skipD=86
Stop=18809
Play=0x2e0000
Pause=32808
Prev=18810
Next=18811
Vol_Up=32815
Vol_Down=32816
WinTitle=Windows Media Player
Process, Exist, wmplayer.exe
ifwinnotexist, Windows Media Player
	{
	TrayTip, Windows Media Player, Process found but window Not,3000,2
	Return
	}
Else
	{
	PostMessage, 0x111, Stop, 0, ,%WinTitle%
	sleep, 50
	PostMessage, 0x111, Next, 0, ,%WinTitle%
	sleep 50
	thecall1:
	gosub thetry
	if newsong =% oldsong
		{
		;tooltip, newsong = oldsong
		sleep 100

		}
	else
		{

		PostMessage, 0x319, 0, Play, ,%WinTitle%
		;TOOLTIP, congrats you changed to the next tune you bell
		}
	}
return

class RemoteWMP
{
   __New()  {
      static IID_IOleClientSite := "{00000118-0000-0000-C000-000000000046}"
           , IID_IOleObject     := "{00000112-0000-0000-C000-000000000046}"
      Process, Exist, wmplayer.exe
      if !ErrorLevel
		{
		tooltip, wmplayer.exe is not running
		settimer ToolTip_Off, -4000
		exit
		}
      if !this.player := ComObjCreate("WMPlayer.OCX.7")
		{
        Tooltip, Failed to get WMPlayer.OCX.7 object
		settimer ToolTip_Off, -4000
		exit
		}
      this.rms := IWMPRemoteMediaServices_CreateInstance()
      this.ocs := ComObjQuery(this.rms, IID_IOleClientSite)
      this.ole := ComObjQuery(this.player, IID_IOleObject)
      DllCall(NumGet(NumGet(this.ole+0)+3*A_PtrSize), "Ptr", this.ole, "Ptr", this.ocs)
   }

 Jump(sec)  {
      this.player.Controls.currentPosition += sec
   }

}

IWMPRemoteMediaServices_CreateInstance()
{
   static vtblUnk, vtblRms, vtblIsp, vtblOls, vtblPtrs := 0, size := (A_PtrSize + 4)*4 + 4
   if !VarSetCapacity(vtblUnk)  {
      extfuncs := ["QueryInterface", "AddRef", "Release"]

      VarSetCapacity(vtblUnk, extfuncs.Length()*A_PtrSize)

      for i, name in extfuncs
         NumPut(RegisterCallback("IUnknown_" . name), vtblUnk, (i-1)*A_PtrSize)
   }
   if !VarSetCapacity(vtblRms) {
      extfuncs := ["GetServiceType", "GetScriptableObject", "GetCustomUIMode"]

      VarSetCapacity(vtblRms, (3 + extfuncs.Length())*A_PtrSize)
      DllCall("ntdll\RtlMoveMemory", "Ptr", &vtblRms, "Ptr", &vtblUnk, "Ptr", A_PtrSize*3)

      for i, name in extfuncs
         NumPut(RegisterCallback("IWMPRemoteMediaServices_" . name, "Fast"), vtblRms, (2+i)*A_PtrSize)
   }
   if !VarSetCapacity(vtblIsp) {
      VarSetCapacity(vtblIsp, 4*A_PtrSize)
      DllCall("ntdll\RtlMoveMemory", "Ptr", &vtblIsp, "Ptr", &vtblUnk, "Ptr", A_PtrSize*3)
      NumPut(RegisterCallback("IServiceProvider_QueryService", "Fast"), vtblIsp, A_PtrSize*3)
   }
   if !VarSetCapacity(vtblOls) {
      extfuncs := ["SaveObject", "GetMoniker", "GetContainer", "ShowObject", "OnShowWindow", "RequestNewObjectLayout"]
      VarSetCapacity(vtblOls, (3 + extfuncs.Length())*A_PtrSize)
      DllCall("ntdll\RtlMoveMemory", "Ptr", &vtblOls, "Ptr", &vtblUnk, "Ptr", A_PtrSize*3)

      for i, name in extfuncs
         NumPut(RegisterCallback("IOleClientSite_" . name, "Fast"), vtblOls, (2+i)*A_PtrSize)
   }
   if !vtblPtrs
      vtblPtrs := [&vtblUnk, &vtblRms, &vtblIsp, &vtblOls]

   pObj := DllCall("GlobalAlloc", "UInt", 0, "Ptr", size, "Ptr")
   for i, ptr in vtblPtrs {
      off := A_PtrSize*(i - 1) + 4*(i - 1)
      NumPut(ptr, pObj+0, off, "Ptr")
      NumPut(off, pObj+0, off + A_PtrSize, "UInt")
   }
   NumPut(1, pObj+0, size - 4, "UInt")

   return pObj
}

IUnknown_QueryInterface(this_, riid, ppvObject)
{
   static IID_IUnknown, IID_IWMPRemoteMediaServices, IID_IServiceProvider, IID_IOleClientSite
   if !VarSetCapacity(IID_IUnknown)  {
      VarSetCapacity(IID_IUnknown, 16), VarSetCapacity(IID_IWMPRemoteMediaServices, 16), VarSetCapacity(IID_IServiceProvider, 16), VarSetCapacity(IID_IOleClientSite, 16)
      DllCall("ole32\CLSIDFromString", "WStr", "{00000000-0000-0000-C000-000000000046}", "Ptr", &IID_IUnknown)
      DllCall("ole32\CLSIDFromString", "WStr", "{CBB92747-741F-44FE-AB5B-F1A48F3B2A59}", "Ptr", &IID_IWMPRemoteMediaServices)
      DllCall("ole32\CLSIDFromString", "WStr", "{6d5140c1-7436-11ce-8034-00aa006009fa}", "Ptr", &IID_IServiceProvider)
      DllCall("ole32\CLSIDFromString", "WStr", "{00000118-0000-0000-C000-000000000046}", "Ptr", &IID_IOleClientSite)
   }
   
   if DllCall("ole32\IsEqualGUID", "Ptr", riid, "Ptr", &IID_IUnknown) {
      off := NumGet(this_+0, A_PtrSize, "UInt")
      NumPut(this_ - off, ppvObject+0, "Ptr")
      IUnknown_AddRef(this_)
      return 0 ; S_OK
   }

   if DllCall("ole32\IsEqualGUID", "Ptr", riid, "Ptr", &IID_IWMPRemoteMediaServices) {
      off := NumGet(this_+0, A_PtrSize, "UInt")
      NumPut((this_ - off)+(A_PtrSize + 4), ppvObject+0, "Ptr")
      IUnknown_AddRef(this_)
      return 0 ; S_OK
   }

   if DllCall("ole32\IsEqualGUID", "Ptr", riid, "Ptr", &IID_IServiceProvider) {
      off := NumGet(this_+0, A_PtrSize, "UInt")
      NumPut((this_ - off)+((A_PtrSize + 4)*2), ppvObject+0, "Ptr")
      IUnknown_AddRef(this_)
      return 0 ; S_OK
   }

   if DllCall("ole32\IsEqualGUID", "Ptr", riid, "Ptr", &IID_IOleClientSite)  {
      off := NumGet(this_+0, A_PtrSize, "UInt")
      NumPut((this_ - off)+((A_PtrSize + 4)*3), ppvObject+0, "Ptr")
      IUnknown_AddRef(this_)
      return 0 ; S_OK
   }

   NumPut(0, ppvObject+0, "Ptr")
   return 0x80004002 ; E_NOINTERFACE
}

IUnknown_AddRef(this_)
{
   off := NumGet(this_+0, A_PtrSize, "UInt")
   iunk := this_-off
   NumPut((_refCount := NumGet(iunk+0, (A_PtrSize + 4)*4, "UInt") + 1), iunk+0, (A_PtrSize + 4)*4, "UInt")
   return _refCount
}

IUnknown_Release(this_) {
   off := NumGet(this_+0, A_PtrSize, "UInt")
   iunk := this_-off
   _refCount := NumGet(iunk+0, (A_PtrSize + 4)*4, "UInt")
   if (_refCount > 0) {
      NumPut(--_refCount, iunk+0, (A_PtrSize + 4)*4, "UInt")
      if (_refCount == 0)
         DllCall("GlobalFree", "Ptr", iunk, "Ptr")
   }
   return _refCount
}

IWMPRemoteMediaServices_GetServiceType(this_, pbstrType)
{
   NumPut(DllCall("oleaut32\SysAllocString", "WStr", "Remote", "Ptr"), pbstrType+0, "Ptr")
   return 0
}

IWMPRemoteMediaServices_GetScriptableObject(this_, pbstrName, ppDispatch)
{
   return 0x80004001
}

IWMPRemoteMediaServices_GetCustomUIMode(this_, pbstrFile)
{
   return 0x80004001
}

IServiceProvider_QueryService(this_, guidService, riid, ppvObject)
{
   return IUnknown_QueryInterface(this_, riid, ppvObject)
}


ToolTip_Off:
{	
ToolTip,
settimer ToolTip_Off, off
return
}

WMP_Refresh: 
{
wmp := new RemoteWMP
media := wmp.player.currentMedia
controls := wmp.player.controls
return
}

THETRY:
{
sleep, 200
gosub WMP_refresh
sleep 200
newsong= % media.sourceURL
sleep 200
return
}
return

trycatch:
tooltip, try
;Until errorlevel=0
return
