#noEnv
run, "C:\Program Files\ImageGlas5\ImageGlass.exe" "%1%",,Hide
loop {
	if (as:=Winexist((ee:="ahk_EXE ImageGlass.exe"))) {
		winactivate, 	ahk_id 	%as%
		if !(as := (az:=winexist("A")))
			Tooltip,% "Fail " fail += 1
		else return,
	} else, sleep, 100
	if a_index > 1000
		msgbox, 1, % "error opening image file",% 1 "`nRetry?"
		ifmsgbox, yes
			reload
}
exitapp
