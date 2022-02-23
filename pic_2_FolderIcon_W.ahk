pic_2_icon.ico 
#persistent
;menu, tray, icon, pic2icon.ico
#singleinstance force
RESIZE=256,128,64,32,16
splitpath 1, inFileName, inDir, inExtension, inNameNoExt, inDrive
SetWorkingDir %indir%
filecopy, %1%, %indir%\BLAH.%inExtension%
outdir=%indir%\
Input_File=out\BLAH.%inExtension%
out3=c:\out\output.png
out5=c:\out\%A_Now%.ico

PNG_Create:
/* 
..\convert Agent-96.png -resize 80% Agent-small.png
..\convert Unlock-96.png -trim +repage Unlock-96-trim.png
..\convert Unlock-96-trim.png -resize 50%%  -bordercolor none -border 5 Unlock-small.png
..\convert Unlock-96-trim.png -resize 50%% Unlock-small-border.png
..\convert Unlock-small-border.png -bordercolor none -border 5 -background red -alpha background -channel A -blur 4x5 -level 0,01%% +channel Unlock-small-border.png

..\convert -size 96x96 xc:"rgba(0,0,0,0)" PNG24:Agent-Unlock.png

..\convert Agent-Unlock.png Agent-small.png ^
          -geometry +0+0   -composite Agent-Unlock.png

..\composite -compose Dst_Out -gravity SouthEast ^
             Unlock-small-border.png Agent-Unlock.png -alpha Set Agent-Unlock.png
 */

Runwait, %comspec% /c convert BLAH.%inExtension% -resize "256x256^" -gravity west -crop 256x256+0+0 +repage -alpha Set -background none -vignette 0x10-10-10 +repage -depth 8  %out3%
/* 
\composite -compose Dst_Out -gravity center ^
             %out3% Agent-Unlock.png -alpha Set Agent-Unlock.png
 */
PNG_eXist:
try 
	{
	if FileExist(out3)
	RunWait, %comspec% /c convert %out3% -define icon:auto-resize=%resize% %out5%
	}
catch
	{
	sleep 50
	gosub PNG_eXist
	}
FileDelete blah.%inExtension%
FileDelete %out3%
DESKTOP_INI:
FileName=%outdir%desktop.ini
if FileExist(FileName) {
	IniRead, OldIcon, %FileName%, .ShellClassInfo, IconResource
if Found_Previous_Pic2Icon:=regexmatch(OldIcon,"i)(out)") {
	OldIcon:=regexreplace(OldIcon, "(,[0-9]{1,4})","")
	FileDelete %OldIcon%
	}
FileDelete %FileName%
}
Section1:=".ShellClassInfo", Section2 := "ViewState", Section3 := "ViewState", Section4 := "ViewState", Key1:= "IconResource", Key2 := "Mode", Key3 := "Vid", Key4 := "FolderType", Value2 := "", Value3 := "", Value4 := "Pictures"
Value1=%out5%,0
IniWrite, %Value1%, %FileName%, %Section1%, %Key1%
IniWrite, %Value2%, %FileName%, %Section2%, %Key2%
IniWrite, %Value3%, %FileName%, %Section3%, %Key3%
IniWrite, %Value4%, %FileName%, %Section4%, %Key4%
Sleep, 250
FileMoveDir, %outdir%, %outdir% , R
Sleep, 50
FileSetAttrib, +SH, %FileName%,0,0
Sleep, 50
FileSetAttrib, +S, %indir%,2,0
Sleep, 100
FileMoveDir, %outdir%, %outdir%
Sleep, 100
FileMoveDir, %outdir%, %outdir% , R
Sleep, 500
run %comspec% /c ie4uinit.exe -show
Sleep, 50
exitapp
