@echo off
chcp 65001 >nul
title MCRice Manager - Interaktiver Assistent

:: Administrator-Rechte prüfen
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Bitte starte dieses Skript als Administrator!
    pause
    exit /b
)

:MENU
cls
echo ===================================================
echo              MCRice Interaktiver Manager
echo ===================================================
echo [1] Installieren / Einrichten
echo [2] Aktivieren (Prüfen ^& Wiederherstellen)
echo [3] Deinstallieren
echo [4] Deaktivieren
echo [5] Beenden
echo ===================================================
set /p "choice=Wähle eine Option (1-5): "

if "%choice%"=="1" goto INSTALLIEREN
if "%choice%"=="2" goto AKTIVIEREN
if "%choice%"=="3" goto DEINSTALLIEREN
if "%choice%"=="4" goto DEAKTIVIEREN
if "%choice%"=="5" exit
goto MENU

:INSTALLIEREN
cls
echo ===================================================
echo  SCHRITT 1: Software prüfen ^& installieren
echo ===================================================
echo.

:: 1. Windhawk prüfen
echo Prüfe Windhawk...
if exist "%PROGRAMFILES%\Windhawk\windhawk.exe" (
    echo [OK] Windhawk ist vorhanden.
) else if exist "%PROGRAMFILES(X86)%\Windhawk\windhawk.exe" (
    echo [OK] Windhawk ist vorhanden.
) else (
    echo [!] Windhawk wurde nicht gefunden. Installiere...
    winget install --id Rampress.Windhawk -e --accept-source-agreements --accept-package-agreements
)

:: 2. Lively Wallpaper prüfen
echo.
echo Prüfe Lively Wallpaper...
if exist "%LOCALAPPDATA%\Programs\Lively Wallpaper\Lively.exe" (
    echo [OK] Lively Wallpaper ist vorhanden.
) else if exist "%PROGRAMFILES%\Lively Wallpaper\Lively.exe" (
    echo [OK] Lively Wallpaper ist vorhanden.
) else (
    echo [!] Lively Wallpaper wurde nicht gefunden. Installiere...
    winget install --id rocksdanister.LivelyWallpaper -e --accept-source-agreements --accept-package-agreements
)

:: 3. AutoHotkey v2 prüfen
echo.
echo Prüfe AutoHotkey v2...
if exist "%PROGRAMFILES%\AutoHotkey\v2\AutoHotkey64.exe" (
    echo [OK] AutoHotkey v2 ist vorhanden.
) else if exist "%PROGRAMFILES%\AutoHotkey\AutoHotkeyUX.exe" (
    echo [OK] AutoHotkey v2 ist vorhanden.
) else (
    echo [!] AutoHotkey v2 wurde nicht gefunden. Installiere...
    winget install --id AutoHotkey.AutoHotkey -e --accept-source-agreements --accept-package-agreements
)

:: 4. Rainmeter prüfen
echo.
echo Prüfe Rainmeter...
if exist "%PROGRAMFILES%\Rainmeter\Rainmeter.exe" (
    echo [OK] Rainmeter ist vorhanden.
) else if exist "%PROGRAMFILES(X86)%\Rainmeter\Rainmeter.exe" (
    echo [OK] Rainmeter ist vorhanden.
) else (
    echo [!] Rainmeter wurde nicht gefunden. Installiere...
    winget install --id Rainmeter.Rainmeter -e --accept-source-agreements --accept-package-agreements
)

echo.
pause

:STEP2
cls
echo ===================================================
echo  SCHRITT 2: Autostart ^& Lively Wallpaper Einrichtung
echo ===================================================
echo.

:: Rainmeter Autostart prüfen und anlegen
set "RAINMETER_LINK=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Rainmeter.lnk"
if not exist "%RAINMETER_LINK%" (
    echo Erstelle Autostart-Eintrag für Rainmeter...
    powershell -Command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%RAINMETER_LINK%'); $s.TargetPath='%PROGRAMFILES%\Rainmeter\Rainmeter.exe'; $s.Save()" >nul 2>&1
) else (
    echo Rainmeter ist bereits im Autostart vorhanden.
)

echo.
echo Der URL-Link 'https://classic.minecraft.net' wird in deine ZWISCHENABLAGE kopiert.
echo https://classic.minecraft.net| clip

echo.
echo -> ANWEISUNG FÜR LIVELY WALLPAPER:
echo    1) Öffne Lively Wallpaper.
echo    2) Gehe in die Einstellungen von Lively Wallpaper und aktiviere unter 'Allgemein' die Option 'Mit Windows starten'.
echo    3) Klicke auf 'Wallpaper hinzufügen' (+ Icon).
echo    4) Drücke Strg + V im URL-Feld, um 'https://classic.minecraft.net' einzufügen.
echo    5) Klicke auf den Pfeil rechts vom URL-Feld.
echo    6) Drücke auf OK.
echo.
pause

:STEP3
cls
echo ===================================================
echo  SCHRITT 3: Dateien von GitHub herunterladen
echo ===================================================
echo.
if not exist "%TEMP%\MCRice" mkdir "%TEMP%\MCRice"

echo Lade Konfigurationsdateien herunter...
echo.

echo [1/6] windows-11-taskbar-styler.txt:
curl -L -# "https://raw.githubusercontent.com/Thillager/MCRice/main/windows-11-taskbar-styler.txt" -o "%TEMP%\MCRice\windows-11-taskbar-styler.txt"

echo [2/6] icon-resource-redirect.txt:
curl -L -# "https://raw.githubusercontent.com/Thillager/MCRice/main/icon-resource-redirect.txt" -o "%TEMP%\MCRice\icon-resource-redirect.txt"

echo [3/6] windows-11-settings-styler.txt:
curl -L -# "https://raw.githubusercontent.com/Thillager/MCRice/main/windows-11-settings-styler.txt" -o "%TEMP%\MCRice\windows-11-settings-styler.txt"

echo [3/6] windows-11-start-menu-styler.txt:
curl -L -# "https://raw.githubusercontent.com/Thillager/MCRice/main/windows-11-start-menu-styler.txt" -o "%TEMP%\MCRice\windows-11-start-menu-styler.txt"

echo [5/6] Hotkeys.ahk:
curl -L -# "https://raw.githubusercontent.com/Thillager/MCRice/main/Hotkeys.ahk" -o "%TEMP%\MCRice\Hotkeys.ahk"

echo [6/6] Thillagers Block Hud_1.0.0.rmskin:
curl -L -# "https://raw.githubusercontent.com/Thillager/MCRice/main/Thillagers%%20Block%%20Hud_1.0.0.rmskin" -o "%TEMP%\MCRice\Thillagers Block Hud_1.0.0.rmskin"

echo.
echo Alle Downloads abgeschlossen!
pause

:SCHRITT_WINDHAWK_1
cls
echo ===================================================
echo  SCHRITT 4: Windhawk - Windows 11 Taskbar Styler
echo ===================================================
echo.
echo Die Konfiguration für "Windows 11 Taskbar Styler" wurde kopiert!
type "%TEMP%\MCRice\windows-11-taskbar-styler.txt" | clip

echo.
echo ANWEISUNG:
echo 1. Öffne Windhawk und klicke oben rechts auf 'Durchsuchen'.
echo 2. Gib die Mod ID 'windows-11-taskbar-styler' ein und füge die Mod hinzu.
echo 3. Klicke bei der Mod auf 'Details' und gehe zu den 'Einstellungen'.
echo 4. Schalte auf 'Textual mode' um.
echo 5. Ersetze den gesamten Text dort durch den Inhalt aus deiner Zwischenablage (STRG + A, dann STRG + V) und speichere.
echo.
pause

:SCHRITT_WINDHAWK_2
cls
echo ===================================================
echo  SCHRITT 5: Windhawk - Icon Resource Redirect
echo ===================================================
echo.
echo Die Konfiguration für "Icon Resource Redirect" wurde kopiert!
type "%TEMP%\MCRice\icon-resource-redirect.txt" | clip

echo.
echo ANWEISUNG:
echo 1. Klicke in Windhawk oben rechts auf 'Durchsuchen'.
echo 2. Gib die Mod ID 'icon-resource-redirect' ein und füge die Mod hinzu.
echo 3. Klicke bei der Mod auf 'Details' und gehe zu den 'Einstellungen'.
echo 4. Schalte auf 'Textual mode' um.
echo 5. Ersetze den gesamten Text dort durch den Inhalt aus deiner Zwischenablage (STRG + A, dann STRG + V) und speichere.
echo.
pause

:SCHRITT_WINDHAWK_3
cls
echo ===================================================
echo  SCHRITT 6: Windhawk - Windows 11 Settings Styler
echo ===================================================
echo.
echo Die Konfiguration für "Windows 11 Settings Styler" wurde kopiert!
type "%TEMP%\MCRice\windows-11-settings-styler.txt" | clip

echo.
echo ANWEISUNG:
echo 1. Klicke in Windhawk oben rechts auf 'Durchsuchen'.
echo 2. Gib die Mod ID 'windows-11-settings-styler' ein und füge die Mod hinzu.
echo 3. Klicke bei der Mod auf 'Details' und gehe zu den 'Einstellungen'.
echo 4. Schalte auf 'Textual mode' um.
echo 5. Ersetze den gesamten Text dort durch den Inhalt aus deiner Zwischenablage (STRG + A, dann STRG + V) und speichere.
echo.
pause

:SCHRITT_WINDHAWK_4
cls
echo ===================================================
echo  SCHRITT 6: Windhawk - Windows 11 Startmenu Styler
echo ===================================================
echo.
echo Die Konfiguration für "Windows 11 Startmenu Styler" wurde kopiert!
type "%TEMP%\MCRice\windows-11-start-menu-styler.txt" | clip

echo.
echo ANWEISUNG:
echo 1. Klicke in Windhawk oben rechts auf 'Durchsuchen'.
echo 2. Gib die Mod ID 'windows-11-start-menu-styler' ein und füge die Mod hinzu.
echo 3. Klicke bei der Mod auf 'Details' und gehe zu den 'Einstellungen'.
echo 4. Schalte auf 'Textual mode' um.
echo 5. Ersetze den gesamten Text dort durch den Inhalt aus deiner Zwischenablage (STRG + A, dann STRG + V) und speichere.
echo.
pause

:SCHRITT_RAINMETER
cls
echo ===================================================
echo  SCHRITT 8: Rainmeter Skin
echo ===================================================
echo.
echo Starte den Skin "Thillagers Block Hud"...
start "" "%TEMP%\MCRice\Thillagers Block Hud_1.0.0.rmskin"

echo.
echo ANWEISUNG:
echo Im geöffneten Rainmeter-Fenster einfach auf "Install" klicken, 
echo um den Skin zu aktivieren.
echo.
pause

:SCHRITT_HOTKEYS
cls
echo ===================================================
echo  SCHRITT 9: Hotkeys.ahk Autostart
echo ===================================================
echo.
echo Kopiere Hotkeys.ahk in den Autostart-Ordner...
copy /y "%TEMP%\MCRice\Hotkeys.ahk" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Hotkeys.ahk" >nul
start "" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Hotkeys.ahk"

if not exist "%USERPROFILE%\.mcrice_backup" mkdir "%USERPROFILE%\.mcrice_backup"
copy /y "%TEMP%\MCRice\*.txt" "%USERPROFILE%\.mcrice_backup\" >nul

echo.
echo Fertig! Hotkeys wurden gestartet und für den Autostart eingerichtet.
echo.
pause
goto MENU

:AKTIVIEREN
cls
echo Prüfe Autostart-Einträge und Komponenten...

if not exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Hotkeys.ahk" (
    if exist "%USERPROFILE%\.mcrice_backup\Hotkeys.ahk" (
        copy /y "%USERPROFILE%\.mcrice_backup\Hotkeys.ahk" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Hotkeys.ahk" >nul
        start "" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Hotkeys.ahk"
        echo - Hotkeys.ahk wieder in Autostart kopiert.
    )
) else (
    echo - Hotkeys.ahk ist bereits im Autostart.
)

if not exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Rainmeter.lnk" (
    powershell -Command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Rainmeter.lnk'); $s.TargetPath='%PROGRAMFILES%\Rainmeter\Rainmeter.exe'; $s.Save()" >nul 2>&1
    echo - Rainmeter Verknüpfung im Autostart angelegt.
) else (
    echo - Rainmeter ist bereits im Autostart.
)

echo.
echo Überprüfung abgeschlossen.
pause
goto MENU

:DEINSTALLIEREN
cls
echo Deinstalliere MCRice-spezifische Dateien...
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Hotkeys.ahk" del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Hotkeys.ahk"
if exist "%USERPROFILE%\.mcrice_backup" rmdir /s /q "%USERPROFILE%\.mcrice_backup"
if exist "%TEMP%\MCRice" rmdir /s /q "%TEMP%\MCRice"
echo.
echo MCRice-Skripte und Autostart-Einträge wurden gelöscht.
echo (Vorhandene Software wie Lively oder Windhawk bleibt unberührt).
pause
goto MENU

:DEAKTIVIEREN
cls
echo Deaktiviere MCRice...
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Hotkeys.ahk" del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Hotkeys.ahk"
echo Hotkeys aus dem Autostart entfernt.
pause
goto MENU