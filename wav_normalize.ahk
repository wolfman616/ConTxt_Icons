#NoEnv
#persistent
SplitPath, 1 ,, OutDir,,,
SetWorkingDir %OutDir%
temp:="c:\out\temp.wav"
test=%1%
global 2:=test
FileGetTime, Old_D8 , %1%, m
runwait %comspec% /c ffmpeg-normalize %1% --sample-rate 44000 -tp 0 -o %temp%
FileSetTime, Old_D8 , %temp%, m
FileRecycle, %1%
loop {
	if fileexist(1)
		sleep 100
	else break
	}
FileMove, %temp%, %2% , Overwrite
sleep 100
;If fileexist("%2%")
	exitapp
;else
;	loop
;	{   ;f joke i tried everything for it to re-dtect a file detection previouly succesful in being spotted on line 16
;	sleep 100
;	if fileexist("%2%")
;		break
;	}
;exit
