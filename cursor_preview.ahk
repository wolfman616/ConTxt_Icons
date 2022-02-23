#noEnv ; #warn
; #persistent
#SingleInstance force
sendMode Input
CoordMode, ToolTip, Client 
;img:="S:\Documents\My Pictures\Icons\- CuRS0R\PIANO.ANI"
;img:="S:\Documents\My Pictures\Icons\- CuRS0R\bfly.ani"
filePath:="D:\Documents\My Pictures\Icons\- CuRS0R\_ ani\Hand_New.ani"
;img:="S:\Documents\My Pictures\Icons\- CuRS0R\DB_04BUS.ANI" ; gold dripping thing
;img2:="S:\Documents\My Pictures\Icons\- CuRS0R\CY_04BUS.ANI"
if 		0 != 1 	; Not run with parameter
	img := img ; specify the file path to gif
else if 0 = 1	; run with parameter from menus
	img 	= %1%
if !(fileexist(filePath)) {
	msgbox,,% "Error",% "Cant find `n" filePath
	FileSelectFile, filePath , Options, D:\Documents\My Pictures\, Title,% "Portable Network Graphics PNG (*.png)"
}
mousegetpos x, y
tooltip % "here ..." ,x, y-80
sleep 900

SetSystemCursor(img)
sleep 2220
RestoreCursor()
tooltip
return,

ToolOff:
toolTip,
return
