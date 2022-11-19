#NoEnv 
SetWorkingDir %A_ScriptDir%
menu tray, icon, C:\Icon\20\7zip.ico
inputfile="%1%"
splitpath, 1, Filename, Dir, Extension, NameNoExt, Drive
runwait %comspec% /c C:\Apps\optipng-0.7.7-win32\optipng.exe -o7  %inputfile%
traytip, OptiPNG, Finished Crunching