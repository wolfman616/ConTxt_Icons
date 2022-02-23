#NoEnv
; #Warn
#persistent
SendMode Input
SetWorkingDir %A_ScriptDir%
#NoEnv
#SingleInstance, Force
Menu, Tray, Add, Options, Options_,
gui, Options_:new , , Options
gui +HwndOptionsHwnd

gui, Add, checkbox, vSetGlobalModifier , SetGlobalModifier key
    Gui, Add, Hotkey, wp vHotkey gHotkeyEvent w100 h21 0x200

gui, add, button, Default w80, OK
return


options_:
	gui, Show , Center, Options	
return
GuiClose:
gosub HotkeyEvent
Return ; end of auto-execute section

;-------------------------------------------------------------------------------
HotkeyEvent:
;-------------------------------------------------------------------------------
if hotkey 
{
hotkeycurrent=%hotkey%
			hotkeyold:=hotkey
		} 
else	
{
						if hotkeyold
				hotkeycurrent=%hotkeyold%
else
			hotkeycurrent=%hotkey%

		}

Hotkey, %hotkeycurrent%, myLabel

  ;Hotkey, %Hotkey2%, MouseSlow
    ;Hotkey %Hotkey2% Up, MouseNormal
Return

onExit 
    Gui, Destroy
ExitApp

myLabel:
toolTIP % hotkeycurrent "Cunt" 
return
;-------------------------------------------------------------------------------
SliderEvent: ; slider changes come here
;-------------------------------------------------------------------------------
    GuiControlGet, Slider ; get new value for Slider
    GuiControl,, Text, %Slider%
Return
;-------------------------------------------------------------------------------
AimControl(a, s) { ; control mouse speed
;-------------------------------------------------------------------------------
    Static OrigMouseSpeed := 10, CurrentMouseSpeed := DllCall("SystemParametersInfo", UInt, 0x70, UInt, 0, UIntP, OrigMouseSpeed, UInt, 0)
    DllCall("SystemParametersInfo", UInt, 0x71, UInt, 0, Ptr, a ? (s>0 AND s<=20 ? s : 10) : OrigMouseSpeed, UInt, 0)
}
;-------------------------------------------------------------------------------
MouseSlow: ; use slow mouse speed
;-------------------------------------------------------------------------------
    AimControl(1, Slider)
Return
;-------------------------------------------------------------------------------
MouseNormal: ; use normal mouse speed
;-------------------------------------------------------------------------------
    AimControl(0, 0)
Return


SetGlobalModifier:
tooltip cunt
return