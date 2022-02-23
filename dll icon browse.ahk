  IconFile=%1%
    If ErrorLevel || (IconFile = ""){
    	Msgbox, There must be a defined icon file to run.`nThis program will now close.
    	ExitApp
    }
    KsIcon=1
    ;Menu, Tray, Icon, %IconFile%, %KsIcon%, 1
    CustomColor = EEAA99  
    Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  
    Gui, Color, %CustomColor%
    Gui, Font, s70 
    Gui, Add, Text, Vpos clime, XXXX 
    Winset, Transcolor, %CustomColor% 150
    Settimer, Display, 200
    Gui, Show,  x950 y810 Noactivate  
     
    Return
    PgUp::
    	KsIcon ++
    	Menu, Tray, Icon, %IconFile%, %KsIcon%, 1
    	return
    PgDn::
    	if (KsIcon = 1){
    		return
    	}
    	KsIcon --
    	Menu, Tray, Icon, %IconFile%, %KsIcon%, 1
    	return
    	
    Display:
    	GuiControl,, Pos, %KsIcon%
    	return