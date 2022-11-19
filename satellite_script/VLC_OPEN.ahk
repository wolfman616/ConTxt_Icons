#noEnv
#persistent
run, "C:\Program Files (x86)\VideoLAN\VLC\vlc.exe" --started-from-file "%1%"
winwait, ahk_exe vlc.exe
activ8:
WinGet, hwnd, ID , ahk_class Qt5QWindowIcon
winactivate, ahk_id %hwnd% ;
winGet, process, processName, % "ahk_id" hWnd := hWnd?hWnd:WinExist("A")
if !(process = "vlc.exe") {
	tooltip retrying
	settimer activ8, -500
	return
} else {
	tooltip % ":)"
	win_move(hwnd,,,900,740,"")
	sleep 330
	win_move(hwnd,,,900,740,"")
	exitapp
}
