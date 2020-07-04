#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance,Force
Menu,TRAY,NoIcon

/*
Include Libs and Startup
*/

#Include libs\JSON.ahk
#Include libs\DownloadFile.ahk
#Include libs\ListBoxAdjustHSB.ahk
#Include libs\7Zip.ahk
#Include libs\Update.ahk

CurrentRelease := 1.0
if(!FileExist("settings.ini")) {
    FileAppend, [Settings]`nip=`nauto_update=0, settings.ini
}
IniRead, Ip, settings.ini, Settings, ip
IniRead, AutoUpdateIni, settings.ini, Settings, auto_update

if(FileExist("update.exe")) {
    FileDelete, update.exe
}

/*
Functions
*/

EnableGui() {
    GuiControl, Enable, Butt1
    GuiControl, Enable, Butt2
    GuiControl, Enable, Butt3
    GuiControl, Enable, Butt4
    GuiControl, Enable, GameList
    GuiControl, Enable, Search
}

DisableGui() {
    GuiControl, Disable, Butt1
    GuiControl, Disable, Butt2
    GuiControl, Disable, Butt3
    GuiControl, Disable, Butt4
    GuiControl, Disable, GameList
    GuiControl, Disable, Search
}

CheckForUpdates(CurrentRelease, AutoUpdate = false) {
    if (AutoUpdate = true) {
    MsgBox, 4, beeShop - Update, Do you want to check for updates?
    IfMsgBox, No
        return
    }
    url := "https://api.github.com/repos/manuGMG/beeShop/releases/latest"
    whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    whr.Open("GET", url, false)
    whr.Send()
    
    JsonResponse := JSON.Load(whr.responseText)
    LastRelease := JsonResponse.tag_name
    
    if (LastRelease = "") {
    MsgBox, 0,beeShop - Update, % JsonResponse.message
    return
    }
    
    if (LastRelease > CurrentRelease) {
    MsgBox, 4, beeShop - Update, An update was found. Would you like to install it now?
    IfMsgBox, Yes
        LastReleaseURL := JsonResponse.assets[1].browser_download_url
        DownloadFile(LastReleaseURL, "release.zip", True, False)
        Extract_7Zip("7za.exe")
        While !FileExist( "7za.exe")
            Sleep 250
        Extract_Update("update.exe")
        While !FileExist( "update.exe")
            Sleep 250
        Run, update.exe
        ExitApp
    IfMsgBox, No
        EnableGui()
        return
    } else {
    MsgBox,0,beeShop - Update, No updates found. `n(Last Release: %CurrentRelease%)
    }
}

/*
GUI
*/

Menu, tray, Icon , assets/icon.ico, 1, 1
Gui, 1:New,,beeShop
Gui, Add, Pic, x20 y4 vImg, assets\bee.tif
Gui, Add, Text, x343 y29 w200 cFFFFFF vStatus, Status: Idle
Gui, Add, Text, x343 y45 cFFFFFF vDatabase, Database: 3DSAll
Gui, Add, Text, x343 y61 cFFFFFF vSpeedGui, Speed:
Gui, Add, Text, x379 y61 w200 cFFFFFF vSpeedGui2, -
Gui, Add, ListBox, x20 y120 w293 h250 vGameList hwndGameList +HScroll
ListBoxAdjustHSB("GameList")
Gui, Add, Button, x323 y120 w107 h30 vButt1, Bump
Gui, Add, Button, x323 y160 w107 h30 vButt2, Settings
Gui, Add, Button, x323 y200 w107 h30 vButt3, Upload
Gui, Add, Edit, x323 y240 w107 h25 vSearch,
; Gui, Add, Button, x223 y240 w107 h30 vButt4, Settings
Gui, Add, Progress,x323 y327 w107 h30 vProgress cffda30, 0
Gui, Color, 333e40
Gui, Show, w450 h370, BeeShop
if (AutoUpdateIni = 1) {
    CheckForUpdates(CurrentRelease, true)
}

if (FileExist("assets/db.csv")) {
    FileRead, games, assets\db.csv
    GuiControl, Text, Database, Database: Local
    Sort, games
} else {
    GuiControl,, GameList, DB.CSV FILE IS MISSING.|beeShop needs a db to get links from.|(assets/db.csv)
    ;MsgBox, 0, beeShop - Error, Database is missing.`n(assets/db.csv)
    ;ExitApp
}
games := StrSplit(games, "`n") 

Loop, % games.MaxIndex()
{
	game := games[A_Index]
	game := StrSplit(game, ",") 
    ; game[2] url
    GuiControl,, GameList, % game[1]
}
GuiControl,, Img, assets\bee2.tif
return

ButtonUpload:
DisableGui()
Goto, FTPUpload
return

ButtonBump:
Gui, Submit, NoHide

if (GameList = "") {
    MsgBox, 0, beeShop - Error, No game was selected.
} else if (Ip != "") {
    GuiControl, Text, Status,  Status: Downloading
    Loop, % games.MaxIndex()
    {
        game := games[A_Index]
        game := StrSplit(game, ",") 
        ; game[2] url
        If (game[1] = GameList) {
            DownloadFile(game[2], GameList . ".cia")
            GameName := GameList . ".cia"
            GuiControl,, Progress,  0
            EnableGui()
            GuiControl,, SpeedGui2, -
            Sleep, 100
            GuiControl,, Progress,  25
            break
        }
    }
Goto, FTPUpload
} else {
    MsgBox, 0, beeShop - Error, IP is not configured.
}
return

FTPUpload:
if (GameName != "") {
if FileExist(GameName) {
    if (Ip != "") {
       GuiControl,, Progress,  100
       GuiControl, Text, Status,  Status: Uploading
       FileAppend, 
       RunWait, serve.exe "%GameName%" "%Ip%",,hide
       GuiControl,, Progress,  0
       GuiControl, Text, Status,  Status: Idle
       EnableGui()
       GameName := ""
    } else {
        MsgBox, 0, beeShop - Error, IP is not configured.
        EnableGui()
        GameName := ""
    }
    } else {
    MsgBox, 0, beeShop - Error, Game has not been found.
    EnableGui()
    GameName := ""
    }
} else {
    FileSelectFile, GameName, 1,, beeShop - Select the game, CIAs (*.cia)
    if (GameName != "") {
        Goto, FTPUpload
    } else {
        EnableGui()
    }
}
return


; Settings
; Work In Progress
ButtonSettings:
Gui, Settings:New,,Settings
Menu, tray, Icon , assets/icon.ico, 1, 1
Gui, Add, Text,cFFFFFF, IP:
IniRead, Ip, settings.ini, Settings, ip
IniRead, AutoUpdateIni, settings.ini, Settings, auto_update
Gui, Add, Edit, vInputIp w220, %Ip%
Gui, Add, CheckBox, vAutoUpdate cFFFFFF Checked%AutoUpdateIni%, Automatically check for updates.
Gui, Add, Button, w220, Save
Gui, Add, Button, w220, Check for Updates
Gui, Color, 333e40
Gui, Show,,Settings
return

SettingsButtonCheckForUpdates:
CheckForUpdates(CurrentRelease)
return

SettingsButtonSave:
Gui, Settings:Submit
if (InputIp == "") {
    MsgBox, 0, beeShop - Error, Please set a valid IP.
    Gui, Show,,Settings
} else if (InputIp != Ip) {
    IniWrite, %InputIp%, settings.ini, Settings, ip
}
    IniWrite, %AutoUpdate%, settings.ini, Settings, auto_update
return


Enter::
Send, {Enter}
Gui,1:Submit,NoHide
GuiControl, ChooseString, GameList, %Search%
return

GuiClose:
ExitApp
