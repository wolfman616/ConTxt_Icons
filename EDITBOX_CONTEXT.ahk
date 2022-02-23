#persistent
setbatchlines -1
#singleinstance force
Menu, Tray, noStandard
Menu, Tray, Add, Open Script Folder, Open_Script_Folder,
Menu, Tray, Standard
; Global vars:
Global Win_Explorer_Class1 := "ExploreWClass"
Global Win_Explorer_Class2 := "CabinetWClass"
Global Win_Explorer_Cont1 := "CtrlNotifySink6"
Global Win_Explorer_Cont2 := "Edit2"
Global Win_Explorer_Cont3 := "Edit1"
twatface=%Win_Explorer_Cont1%,%Win_Explorer_Cont2%,%Win_Explorer_Cont3%
global nignog:=twatface
Global MenuContext_RightClickAgain := "-> MenuContext: Right Click Again instead of regular click <-" 
Global MenuContext_NoClicked_AddedItem := "-> MenuContext: Added items have not been clicked <-"
Global MenuContext_Separator := "-> MenuContext: Separator <-" 
Global MenuContext_Item := "-> MenuContext: Standard Item <-"
Global MenuContext_Submenu := "-> MenuContext: Popup Submenu <-"
RegRead, RegLast, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit\, LastKey
Global Active_Window:="",global Focused_Control_Name,global Selected_Text,global RegMatch,global RegAddress
RegNeedle:="i)(^[^\[]?)?(?:computer\\){0}(HK){1}((EY_LOCAL_MACHINE\\)|(EY_CLASSES_ROOT\\)|(CU\\)|(LM\\)|(CR\\)|(U\\)|(CC\\)){1}([\w\\.])+([^$\]]){0}"
GoogleSearchPath:="https://www.google.com/search?q=", RegistryFound:="",EVENT_OBJECT_TEXTSELECTIONCHANGED:=0x8014
EventX=%EVENT_OBJECT_TEXTSELECTIONCHANGED%
OnExit("AtExit")
AtExit() {
	global hWinEventHook, lpfnWinEventProc
	if (hWinEventHook)
		DllCall("UnhookWinEvent", "Ptr", hWinEventHook), hWinEventHook := 0
	if (lpfnWinEventProc)
		DllCall("GlobalFree", "Ptr", lpfnWinEventProc, "Ptr"), lpfnWinEventProc := 0	
	return 0
	}

hWinEventHook := DllCall("SetWinEventHook", "UInt", EventX, "UInt", EventX, "Ptr", 0, "Ptr", (lpfnWinEventProc := RegisterCallback("OnEventX", "")), "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002)

OnEventX(hWinEventHook, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
	WinGet, Active_Window, ID , A
	ControlGetFocus, Focused_Control_Name , ahk_id %Active_Window%
	ControlGet, Selected_Text, Selected ,, %Focused_Control_Name%, "ahk_id %Active_Window%"
	;tooltip %Selected_Text% :: Event : %event% ::`nidObject: %idObject% ::
	gosub RegistryStringFind
	}

~RButton::  ; Get handle and class of current MouseWindow
MouseGetPos,,, MouseWinHwnd, OutputVarControl 
WinGetClass ClassMouseWinHwnd, ahk_id %MouseWinHwnd%
Return

~RButton up::   ; Hook Right Click;if (OutputVarControl=Win_Explorer_Cont1) || (OutputVarControl=Win_Explorer_Cont2) || (ClassMouseWinHwnd="#32768") { ;works;if (OutputVarControl in nignog) ;doesnt work;if OutputVarControl in Edit1,Edit2,CtrlNotifySink6 ; works;
if OutputVarControl in %Win_Explorer_Cont1%,%Win_Explorer_Cont2%,%Win_Explorer_Cont3%
{
	IfWinActive, ahk_class #32768; || (ClassMouseWinHwnd="#32768")
	{
		Sleep 20 ; wait context manu destruction
	}
	SetTimer Label_MenuContext_Explorer, -1
	Return
}
Else, Return

RegistryStringFind:
if (RegistryFound:= RegExMatch(Selected_Text, RegNeedle, RegMatch)) {
	RegAddress=Computer\%RegMatch%
	tooltip % regaddress,,,2
} Return

Label_MenuContext_Explorer: 
sleep 20
AddItem_Google := "Google"
AddItem_Capitalise := "Capitalise"

; Position of items in the menu:
InsertOrderPos := 1 ; Here just after the 1st standard item: 'Open'
My_Menu_Items := { } ; init array 

;My_Menu_Items.Push( Fct_MenuContext_Separator() )  ; Separator

My_Menu_Items.Push( Fct_MenuContext_Item( AddItem_Capitalise ))
My_Menu_Items.Push( Fct_MenuContext_Item( AddItem_Google ))

;Submenu, with an array of Subitems:

/* 
My_Menu_Items.Push( Fct_MenuContext_Submenu( "Say Hello" ; Name of submenu ; And Array of Items:
	,[ AddItem_Hello1 		; 1st Item
	, MenuContext_Separator 	; Separator...
	, AddItem_Hello2
	, AddItem_Hello3
	, "Test" ] ) )
 */

My_Menu_Items.Push( Fct_MenuContext_Separator() ) 
TargetProgram_Classes := [ Win_Explorer_Class1, Win_Explorer_Class2 ]

; Function that add the items to the context menu, and return the clicked item
ClickedItem := Fct_Get_ClickedItem_MenuContext_AddedItems( TargetProgram_Classes, InsertOrderPos, My_Menu_Items* )

If ( ClickedItem = AddItem_Capitalise ) {
	Capitalised:=Regexreplace(Selected_Text,"((_)|(\b\w))(.*?)","$U1$2") ;
sleep 200
setbatchlines 20
Send %Capitalised% 
setbatchlines -1
}

Else If ( ClickedItem = AddItem_Google ) {
	ReplacedStr := StrReplace(Selected_Text, " " , "%20")
	GoogleString=%GoogleSearchPath%%ReplacedStr%
	Run chrome.exe %GoogleString% " --new-tab "
	}

Else If ( ClickedItem = MenuContext_NoClicked_AddedItem ) 
	Return

Else If ( SubStr( ClickedItem, 1, 2 ) =  "->" ) ; Error
	Return

Else If ( ClickedItem = False )
	Return

Else 
	MsgBox % ClickedItem

Return ; End Label_Menu_Context_Explorer

Fct_MenuContext_Separator() {
	Return { Type: MenuContext_Separator }
	}

Fct_MenuContext_Item( Name ) {
	Return { Type: MenuContext_Item, Name: Name }
	}

Fct_MenuContext_Submenu( Name, ArraySubitems ) {
	Return { Type: MenuContext_SubMenu, Name: Name, Items: ArraySubitems }
	}

Fct_Get_ClickedItem_MenuContext_AddedItems( TargetProgram_Classes, InsertItemsAt_Position, ArrayOf_Items* ){
For each, ProgramClass in TargetProgram_Classes 
	If Program_Handle := WinActive( "ahk_class " ProgramClass ) ; Handle return false if class it's not active
		Break ; Program is active, then OK
; Check we are really in the right active program:
If not Program_Handle ; False or Handle
	Return "-> Not into the right program <-"	
	
		; Class #32768 is for all standard windows context menu:
	Global MenuContext_AhkClass := "ahk_class #32768" 
		; Wait context menu appears:
	WinWait, %MenuContext_AhkClass% ;
		; Context menu opened –> Get handle:
	MN_GETHMENU := 0x1E1 ; Shell Constant: "Menu_GetHandleMenu"
	SendMessage, MN_GETHMENU, False, False 
	MenuContext_Handle := ErrorLevel ; Return Handle in ErrorLevel
		
	;***************************
	; 	Section: Entries:
	;***************************
	; Constants for menus in User32.dll:
	Static MF_SEPARATOR := 0x800
	Static MF_STRING := 0x0
	Static MF_POPUP := 0x10
	Static MF_BYPOSITION := 0x400 
	
	; Add each new item into the context menu:
	For each, ItemToAdd in ArrayToAdd_Items :=  ArrayOf_Items
	{
		; Save absolut position of this Item in the menu: 
		ItemToAdd.Position := InsertItemsAt_Position-1 + A_Index-1 ; Zero based
		
		; Add Separator:
		If ( ItemToAdd.Type == MenuContext_Separator ) 
		{
			; Insert Separator: –> https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-InsertMenuA
			DllCall( "User32\InsertMenu"
					,"UPtr", MenuContext_Handle
					,"UInt", ItemToAdd.Position ; At the specified position
					,"UInt", MF_SEPARATOR + MF_BYPOSITION
					,"UPtr", False
					,"UInt", False )
		}
		
		; Add Classic Item:
		Else If ( ItemToAdd.Type == MenuContext_Item )
		{
			; Insert text of item: –> https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-InsertMenuA
			DllCall( "User32\InsertMenu" 
					,"UPtr", MenuContext_Handle
					,"UInt", ItemToAdd.Position ; At the specified position
					,"UInt", MF_STRING + MF_BYPOSITION
					,"UPtr", False 
					,"Str", ItemToAdd.Name ) ; Insert Value ( text )
		}
		
		; Add Submenu and its Subitems:
		Else If ( ItemToAdd.Type == MenuContext_Submenu )
		{
			AddSubmenu := ItemToAdd ; Renames to clarify
			; Create Submenu, and return handle:
			AddSubmenu.Handle := DllCall( "User32\CreatePopupMenu" ) 
			
			; Insert Submenu into the context menu: –> https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-InsertMenuA
			DllCall( "User32\InsertMenu"
					,"UPtr", MenuContext_Handle
					,"UInt", AddSubmenu.Position  ; At the specified position
					,"UInt", MF_STRING + MF_BYPOSITION + MF_POPUP
					,"UPtr", AddSubmenu.Handle
					,"Str", AddSubmenu.Name )
			
			; Now add each Item and Separator into this Submenu:
			For each, ItemOfSubmenu in AddSubmenu.Items 
			{
				; AppendMenu –> https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-AppendMenuA
				
				; In case of Separator:
				If ( ItemOfSubmenu == MenuContext_Separator ) 
					DllCall( "User32\AppendMenu"
							,"UPtr", AddSubmenu.Handle
							,"UInt", MF_SEPARATOR
							,"UPtr", False, "UInt", False )
				
				Else  ; In case of Subintem: insert Value as text:
					DllCall( "User32\AppendMenu"
							,"UPtr", AddSubmenu.Handle
							,"UInt", MF_STRING
							,"UPtr", False
							,"Str", ItemOfSubmenu )
			}
		}
		Continue ; Continue to add next item...
	}
	; End for each add items
	
	
	;***************************
	; 	Section: Wait Click:
	;***************************
Label_Wait_New_Click: ; When User clicks on Separator: wait new click
If GetKeyState( "RButton" )
	Return MenuContext_RightClickAgain ; Then refill the menu
CoordMode, Mouse, Screen
MouseGetPos, MouseScreenX, MouseScreenY  ; Int vars: 4 octets
MousePointScreen := x := MouseScreenX  | y := ( MouseScreenY << 32 ) 
WinDPIMultiplicator := A_ScreenDPI / 96  ; 96 is the standard DPI screen: 1K (1600x900)
For each, AddedItemInMenu in ArrayOfAdded_Items := ArrayOf_Items 
{
	; Click on Separator –> Disable:
	If ( AddedItemInMenu.Type == MenuContext_Separator )
	{	
		VarSetCapacity( ItemRectangle, 16, 0 ) ; Create Rectangle of 16 octets: 4 corners of Int (4 octets)
		;Fill Rectangle: –> https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-GetMenuItemRect
		isFilledRectangle := DLLCall( "User32\GetMenuItemRect"
			,"UPtr", Program_Handle
			,"UPtr", MenuContext_Handle
			,"UInt", AddedItemInMenu.Position ; Absolut position in the context menu
			,"UPtr", &ItemRectangle )
			If isFilledRectangle 
				and isPointIntoRectangle := DllCall( "User32\PtInRect", "UPtr", &ItemRectangle, "Int64", MousePointScreen )
					Goto Label_Wait_New_Click 
	}
	Else If ( AddedItemInMenu.Type == MenuContext_Item )	;Returnvalue =added Item
	{
		VarSetCapacity( ItemRectangle, 16, 0 )
		isFilledRectangle := DLLCall( "User32\GetMenuItemRect"	; https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-GetMenuItemRect
			,"UPtr", Program_Handle
			,"UPtr", MenuContext_Handle
			,"UInt", AddedItemInMenu.Position 
			,"UPtr", &ItemRectangle )
		If isFilledRectangle 
			and isPointIntoRectangle := DllCall( "User32\PtInRect", "UPtr", &ItemRectangle, "Int64", MousePointScreen ) 
				Return AddedItemInMenu.Name
	}
	; Click on Item of Submenu –> Check each Subitem:
	Else If ( AddedItemInMenu.Type == MenuContext_Submenu )  				
	{
		Loop 3; 3 times, because random reason:
		For each, ItemInSubmenu in ( ItemIsSubmenu := AddedItemInMenu ).Items 
		{
			ItemPositionInMenu := A_Index
			VarSetCapacity( ItemRectangle, 16, 0 ) 
			; https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-GetMenuItemRect
			isFilledRectangle := DLLCall( "User32\GetMenuItemRect"	; Getrect for subitem
				,"UPtr", False ; Indicate Submenu, instead of window
				,"UPtr", ItemIsSubmenu.Handle ; Handle of the Submenu
				,"UInt", ItemPositionInMenu -1 ; Zero based
				,"UPtr", &ItemRectangle )
			; Get each corner of Rectangle:
			ItemRectangleX1 := NumGet( &ItemRectangle, 0, "Int" ) ; Int –> 4 octets
			ItemRectangleY1 := NumGet( &ItemRectangle, 4, "Int" )
			ItemRectangleX2 := NumGet( &ItemRectangle, 8, "Int" )
			ItemRectangleY2 := NumGet( &ItemRectangle, 12, "Int" )
			; Use DPI multiplicator for special screen (2K, 4K, ...):
			isMouseInto4Corners :=  ( MouseScreenX >= ItemRectangleX1 *WinDPIMultiplicator ) 
				and ( MouseScreenX <= ItemRectangleX2 *WinDPIMultiplicator ) 
					and ( MouseScreenY >= ItemRectangleY1 *WinDPIMultiplicator ) 
						and ( MouseScreenY <= ItemRectangleY2 *WinDPIMultiplicator ) 
			;ToolTip % "isFilledRectangle: " isFilledRectangle "`n" "isMouseInto4Corners: " isMouseInto4Corners "`nX: " ItemRectangleX1*WinDPIMultiplicator "<" MouseScreenX ">" ItemRectangleX2*WinDPIMultiplicator "`nY: " ItemRectangleY1*WinDPIMultiplicator "<" MouseScreenY ">" ItemRectangleY2*WinDPIMultiplicator, , , 5
			; Check if mouse is into this Rectangle: 
			If isFilledRectangle and isMouseInto4Corners
			{
				; Click on Separator ?
				If ( ItemInSubmenu == MenuContext_Separator ) ; Disable Separator:
					Goto Label_Wait_New_Click ; Wait new click
				Else, Return ItemInSubmenu ; Return value of item
			}
		}
	}
		; End of one item: this is not this item
		Continue ; Then check next item...
}
	Return MenuContext_NoClicked_AddedItem
}

Open_Script_Folder:
Run %A_ScriptDir%
Return

