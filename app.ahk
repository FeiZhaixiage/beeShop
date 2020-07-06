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

CurrentRelease := 1.2
if(!FileExist("settings.ini")) {
    FileAppend, [Settings]`nip=`nauto_update=0`nlanguage=1`ndb=, settings.ini
}
IniRead, Ip, settings.ini, Settings, ip
IniRead, AutoUpdateIni, settings.ini, Settings, auto_update
IniRead, LanguageIni, settings.ini, Settings, language
IniRead, DatabaseIni, settings.ini, Settings, db
DbFilePath := StrSplit(DatabaseIni, "\")
DbFileName := DbFilePath[DbFilePath.MaxIndex()]

if(FileExist("update.exe")) {
    FileDelete, update.exe
}

lang := []
if (LanguageIni = 1) {
    Loop, Read, assets\langs\english.lang
    lang.push(A_LoopReadLine)
}
else if (LanguageIni = 2) {
    Loop, Read, assets\langs\spanish.lang
    lang.push(A_LoopReadLine)
}
else if (LanguageIni = 3) {
    Loop, Read, assets\langs\german.lang
    lang.push(A_LoopReadLine)
}
else if (LanguageIni = 4) {
    Loop, Read, assets\langs\italian.lang
    lang.push(A_LoopReadLine)
}
else if (LanguageIni = 5) {
    Loop, Read, assets\langs\french.lang
    lang.push(A_LoopReadLine)
}
else if (LanguageIni = 6) {
    Loop, Read, assets\langs\catalan.lang
    lang.push(A_LoopReadLine)
}
else if (LanguageIni = 7) {
    Loop, Read, assets\langs\brportuguese.lang
    lang.push(A_LoopReadLine)
}

txtDbMissing := lang[1]
txtButt1  := lang[2]
txtButt2  := lang[3]
txtButt3  := lang[4]
txtStatus := lang[5]
txtDb := lang[6]
txtSpeed := lang[7]
txtSettings := lang[8]
txtLanguage := lang[9]
txtSave := lang[10]
txtCfu := lang[11]
txtUpdate := lang[12]
txtAutoUpdate := lang[13]
txtCfuMsg := lang[14]
txtUpdateFound := lang[15]
txtNoUpdateFound := lang[16] . CurrentRelease
txtNoGame := lang[17]
txtDownloading := lang[18]
txtUploading := lang[19]
txtIpNotConfigured := lang[20]
txtSelectGame := lang[21]
txtIdle := lang[22]
txtRestart := lang[23]
txtAskRestart := lang[24]
txtFileSelect := lang[25]
txtSelect := lang[26]
txtClickText := lang[27]
txtSearch := lang[28]
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

/*
GUI
*/

Menu, tray, Icon , assets/icon.ico, 1, 1
Gui, 1:New,,beeShop
Gui, Add, Pic, x10 y10 vImg, assets\bee.tif
Gui, Add, Text, x303 y61 cFFFFFF vSpeedGui, %txtSpeed%
Gui, Add, Text, x388 y61 w230 cFFFFFF vSpeedGui2, -
Gui, Add, Text, x303 y29 w230 cFFFFFF vStatus, %txtStatus% %txtIdle%
Gui, Add, Text, x303 y45 cFFFFFF vDatabase, %txtDb% %DbFileName%

Gui, Add, ListBox, x10 y119 w283 h250 vGameList hwndGameList +HScroll
ListBoxAdjustHSB("GameList")
Gui, Add, Button, x303 y120 w157 h30 vButt1 gBump, %txtButt1%
Gui, Add, Button, x303 y160 w157 h30 vButt2 gSettings, %txtButt2%
Gui, Add, Button, x303 y200 w157 h30 vButt3 gUpload, %txtButt3%
Gui, Add, Text, cFFFFFF x303 y240, %txtSearch%
Gui, Add, Edit, x303 y260 w157 vSearch, 
Gui, Add, Progress,x303 y327 w157 h30 vProgress cffda30, 0
Gui, Color, 333e40
Gui, Show, w470 h367, BeeShop
if (AutoUpdateIni = 1) {
    Goto, CheckForUpdates
}

if (FileExist(DatabaseIni)) {
    FileRead, games, %DatabaseIni%
    Sort, games
} else {
    GuiControl,, GameList, %txtDbMissing%
    GuiControl, Disable, Butt1
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

if (AutoUpdateIni = 1) {
    Goto, CheckForUpdates
}

return

Upload:
DisableGui()
Goto, FTPUpload
return

Bump:
Gui, Submit, NoHide

if (GameList = "") {
    MsgBox, 0, beeShop - Error, %txtNoGame%
} else if (Ip != "") {
    GuiControl, Text, Status, %txtDownloading%
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
    MsgBox, 0, beeShop - Error, %txtIpNotConfigured%
}
return

FTPUpload:
if (GameName != "") {
if FileExist(GameName) {
    if (Ip != "") {
       GuiControl,, Progress,  100
       GuiControl, Text, Status,  %txtStatus% %txtUploading%
       RunWait, serve.exe "%GameName%" "%Ip%",,hide
       GuiControl,, Progress,  0
       GuiControl, Text, Status,  %txtStatus% Idle
       EnableGui()
       GameName := ""
    } else {
        MsgBox, 0, beeShop - Error, %txtIpNotConfigured%
        EnableGui()
        GameName := ""
    }
    } else {
    MsgBox, 0, beeShop - Error, %txtNoGame%
    EnableGui()
    GameName := ""
    }
} else {
    FileSelectFile, GameName, 1,, beeShop - %txtSelectGame%, CIAs (*.cia)
    if (GameName != "") {
        Goto, FTPUpload
    } else {
        EnableGui()
    }
}
return


; Settings
; Work In Progress


Settings:
; Read settings from config
IniRead, Ip, settings.ini, Settings, ip
IniRead, AutoUpdateIni, settings.ini, Settings, auto_update
IniRead, LanguageIni, settings.ini, Settings, language

Gui, Settings:New,,Settings
Menu, tray, Icon, assets/icon.ico, 1, 1
Gui, Add, Text, x10 y12 cFFFFFF gDbName, %txtDb% %DbFileName%
Gui, Add, Text, x10 y34 w230 cFFFFFF, %txtClickText%
Gui, Add, Button, gSelectDb x170 y8 w70 h22, %txtSelect%
; IP Config
Gui, Add, Text, x10 y65 cFFFFFF, IP Address:
Gui, Add, Edit, vInputIp x90 y62 w100, %Ip%
; Language Config
Gui, Add, Text, cFFFFFF x10 y100 w70, %txtLanguage%
Gui, Add, DropDownList, x90 y95 w80 vLanguage Choose%LanguageIni% AltSubmit, English|Spanish|German|Italian|French|Catalan|Portuguese
; Automatic Update Config
Gui, Add, CheckBox, vAutoUpdate x10 y137 cFFFFFF Checked%AutoUpdateIni%, %txtAutoUpdate%
Gui, Add, Text, x10 y182 vText c3DCEFC gCheckForUpdates, %txtCfu%
; Save settings button
Gui, Add, Button, x160 y177 w80 gSave, %txtSave% 
Gui, Show, h210 w250,, %txtSettings%
OnMessage(0x200, "Help")
Gui, Color, 333e40
return

DbName:
MsgBox,, beeShop, %DatabaseIni%
return

SelectDb:
FileSelectFile, ChosenDb, 1, %A_WorkingDir%, beeShop - %txtFileSelect%, (*.csv)
return

CheckForUpdates:
    if (AutoUpdateIni = 1) {
        MsgBox, 4, beeShop - %txtUpdate%, %txtCfuMsg%
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
        MsgBox, 0,beeShop - %txtUpdate%, % JsonResponse.message
        return
    }
    
    if (LastRelease > CurrentRelease) {
        MsgBox, 4, beeShop - %txtUpdate%, %txtUpdateFound%
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
        MsgBox,0,beeShop - %txtUpdate%,%txtNoUpdateFound% 
    }
return

Save:
Gui, Settings:Submit

CurrentLang := LanguageIni
CurrentDb := DatabaseIni

if (InputIp == "") {
    MsgBox, 0, beeShop - Error, %txtIpNotConfigured%
    Gui, Show,,Settings
} else if (InputIp != Ip) {
    IniWrite, %InputIp%, settings.ini, Settings, ip
}
    IniWrite, %AutoUpdate%, settings.ini, Settings, auto_update
    IniWrite, %Language%, settings.ini, Settings, language
    if (!FileExist(DatabaseIni)) {
        IniWrite, %ChosenDb%, settings.ini, Settings, db
    }

    IniRead, SavedDb, settings.ini, Settings, db
    IniRead, SavedLang, settings.ini, Settings, language
    if (SavedLang != CurrentLang) {
       Goto, AskForRestart
    }

    if (SavedDb != CurrentDb) {
        Goto, AskForRestart
    }
return

AskForRestart:
MsgBox, 4, beeShop - %txtRestart%, %txtAskRestart%
IfMsgBox, Yes
Reload
IfMsgBox, No
return

Enter::
Send, {Enter}
Gui,1:Submit,NoHide
GuiControl, ChooseString, GameList, %Search%
return

GuiClose:
ExitApp
