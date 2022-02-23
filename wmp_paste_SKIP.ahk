;FOLDER BACKGROUND VAR - HIGHLIGHT PASTE
#SingleInstance force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;#NoTrayIcon
;#persistent
;Menu, Tray, Icon, copy.ico
global Path_wmpScr 	:= 	"wmp_Matt.ahk ahk_class AutoHotkey"
global wmp
global media
global controls
global WinTitle
global Path2File
global newsong
global path2paste
global Stop=18809
global Play:=0x2e0000
global Pause=32808
global Prev=18810
global Next=18811
global Vol_Up=32815
global Vol_Down=32816
global name
global dir
global bum
global ext
global name_no_ext
global drive

onexit() { 

	WMP 	:= Delete RemoteWMP

}

SplitPath, 1, name, dir, ext, name_no_ext, drive
OldClip := Clipboard
WinTitle=Windows Media Player
wmp:= new RemoteWMP
sleep, 150
media =% wmp.player.currentMedia
sleep, 20
Path2File:=media.sourceURL
newsong= % Path2File
path2paste=%1%
result := Send_WM_COPYDATA("pastenskip", Path_wmpScr)

sleep 50
sleep 500
try 
	bum:=media.sourceURL
if bum != Path2File

if (InvokeVerb(Path2File, "Cut")) {
    Process,Exist
    hwnd:=WinExist("ahk_class tooltips_class32 ahk_pid " Errorlevel)
}
fuckitnigger:
sleep 300
if (InvokeVerb(path2paste, "Paste")) { 	
	Traytip, Tune Moved, moved %name_no_ext% `nto %dir%
	Process,Exist
    hwnd:=WinExist("ahk_class tooltips_class32 ahk_pid " Errorlevel)
} else
	goto fuckitnigger
	
RestoreClip:
sleep 300
try {
	if !clipboard {
		clipboard:=oldclip
		sleep 30
		Clipboard := 
		sleep 30
		clipboard:=oldclip
	}
} catch {
	sleep 50
	goto RestoreClip
}
Exit


class RemoteWMP
{
   __New()  {
      static IID_IOleClientSite := "{00000118-0000-0000-C000-000000000046}"
           , IID_IOleObject     := "{00000112-0000-0000-C000-000000000046}"
      Process, Exist, wmplayer.exe
      if !ErrorLevel {
         Tooltip, wmplayer.exe is not running %error%
		SetTimer ToolOff, -4000
		Exit 
		}
      if !this.player := ComObjCreate("WMPlayer.OCX.7") {
		Tooltip, Failed to get WMPlayer.OCX.7 object %Error%
		SetTimer ToolOff, -4000
		Exit 
		}
      this.rms := IWMPRemoteMediaServices_CreateInstance()
      this.ocs := ComObjQuery(this.rms, IID_IOleClientSite)
      this.ole := ComObjQuery(this.player, IID_IOleObject)
      DllCall(NumGet(NumGet(this.ole+0)+3*A_PtrSize), "Ptr", this.ole, "Ptr", this.ocs)
   }
}

IWMPRemoteMediaServices_CreateInstance() {
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
	sleep, 50 
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


InvokeVerb(path, menu, validate=True) {
    objShell := ComObjCreate("Shell.Application")
    if InStr(FileExist(path), "D") || InStr(path, "::{") {
        objFolder := objShell.NameSpace(path)   
        objFolderItem := objFolder.Self
    } else {
        SplitPath, path, name, dir
        objFolder := objShell.NameSpace(dir)
        objFolderItem := objFolder.ParseName(name)
    }
    if validate {
        colVerbs := objFolderItem.Verbs   
        loop % colVerbs.Count {
            verb := colVerbs.Item(A_Index - 1)
            retMenu := verb.name
            StringReplace, retMenu, retMenu, &       
            if (retMenu = menu) {
                verb.DoIt
                Return True
            }
        }
		Return False
    } else
        objFolderItem.InvokeVerbEx(Menu)
} 
return
; settimer, tooloff, -2000
; return

WMP_NEXT:
Process, Exist, wmplayer.exe
ifwinnotexist, Windows Media Player
{
	TrayTip, Windows Media Player, Process found but window Not
	Return
} Else {
	oldsong:=newsong
	PostMessage, 0x111, Stop, 0, ,%WinTitle%
	sleep, 150
	PostMessage, 0x111, Next, 0, ,%WinTitle%
	sleep 200
	thecall1:
	gosub RECHECK
	if newsong =% oldsong
	{
		traytip Windows Media Player, End of Playlist		
		exit
	} else {
		wmp.jump(skipD)
		sleep 100
		PostMessage, 0x319, 0, Play, ,%WinTitle%
		sleep 300
		if !(wmp.player.playState = 3)
			msgbox error not playing trying again
		
	}
	return
}

WMP_Refresh: 
	{
	wmp := new RemoteWMP
	media := wmp.player.currentMedia
	controls := wmp.player.controls
	return
	}

RECHECK:
	{
	sleep, 200
	gosub WMP_refresh
	sleep 200
	newsong= % media.sourceURL
	sleep 200
	return
	}

Send_WM_COPYDATA(ByRef StringToSend, ByRef TargetScriptTitle)  ; ByRef saves a little memory in this case.
; This function sends the specified string to the specified window and returns the reply.
; The reply is 1 if the target window processed the message, or 0 if it ignored it.
{
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)  ; Set up the structure's memory area.
    ; First set the structure's cbData member to the size of the string, including its zero terminator:
    SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)  ; OS requires that this be done.
    NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)  ; Set lpData to point to the string itself.
    Prev_DetectHiddenWindows := A_DetectHiddenWindows
    Prev_TitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows On
    SetTitleMatchMode 2
    TimeOutTime := 4000  ; Optional. Milliseconds to wait for response from receiver.ahk. Default is 5000
    ; Must use SendMessage not PostMessage.
    SendMessage, 0x4a, 0, &CopyDataStruct,, %TargetScriptTitle%,,,, %TimeOutTime% ; 0x4a is WM_COPYDATA.
    DetectHiddenWindows %Prev_DetectHiddenWindows%  ; Restore original setting for the caller.
    SetTitleMatchMode %Prev_TitleMatchMode%         ; Same.
    return ErrorLevel  ; Return SendMessage's reply back to our caller.
}


tooloff:
{
tooltip,
return
}