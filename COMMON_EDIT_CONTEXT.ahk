; « Right Click Mouse Button » –> Context menu opening, then modify it:
;***********************************************************************
~RButton::   ; Hook Right Click

; 2 Classes for explorer:
Global Win_Explorer_Class1 := "ExploreWClass" ; New Class
Global Win_Explorer_Class2 := "CabinetWClass" ; Old Class

; Witch active program is it ?
WinGetClass, ClassCurrentWindow, A ; Get class of current Window

; Here we need: explorer.exe
If ( ClassCurrentWindow = Win_Explorer_Class1 ) or ( ClassCurrentWindow = Win_Explorer_Class2 ) ; 2 classes for explorer
	Goto Label_MenuContext_Explorer 

Return ; End of Right Click
;**************************



Label_MenuContext_Explorer: 
;***************************

; Global vars:
Global MenuContext_RightClickAgain := "-> MenuContext: Right Click Again instead of regular click <-" 
Global MenuContext_NoClicked_AddedItem := "-> MenuContext: Added items have not been clicked <-"
Global MenuContext_Separator := "-> MenuContext: Separator <-" 
Global MenuContext_Item := "-> MenuContext: Standard Item <-"
Global MenuContext_Submenu := "-> MenuContext: Popup Submenu <-"

;Value of items to add:
AddItem_Hello1 := "Hi!"
AddItem_Hello2 := "Bonjour"
AddItem_Hello3 := "Buenos dias"
AddItem_Hello4 := "Hallo"
AddItem_Folder := "Parent's Folder"

; Position of items in the menu:
InsertItemsAtPosition := 2 ; Here just after the 1st standard item: 'Open'

ArrayToAddItems := { } ; Object as array of items to add into the context menu

; Add items to array:

ArrayToAddItems.Push( Fct_MenuContext_Separator() )  ; Separator

ArrayToAddItems.Push( Fct_MenuContext_Item( "Welcome" ) ) ; Standard item

ArrayToAddItems.Push( Fct_MenuContext_Item( AddItem_Folder ) ) ; Standard item

ArrayToAddItems.Push( Fct_MenuContext_Separator() ) 

;Submenu, with an array of Subitems:
ArrayToAddItems.Push( Fct_MenuContext_Submenu( "Say Hello" ; Name of submenu ; And Array of Items:
	,[ AddItem_Hello1 		; 1st Item
	, MenuContext_Separator 	; Separator...
	, AddItem_Hello2
	, AddItem_Hello3
	, AddItem_Hello4
	, "Test" ] ) )

ArrayToAddItems.Push( Fct_MenuContext_Separator() ) 

TargetProgram_Classes := [ Win_Explorer_Class1, Win_Explorer_Class2 ]



; Function that add the items to the context menu, and return the clicked item
ClickedItem := Fct_Get_ClickedItem_MenuContext_AddedItems( TargetProgram_Classes, InsertItemsAtPosition, ArrayToAddItems* )



If ( ClickedItem = MenuContext_RightClickAgain )
	Goto Label_MenuContext_Explorer ; When User do right click again, We must rebuild the items 

Else If ( ClickedItem = AddItem_Folder ) {
	SplitPath, A_ScriptDir, , ParentFolder
	Run, %ParentFolder%
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
;******
