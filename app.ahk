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

if(FileExist("update.exe")) {
    FileDelete, update.exe
}

if(!FileExist("settings.ini")) {
    FileAppend, [Settings]`nip=`nauto_update=0`nlanguage=1`ndb=`nul_method=1, settings.ini
}

CurrentRelease := 1.2

;read settings ini
IniRead, Ip, settings.ini, Settings, ip
IniRead, AutoUpdateIni, settings.ini, Settings, auto_update
IniRead, LanguageIni, settings.ini, Settings, language
IniRead, DatabaseIni, settings.ini, Settings, db
IniRead, UploadMethodIni, settings.ini, Settings, ul_method

if (UploadMethodIni = 1) {
    GuiControl, Disable, BtnDownload
    GuiControl, Disable, BtnShowLink
}

;read configured language from ini
IniRead, txtDbMissing, languages.ini, %LanguageIni%, txtDbMissing
IniRead, txtBtnDownload, languages.ini, %LanguageIni%, txtBtnDownload
IniRead, txtBtnSettings, languages.ini, %LanguageIni%, txtBtnSettings
IniRead, txtBtnUpload, languages.ini, %LanguageIni%, txtBtnUpload
IniRead, txtStatus, languages.ini, %LanguageIni%, txtStatus
IniRead, txtDb, languages.ini, %LanguageIni%, txtDb
IniRead, txtSpeed, languages.ini, %LanguageIni%, txtSpeed
IniRead, txtSettings, languages.ini, %LanguageIni%, txtSettings
IniRead, txtLanguage, languages.ini, %LanguageIni%, txtLanguage
IniRead, txtSave, languages.ini, %LanguageIni%, txtSave
IniRead, txtCfu, languages.ini, %LanguageIni%, txtCfu
IniRead, txtUpdate, languages.ini, %LanguageIni%, txtUpdate
IniRead, txtAutoUpdate, languages.ini, %LanguageIni%, txtAutoUpdate
IniRead, txtCfuMsg, languages.ini, %LanguageIni%, txtCfuMsg
IniRead, txtUpdateFound, languages.ini, %LanguageIni%, txtUpdateFound
IniRead, txtNoUpdateFound, languages.ini, %LanguageIni%, txtNoUpdateFound
IniRead, txtNoGame, languages.ini, %LanguageIni%, txtNoGame
IniRead, txtDownloading, languages.ini, %LanguageIni%, txtDownloading
IniRead, txtUploading, languages.ini, %LanguageIni%, txtUploading
IniRead, txtIpNotConfigured, languages.ini, %LanguageIni%, txtIpNotConfigured
IniRead, txtSelectGame, languages.ini, %LanguageIni%, txtSelectGame
IniRead, txtIdle, languages.ini, %LanguageIni%, txtIdle
IniRead, txtRestart, languages.ini, %LanguageIni%, txtRestart
IniRead, txtAskRestart, languages.ini, %LanguageIni%, txtAskRestart
IniRead, txtFileSelect, languages.ini, %LanguageIni%, txtFileSelect
IniRead, txtSelect, languages.ini, %LanguageIni%, txtSelect
IniRead, txtClickText, languages.ini, %LanguageIni%, txtClickText
IniRead, txtSearch, languages.ini, %LanguageIni%, txtSearch
IniRead, txtProgress, languages.ini, %LanguageIni%, txtProgress
IniRead, txtBtnShowLink, languages.ini, %LanguageIni%, txtBtnShowLink
IniRead, txtLink, languages.ini, %LanguageIni%, txtLink
IniRead, txtPreferredUlMethod, languages.ini, %LanguageIni%, txtPreferredUlMethod
IniRead, txtDownloadOn3DS, languages.ini, %LanguageIni%, txtDownloadOn3DS
IniRead, txtDownloadOnPC, languages.ini, %LanguageIni%, txtDownloadOnPC

DbFilePath := StrSplit(DatabaseIni, "\")
DbFileName := DbFilePath[DbFilePath.MaxIndex()]
if (StrLen(DbFileName) > 11) {
    DbFileName := SubStr(DbFileName, 1, 9) . "..."
}

/*
Functions
*/

EnableGui() {
    GuiControl, Enable, BtnDownload
    GuiControl, Enable, BtnSettings
    GuiControl, Enable, BtnUpload
    GuiControl, Enable, BtnShowLink
    GuiControl, Enable, GameList
    GuiControl, Enable, Search
    GuiControl, Enable, BtnBtnShowLink
}

DisableGui() {
    GuiControl, Disable, BtnDownload
    GuiControl, Disable, BtnSettings
    GuiControl, Disable, BtnUpload
    GuiControl, Disable, BtnShowLink
    GuiControl, Disable, GameList
    GuiControl, Disable, Search
    GuiControl, Disable, BtnShowLink
}
/*
GUI
*/

Menu, tray, Icon , assets/icon.ico, 1, 1
Gui, Main:New,,beeShop
Gui, Add, Pic, x10 y10 vImg, assets\bee.png

; labels
Gui, Add, Text, x303 y18 w167 cFFFFFF vSpeedGui, %txtSpeed% N/A
Gui, Add, Text, w230 cFFFFFF vStatus, %txtStatus% %txtIdle%
Gui, Add, Text, cFFFFFF w230 vDatabase, %txtDb% %DbFileName%
;
Gui, Font, s9

Gui, Add, ListBox, x10 y119 w283 h290 vGameList hwndGameList +HScroll
ListBoxAdjustHSB("GameList")

; search
Gui, Add, Text, cFFFFFF x303 y100, %txtSearch%
Gui, Add, Edit, x303 y120 w127 vSearch

; buttons
Gui, Add, Button, x303 y151 w127 h30 vBtnDownload gDownload, %txtBtnDownload%
Gui, Add, Button, x303 y191 w127 h30 vBtnUpload gUpload, %txtBtnUpload%
Gui, Add, Button, x303 y231 w127 h30 vBtnShowLink gShowLink, %txtBtnShowLink%
Gui, Add, Button, x303 y271 w127 h30 vBtnSettings gSettings, %txtBtnSettings%

; progress bar
Gui, Add, Text, cFFFFFF x303 y359, %txtProgress%
Gui, Add, Progress, x303 y379 w127 h30 vProgress cffda30, 0

Gui, Color, 333e40
Gui, Show, w440 h419, BeeShop


if (AutoUpdateIni = 1) {
    Goto, CheckForUpdates
}

if (FileExist(DatabaseIni)) {
    FileRead, games, %DatabaseIni%
    Sort, games
    games := StrSplit(games, "`n") 
} else {
    GuiControl,, GameList, %txtDbMissing%
    GuiControl, Disable, BtnDownload
    GuiControl, Disable, BtnShowLink
}

Loop, % games.MaxIndex()
{
	game := games[A_Index]
	game := StrSplit(game, ",") 
    ; game[2] url
    GuiControl,, GameList, % game[1]
}

GuiControl,, Img, assets\bee2.png

if (AutoUpdateIni = 1) {
    Goto, CheckForUpdates
}
return

Upload:
DisableGui()
Goto, FTPUpload
return

Download:
Gui, Submit, NoHide

if (GameList = "") {
    MsgBox, 0, beeShop - Error, %txtNoGame%
} else if (Ip != "") {
    GuiControl, Text, Status, %txtStatus% %txtDownloading%
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
            GuiControl,, SpeedGui,Speed: -
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

ShowLink:
Gui, Submit, NoHide

if (GameList = "") {
    MsgBox, 0, beeShop - Error, %txtNoGame%
}
else {
    Loop, % games.MaxIndex()
    {
        game := games[A_Index]
        game := StrSplit(game, ",") 

        If (game[1] = GameList) {
            stuff := game[2]
            Gui, ShowLink:New,, %txtBtnShowLink%
            Gui, Color, 333e40
            Gui, Add, Text, x10 y10 cFFFFFF, %txtLink%
            Gui, Add, Edit, x10 y30 w230 h60, %stuff%
            Gui, Show, h100 w250,, %txtBtnShowLink%
        }
    }  
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
       GuiControl, Text, Status,  %txtStatus% %txtIdle%
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

Settings:

; Read settings from config
IniRead, Ip, settings.ini, Settings, ip
IniRead, AutoUpdateIni, settings.ini, Settings, auto_update
IniRead, LanguageIni, settings.ini, Settings, language
IniRead, UploadMethodIni, settings.ini, Settings, ul_method

Gui, Settings:New,,Settings
Menu, tray, Icon, assets/icon.ico, 1, 1
Gui, Add, Text, x10 y12 cFFFFFF gDbName vDbName, %txtDb% %DbFileName%
Gui, Add, Text, x10 y34 w230 cFFFFFF, %txtClickText%
Gui, Add, Button, gSelectDb x170 y8 w70 h22, %txtSelect%
; IP Config
Gui, Add, Text, x10 y65 cFFFFFF, IP Address:
Gui, Add, Edit, vInputIp x90 y62 w100, %Ip%
; Language Config
Gui, Add, Text, cFFFFFF x10 y100 w70, %txtLanguage%
Gui, Add, DropDownList, x90 y95 w80 vLanguage Choose%LanguageIni% AltSubmit, English|Spanish|German|Italian|French|Catalan|Portuguese
; Preferred Upload Method
Gui, Add, Text, cFFFFFF x10 y135, %txtPreferredUlMethod%
Gui, Add, DropDownList, x10 y155 w230 vPreferredUlMethod Choose%UploadMethodIni% AltSubmit, %txtDownloadOn3DS%|%txtDownloadOnPC%
; Automatic Update Config
Gui, Add, Text, x10 y222 vText c3DCEFC gCheckForUpdates, %txtCfu%
Gui, Add, CheckBox, vAutoUpdate x10 y187 cFFFFFF Checked%AutoUpdateIni%, %txtAutoUpdate%
; Save settings button
Gui, Add, Button, x160 y217 w80 gSave, %txtSave% 
Gui, Show, h250 w250,, %txtSettings%
OnMessage(0x200, "Help")
Gui, Color, 333e40
return

DbName:
MsgBox,, beeShop, %DatabaseIni%
return

SelectDb:
FileSelectFile, ChosenDb, 1, %A_WorkingDir%, beeShop - %txtFileSelect%, (*.csv)
ChosenDb := StrSplit(ChosenDb, "\")
ChosenDb := ChosenDb[ChosenDb.MaxIndex()]
if (StrLen(ChosenDb) > 11) {
    ChosenDb := SubStr(ChosenDb, 1, 9) . "..."
}
GuiControl, Text, DbName, %txtDb% %ChosenDb%
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
    
    if (LastRelease =! CurrentRelease) {
        MsgBox, 4, beeShop - %txtUpdate%, %txtCfuMsg%
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
        MsgBox,0,beeShop - %txtUpdate%, %txtNoUpdateFound% %CurrentRelease%
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
IniWrite, %PreferredUlMethod%, settings.ini, Settings, ul_method
IniWrite, %ChosenDb%, settings.ini, Settings, db

IniRead, SavedDb, settings.ini, Settings, db
IniRead, SavedLang, settings.ini, Settings, language
IniRead, UploadMethodIni, settings.ini, Settings, ul_method

if (SavedLang != CurrentLang and InputIp != "") {
   Goto, AskForRestart
} else if (SavedDb != CurrentDb and InputIp != "") {
    Goto, AskForRestart
}

if (PreferredUlMethod = 1) {
    GuiControl, Main:Disable, BtnDownload
    GuiControl, Main:Disable, BtnShowLink
} else {
    GuiControl, Main:Enable, BtnDownload
    GuiControl, Main:Enable, BtnShowLink
}
return

AskForRestart:
MsgBox, 4, beeShop - %txtRestart%, %txtAskRestart%
IfMsgBox, Yes
    Reload
return

Enter::
Send, {Enter}
Gui,1:Submit,NoHide
GuiControl, ChooseString, GameList, %Search%
return

MainGuiClose:
ExitApp
return