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
    FileAppend, [Settings]`nip=`nauto_update=0`nlanguage=1, settings.ini
}
IniRead, Ip, settings.ini, Settings, ip
IniRead, AutoUpdateIni, settings.ini, Settings, auto_update
IniRead, LanguageIni, settings.ini, Settings, language

if(FileExist("update.exe")) {
    FileDelete, update.exe
}

/*
Translations
*/

if (LanguageIni = 1) {
    txtDbMissing := "DB.CSV FILE IS MISSING.|beeShop needs a db to get links from.|(assets/db.csv)"
    txtButt1  := "Bump"
    txtButt2  := "Settings"
    txtButt3  := "Upload"
    txtStatus := "Status:"
    txtDb := "Database: Local"
    txtSpeed := "Speed:"
    txtSettings := "Settings"
    txtLanguage := "Language:"
    txtSave := "Save"
    txtCfu := "Check for updates"
    txtUpdate := "Update"
    txtAutoUpdate := "Automatically check for updates"
    txtCfuMsg := "Do you want to check for updates?"
    txtUpdateFound := "An update was found. Would you like to install it now?"
    txtNoUpdateFound := "No updates found. `n(Last Release: " . CurrentRelease . ")"
    txtNoGame := "No game was selected."
    txtDownloading := "Downloading"
    txtUploading := "Uploading"
    txtIpNotConfigured := "IP is not configured."
    txtSelectGame := "Select the game"
}

if (LanguageIni = 2) {
    txtDbMissing := "NO SE ENCONTRÓ EL ARCHIVO DB.CSV|beeShop necesita una DB para funcionar.|(assets/db.csv)"
    txtButt1  := "Descargar y Subir"
    txtButt2  := "Ajustes"
    txtButt3  := "Subir"
    txtStatus := "Estado:"
    txtDb := "BD: Local"
    txtSpeed := "Velocidad:"
    txtSettings := "Ajustes"
    txtLanguage := "Idioma:"
    txtSave := "Guardar"
    txtCfu := "Buscar actualizaciones"
    txtUpdate := "Actualizar"
    txtAutoUpdate := "Buscar actualizaciones automáticamente"
    txtCfuMsg := "¿Quieres buscar actualizaciones?"
    txtUpdateFound := "Se encontró una versión más reciente de beeShop. ¿Quieres actualizar ahora?"
    txtNoUpdateFound := "No se encontraron actualizaciones. `n(Última versión: " . CurrentRelease . ")"
    txtNoGame := "No se seleccionó ningún juego."
    txtDownloading := "Descargando"
    txtUploading := "Subiendo"
    txtIpNotConfigured := "No se encontró una IP configurada."
    txtSelectGame := "Selecciona un juego"
}

if (LanguageIni = 3) {
    txtDbMissing := "Die Datenbank (db.csv) fehlt.|beeShop benötigt eine Datenbank für Links.|(assets/db.csv)"
    txtButt1 := "Herunterladen"
    txtButt2 := "Einstellungen"
    txtButt3 := "Hochladen"
    txtStatus := "Status:"
    txtDb := "Datenbank: Lokal"
    txtSpeed := "Geschwindigkeit:"
    txtSettings := "Einstellungen"
    txtLanguage := "Sprache:"
    txtSave := "Speichern"
    txtCfu := "Nach Aktualisierungen suchen"
    txtUpdate := "Aktualisieren"
    txtAutoUpdate := "Automatisch nach Aktualisierungen suchen"
    txtCfuMsg := "Möchten sie nach Aktualisierungen suchen?"
    txtUpdateFound := "Eine Aktualisierung wurde gefunden. Möchten sie sie jetzt installieren?"
    txtNoUpdateFound := "Keine Aktualisierungen gefunden. `n(Aktuelle Version: " . CurrentRelease . ")"
    txtNoGame := "Es wurde kein Spiel ausgewählt."
    txtDownloading := "Herunterladen"
    txtUploading := "Hochladen"
    txtIpNotConfigured := "IP wurde nicht konfiguriert."
    txtSelectGame := "Wähle das Spiel aus"
}

if (LanguageIni = 4) {
    txtDbMissing:= "IL FILE DB.CSV È MANCANTE. |beeShop ha bisogno di un db per ottenere collegamenti.|(assets / db.csv)"
    txtButt1:= "Scarica"
    txtButt2:= "Impostazioni"
    txtButt3:= "Carica"
    txtStatus:= "Stato:"
    txtDb:= "Database: Locale"
    txtSpeed:= "Velocità:"
    txtSettings:= "Impostazioni"
    txtLanguage:= "Lingua:"
    txtSave:= "Salva"
    txtCfu:= "Controlla aggiornamenti"
    txtUpdate:= "Aggiorna"
    txtAutoUpdate:= "Controlla automaticamente gli aggiornamenti"
    txtCfuMsg:= "Vuoi verificare la presenza di aggiornamenti?"
    txtUpdateFound:= "È stato trovato un aggiornamento. Desideri installarlo ora?"
    txtNoUpdateFound:= "Nessun aggiornamento trovato.` n (Ultima versione: " . CurrentRelease . ")"
    txtNoGame:= "Nessun gioco è selezionato."
    txtDownloading:= "Scaricamento"
    txtUploading:= "Caricamento"
    txtIpNotConfigured:= "IP non configurato."
    txtSelectGame:= "Seleziona il gioco"
}

if (LanguageIni = 5) {
    txtDbMissing := "O ARQUIVO DB.CSV NÃO FOI ENCONTRADO.|beeShop precisa de um banco de dados para conseguir links.|(assets/db.csv)"
    txtButt1  := "Baixar e subir"
    txtButt2  := "Configurações"
    txtButt3  := "Upload"
    txtStatus := "Status:"
    txtDb := "BD: Local"
    txtSpeed := "Velocidade:"
    txtSettings := "Configurações"
    txtLanguage := "Idioma:"
    txtSave := "Salvar"
    txtCfu := "Procurar por atualizações"
    txtUpdate := "Atualizar"
    txtAutoUpdate := "Procurar por atualizações automaticamente"
    txtCfuMsg := "Checar se existem atualizações?"
    txtUpdateFound := "Uma atualização foi encontrada. Gostaria de instalar agora?"
    txtNoUpdateFound := "Nenhuma atualização foi encontrada. `n(Última versão: " . CurrentRelease . ")"
    txtNoGame := "Nenhum jogo foi selecionado."
    txtDownloading := "Baixando"
    txtUploading := "Fazendo upload"
    txtIpNotConfigured := "IP não está configurado."
    txtSelectGame := "Selecione o jogo"
}

if (LanguageIni = 6) {
    txtDbMissing := "No s'ha trobat l'arxiu DB.CSV. |beeShop necessita una base de dades per funcionar.|(assets/db.csv)"
    txtButt1  := "Descarregar i pujar"
    txtButt2  := "Configuració"
    txtButt3  := "Pujar"
    txtStatus := "Estat:"
    txtDb := "BD: Local"
    txtSpeed := "Velocitat:"
    txtSettings := "Configuració"
    txtLanguage := "Idioma:"
    txtSave := "Guardar"
    txtCfu := "Buscar actualizacions"
    txtUpdate := "Actualizar"
    txtAutoUpdate := "Buscar actualizacions automàticament"
    txtCfuMsg := "¿Vols buscar actualizacions?"
    txtUpdateFound := "S'ha trobat una versio més recent de beeShop. ¿Vols actualizar ara?"
    txtNoUpdateFound := "No s'han trobat actualizacions. `n(Última versio: " . CurrentRelease . ")"
    txtNoGame := "No s'ha seleccionat cap joc."
    txtDownloading := "Descarregant"
    txtUploading := "Pujant"
    txtIpNotConfigured := "No s'ha trobat una direcció IP configurada"
    txtSelectGame := "Selecciona un joc" 
}

if (LanguageIni = 7) {
    txtDbMissing := "LE FICHIER DB.CSV N'A PAS ÉTÉ TROUVÉ.|beeShop a besoin d'une base de données pour récupérer les liens.|(assets/db.csv)"
    txtButt1  := "Télécharger"
    txtButt2  := "Paramètres"
    txtButt3  := "Soumettre"
    txtStatus := "Statut:"
    txtDb := "BD: Locale"
    txtSpeed := "Vitesse:"
    txtSettings := "Paramètres"
    txtLanguage := "Langue:"
    txtSave := "Sauvegarder"
    txtCfu := "Rechercher des mises à jour"
    txtUpdate := "Mettre à jour"
    txtAutoUpdate := "Rechercher des mises à jour automatiquement"
    txtCfuMsg := "Voudriez-vous rechercher des mises à jour?"
    txtUpdateFound := "Une mise à jour a été trouvée. Voudriez-vous l'installer?"
    txtNoUpdateFound := "Aucune mise à jour trouvé. `n(Dernière version: " . CurrentRelease . ")"
    txtNoGame := "Aucun jeu n'a été selectionné."
    txtDownloading := "En cours de téléchargement"
    txtUploading := "En cours de soumission"
    txtIpNotConfigured := "IP non configuré"
    txtSelectGame := "Selectionnez le jeu"
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

/*
GUI
*/

Menu, tray, Icon , assets/icon.ico, 1, 1
Gui, 1:New,,beeShop
Gui, Add, Pic, x20 y4 vImg, assets\bee.tif
if (LanguageIni = 1) {
    Gui, Add, Text, x343 y61 cFFFFFF vSpeedGui, %txtSpeed%
    Gui, Add, Text, x379 y61 w200 cFFFFFF vSpeedGui2, -
    Gui, Add, Text, x343 y29 w200 cFFFFFF vStatus, %txtStatus% Idle
    Gui, Add, Text, x343 y45 cFFFFFF vDatabase, %txtDb%
} else if (LanguageIni = 2) {
    Gui, Add, Text, x343 y61 cFFFFFF vSpeedGui, %txtSpeed%
    Gui, Add, Text, x395 y61 w200 cFFFFFF vSpeedGui2, -
    Gui, Add, Text, x343 y29 w200 cFFFFFF vStatus, %txtStatus% Idle
    Gui, Add, Text, x343 y45 cFFFFFF vDatabase, %txtDb%
} else if (LanguageIni = 3) {
    Gui, Add, Text, x330 y61 cFFFFFF vSpeedGui, %txtSpeed%
    Gui, Add, Text, x415 y61 w200 cFFFFFF vSpeedGui2, -
    Gui, Add, Text, x375 y29 w200 cFFFFFF vStatus, %txtStatus% Idle
    Gui, Add, Text, x343 y45 cFFFFFF vDatabase, %txtDb%
} else if (LanguageIni = 4) {
    Gui, Add, Text, x343 y61 cFFFFFF vSpeedGui, %txtSpeed%
    Gui, Add, Text, x385 y61 w200 cFFFFFF vSpeedGui2, -
    Gui, Add, Text, x343 y29 w200 cFFFFFF vStatus, %txtStatus% Idle
    Gui, Add, Text, x343 y45 cFFFFFF vDatabase, %txtDb%
} else if (LanguageIni = 5) {
    Gui, Add, Text, x343 y61 cFFFFFF vSpeedGui, %txtSpeed%
    Gui, Add, Text, x402 y61 w200 cFFFFFF vSpeedGui2, -
    Gui, Add, Text, x343 y29 w200 cFFFFFF vStatus, %txtStatus% Idle
    Gui, Add, Text, x343 y45 cFFFFFF vDatabase, %txtDb%
} else if (LanguageIni = 6) {
    Gui, Add, Text, x343 y61 cFFFFFF vSpeedGui, %txtSpeed%
    Gui, Add, Text, x390 y61 w200 cFFFFFF vSpeedGui2, -
    Gui, Add, Text, x343 y29 w200 cFFFFFF vStatus, %txtStatus% Idle
    Gui, Add, Text, x343 y45 cFFFFFF vDatabase, %txtDb%
} else if (LanguageIni = 7) {
    Gui, Add, Text, x343 y61 cFFFFFF vSpeedGui, %txtSpeed%
    Gui, Add, Text, x385 y61 w200 cFFFFFF vSpeedGui2, -
    Gui, Add, Text, x343 y29 w200 cFFFFFF vStatus, %txtStatus% Idle
    Gui, Add, Text, x343 y45 cFFFFFF vDatabase, %txtDb%
}
Gui, Add, ListBox, x20 y120 w293 h250 vGameList hwndGameList +HScroll
ListBoxAdjustHSB("GameList")
Gui, Add, Button, x323 y120 w107 h30 vButt1 gBump, %txtButt1%
Gui, Add, Button, x323 y160 w107 h30 vButt2 gSettings, %txtButt2%
Gui, Add, Button, x323 y200 w107 h30 vButt3 gUpload, %txtButt3%
Gui, Add, Edit, x340 y240 w90 h25 vSearch,
Gui, Add, Pic, x323 y244, assets\find.png
; Gui, Add, Button, x223 y240 w107 h30 vButt4, Settings
Gui, Add, Progress,x323 y327 w107 h30 vProgress cffda30, 0
Gui, Color, 333e40
Gui, Show, w450 h370, BeeShop

if (FileExist("assets/db.csv")) {
    FileRead, games, assets\db.csv
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
Gui, Settings:New,,Settings
Menu, tray, Icon , assets/icon.ico, 1, 1
Gui, Add, Text,cFFFFFF, IP:
IniRead, Ip, settings.ini, Settings, ip
IniRead, AutoUpdateIni, settings.ini, Settings, auto_update
IniRead, LanguageIni, settings.ini, Settings, language
Gui, Add, Edit, vInputIp w220, %Ip%
Gui, Add, Text,cFFFFFF, %txtLanguage%
Gui, Add, DropDownList, w220 vLanguage Choose%LanguageIni% AltSubmit, English|Spanish|German|Italian|Portuguese|Catalan|French
Gui, Add, CheckBox, vAutoUpdate cFFFFFF Checked%AutoUpdateIni%, %txtAutoUpdate%
Gui, Add, Button, w220 gSave, %txtSave%
Gui, Add, Button, w220 gCheckForUpdates, %txtCfu%
Gui, Color, 333e40
Gui, Show,,%txtSettings%
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
if (InputIp == "") {
    MsgBox, 0, beeShop - Error, %txtIpNotConfigured%
    Gui, Show,,Settings
} else if (InputIp != Ip) {
    IniWrite, %InputIp%, settings.ini, Settings, ip
}
    IniWrite, %AutoUpdate%, settings.ini, Settings, auto_update
    IniWrite, %Language%, settings.ini, Settings, language
return


Enter::
Send, {Enter}
Gui,1:Submit,NoHide
GuiControl, ChooseString, GameList, %Search%
return

GuiClose:
ExitApp
