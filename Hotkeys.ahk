#Requires AutoHotkey v2.0

F1:: {
    livelyExe := "C:\Program Files\Lively Wallpaper\Lively.exe"
    rainmeterExe := "C:\Program Files\Rainmeter\Rainmeter.exe"

    if DllCall("IsWindowVisible", "Ptr", WinExist("ahk_class Shell_TrayWnd")) {
        ; Taskleiste verstecken
        WinHide("ahk_class Shell_TrayWnd")
        
        ; Rainmeter verstecken
        if FileExist(rainmeterExe)
            Run('"' rainmeterExe '" !Hide *')
        
        ; Lively pausieren
        if FileExist(livelyExe)
            Run('"' livelyExe '" --play true')
    } else {
        ; Taskleiste anzeigen
        WinShow("ahk_class Shell_TrayWnd")
        
        ; Rainmeter anzeigen
        if FileExist(rainmeterExe)
            Run('"' rainmeterExe '" !Show *')
        
        ; Lively fortsetzen
        if FileExist(livelyExe)
            Run('"' livelyExe '" --play false')
    }
}