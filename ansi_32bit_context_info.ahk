;https://autohotkey.com/board/topic/19754-get-info-from-context-menu/
;
; AutoHotkey Version: 1.1
; Language:       English
; Platform:       Win9x/NT
; Author:         micha
;
; Script Function:
;	Demonstrates how to retrieve infos from a context/ popup menu
;

/*
  This is the struct we are using.

  typedef struct tagMENUITEMINFO {
  UINT    cbSize;
  UINT    fMask;
  UINT    fType;
  UINT    fState;
  UINT    wID;
  HMENU   hSubMenu;
  HBITMAP hbmpChecked;
  HBITMAP hbmpUnchecked;
  ULONG_PTR dwItemData;
  LPTSTR  dwTypeData;
  UINT    cch;
  HBITMAP hbmpItem;
} MENUITEMINFO, *LPMENUITEMINFO;


*/

#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
#Persistent
SetTimer, Demo, 500
return

Demo:
;constants
  MFS_ENABLED = 0
  MFS_CHECKED = 8
  MFS_DEFAULT = 0x1000
  MFS_DISABLED = 2
  MFS_GRAYED = 1
  MFS_HILITE = 0x80
  ;MFS_UNCHECKED = 0
  ;MFS_UNHILITE = 0

  ;Get mouse position and handle to wnd under the mouse cursor
  MouseGetPos, MouseScreenX, MouseScreenY, MouseWindowUID, MouseControlID
  WinGet,ControlHwnd, ID,ahk_id %MouseWindowUID%
  ;Get count of menu items
  ContextMenCnt := GetContextMenuCount(ControlHwnd)
  if ContextMenCnt < 1
  {
   Tooltip,
   return
  }
  TooltipText =
  TextText =
  loop, %ContextMenCnt%
  {
    StrSize := GetContextMenuText(ControlHwnd, a_index-1)
	If StrSize = Cu&t
		ChangeIconImage(a_index, 2)
	If StrSize = &Copy
		ChangeIconImage(a_index, 3)
   ; TextText = %TextText%%a_index%:%StrSize%`n
  }
  CoordMode, Tooltip, Screen
  Tooltip, %TextText%, 0, 0
return

/***************************************************************
 * returns the count of menu items
 ***************************************************************
*/
GetContextMenuCount(hWnd)
{
  WinGetClass, WindowClass, ahk_id %hWnd%
  ;All popups should have the window class #32768
  if WindowClass <> #32768
  {
   return 0
  }
  ;Retrieve menu handle from window
  SendMessage, 0x01E1, , , , ahk_id %hWnd%
  ;Errorlevel is set by SendMessage. It contains the handle to the menu
  hMenu := errorlevel
  menuitemcount:=DllCall("GetMenuItemCount",UInt,hMenu)
  Return, menuitemcount
}

/***************************************************************
 * returns the text of a menu entry (standard windows context menus only!!!)
 ***************************************************************
*/
GetContextMenuText(hWnd, Position)
{
  WinGetClass, WindowClass, ahk_id %hWnd%
  if WindowClass <> #32768
  {
   return -1
  }
  SendMessage, 0x01E1, , , , ahk_id %hWnd%
  ;Errorlevel is set by SendMessage. It contains the handle to the menu
  hMenu := errorlevel

  ;We need to allocate a struct
  VarSetCapacity(MenuItemInfo, 200, 0)
  ;Set Size of Struct (48) to the first member
  InsertInteger(48, MenuItemInfo, 0, 4)
  ;Retrieve string MIIM_STRING = 0x40 = 64 (/ MIIM_TYPE = 0x10 = 16)
  InsertInteger(64, MenuItemInfo, 4, 4)
  ;Set type - Get only size of string we need to allocate
  ;InsertInteger(0, MenuItemInfo, 8, 4)
  ;GetMenuItemInfo: Handle to Menu, Index of Position, 0=Menu identifier / 1=Index
  InfoRes := DllCall("user32.dll\GetMenuItemInfo",UInt,hMenu, Uint, Position, uint, 1, "int", &MenuItemInfo)
  if InfoRes = 0
     return -1

  InfoResError := errorlevel
  LastErrorRes := DllCall("GetLastError")
  if InfoResError <> 0
     return -1
  if LastErrorRes <> 0
     return -1

  ;Get size of string from struct
  GetMenuItemInfoRes := ExtractInteger(MenuItemInfo, 40, false, 4)
  ;If menu is empty return
  If GetMenuItemInfoRes = 0
     return "{Empty String}"

  ;+1 should be enough, we'll use 2
  GetMenuItemInfoRes += 2
  ;Set capacity of string that will be filled by windows
  VarSetCapacity(PopupText, GetMenuItemInfoRes, 0)
  ;Set Size plus 0 terminator + security ;-)
  InsertInteger(GetMenuItemInfoRes, MenuItemInfo, 40, 4)
  InsertInteger(&PopupText, MenuItemInfo, 36, 4)

  InfoRes := DllCall("user32.dll\GetMenuItemInfo",UInt,hMenu, Uint, Position, uint, 1, "int", &MenuItemInfo)
  if InfoRes = 0
     return -1

  InfoResError := errorlevel
  LastErrorRes := DllCall("GetLastError")
  if InfoResError <> 0
     return -1
  if LastErrorRes <> 0
     return -1

  return PopupText
}

; *********************************
; *********************************
; Original versions of ExtractInteger and InsertInteger provided by Chris
; - from the AutoHotkey help file - Version 1.0.37.04
; *********************************
; *********************************
ExtractInteger(ByRef pSource, pOffset = 0, pIsSigned = false, pSize = 4)
; pSource is a string (buffer) whose memory area contains a raw/binary integer at pOffset.
; The caller should pass true for pSigned to interpret the result as signed vs. unsigned.
; pSize is the size of PSource's integer in bytes (e.g. 4 bytes for a DWORD or Int).
; pSource must be ByRef to avoid corruption during the formal-to-actual copying process
; (since pSource might contain valid data beyond its first binary zero).
{
   SourceAddress := &pSource + pOffset  ; Get address and apply the caller's offset.
   result := 0  ; Init prior to accumulation in the loop.
   Loop %pSize%  ; For each byte in the integer:
   {
      result := result | (*SourceAddress << 8 * (A_Index - 1))  ; Build the integer from its bytes.
      SourceAddress += 1  ; Move on to the next byte.
   }
   if (!pIsSigned OR pSize > 4 OR result < 0x80000000)
      return result  ; Signed vs. unsigned doesn't matter in these cases.
   ; Otherwise, convert the value (now known to be 32-bit) to its signed counterpart:
   return -(0xFFFFFFFF - result + 1)
}

InsertInteger(pInteger, ByRef pDest, pOffset = 0, pSize = 4)
; To preserve any existing contents in pDest, only pSize number of bytes starting at pOffset
; are altered in it. The caller must ensure that pDest has sufficient capacity.
{
   mask := 0xFF  ; This serves to isolate each byte, one by one.
   Loop %pSize%  ; Copy each byte in the integer into the structure as raw binary data.
   {
      DllCall("RtlFillMemory", UInt, &pDest + pOffset + A_Index - 1, UInt, 1  ; Write one byte.
         , UChar, (pInteger & mask) >> 8 * (A_Index - 1))  ; This line is auto-merged with above at load-time.
      mask := mask << 8  ; Set it up for isolation of the next byte.
   }
}
; *********************************
; *********************************

PrintScreen::reload

ChangeIconImage(IconPosition, IconImage)
{
IconPosition--
hBitmap := IconImage
WinGet, hWnd, ID, ahk_class #32768
if !hWnd
	return
;WinGet, vPName, ProcessName, % "ahk_id " hWnd
;if !(vPName = "notepad.exe") && !(vPName = "explorer.exe")
;	return
SendMessage, 0x1E1, 0, 0, , ahk_class #32768 ;MN_GETHMENU
if !hMenu := ErrorLevel
	return
WinGet, vPID, PID, % "ahk_id " hWnd
;OpenProcess may not be needed to set an external menu item's icon to HBMMENU_MBAR_RESTORE
if !hProc := DllCall("OpenProcess", UInt,0x1F0FFF, Int,0, UInt,vPID, Ptr)
	return
Loop, % DllCall("GetMenuItemCount", Ptr,hMenu)
{
	vPos := IconPosition
	vSize := A_PtrSize=8?80:48
	VarSetCapacity(MENUITEMINFO, vSize, 0)
	NumPut(vSize, MENUITEMINFO, 0, "UInt") ;cbSize
	NumPut(0x80, MENUITEMINFO, 4, "UInt") ;fMask
	NumPut(hBitmap, MENUITEMINFO, A_PtrSize=8?72:44, "Ptr") ;hBitmap
	DllCall("SetMenuItemInfo", Ptr,hMenu, UInt,vPos, Int,1, Ptr,&MENUITEMINFO)
}

DllCall("CloseHandle", Ptr,hProc)
return
}
Return
