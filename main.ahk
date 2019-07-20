;------------------------------------------------------------------------------
; Media Controls for All!
; John Fernow
; Adds hotkeys for volume and media controls to keyboards without dedicated buttons.
;------------------------------------------------------------------------------

; setup
#NoEnv ; Avoids checking empty variables to see if they are environment variables (documentation recommends it for all new scripts).
SetWorkingDir %A_ScriptDir%
global userLanguage := getUserLanguage()
global path := A_MyDocuments "\Media Controls for All.txt"
setupTrayMenu()
initialSetup()

; main controls
^+Up::SoundSet +5                       ; Ctrl + Shift + up -- volume up 10%
^+Down::SoundSet -5                     ; Ctrl + Shift + down -- volume down 10%
^!Left::Media_Prev                      ; Ctrl + Alt + left -- previous song
^!Right::Media_Next                     ; Ctrl + Alt + right -- next song
^!PrintScreen::Media_Play_Pause         ; Ctrl + Alt + printscreen -- play/pause
!DOWN::SoundSet, +1, , mute             ; Alt + down -- toggle the master mute

getUserLanguage() {
  ; try to get keyboard layout
  ; language codes available at https://msdn.microsoft.com/en-us/library/aa912040
  VarSetCapacity(kbd, 9)
  if DllCall("GetKeyboardLayoutName", uint, &kbd) {
    ; The statement "languageCode := kbd" doesn't work for complex reasons because of AHK
    ; Easiest workaround is saving value to file and reading it in.
    FileAppend,
    (
    %kbd%
    ), %A_ScriptDir%\kbd.txt
    Sleep, 1000     ; give time for OS to recognize file so it can be read
    textpath := A_ScriptDir "\kbd.txt"
    FileReadLine, languageCode, %textpath%, 1
    FileDelete, %A_ScriptDir%\kbd.txt
  }

  ; If keyboard unrecognized, try getting account language since Windows does
  ; not provide language identifiers and locales for every keyboard option.
  ; Example: Spanish (Latin America) Keyboard has no language identifier.
  ; Unofficial list of codes: http://www.lingoes.net/en/translator/langcode.htm
  if (languageCode = "") {
    FileAppend,
    (
    FOR /F "tokens=3" `%`%a IN ('reg query "HKCU\Control Panel\Desktop" /v PreferredUILanguages ^| find "PreferredUILanguages"') DO set UILanguage=`%`%a
    @echo off""
    @echo `%UILanguage`%> language.txt
    ), %A_ScriptDir%\getLanguage.bat
    run, %comspec% /c "%A_ScriptDir%\getLanguage.bat"
    Sleep, 1000     ; give time for OS to recognize file so it can be read
    textpath := A_ScriptDir "\language.txt"
    FileReadLine, languageCode, %textpath%, 1
    FileDelete, %A_ScriptDir%\getLanguage.bat
    FileDelete, %A_ScriptDir%\language.txt
    ; Spanish ISOs
    if (languageCode = "es") or (languageCode = "es-AR")
    or (languageCode = "es-BO") or (languageCode = "es-CL")
    or (languageCode = "es-DO") or (languageCode = "es-CR")
    or (languageCode = "es-EC") or (languageCode = "es-ES")
    or (languageCode = "es-GT") or (languageCode = "es-HN")
    or (languageCode = "es-MX") or (languageCode = "es-NI")
    or (languageCode = "es-PA") or (languageCode = "es-PR")
    or (languageCode = "es-PY") or (languageCode = "es-SV")
    or (languageCode = "es-UY") or (languageCode = "es-VE")
    {
      return "es"
    }
    ; English ISOs
    else if (languageCode = "en") or (languageCode = "en-AU")
    or (languageCode = "en-BZ") or (languageCode = "en-CA")
    or (languageCode = "en-CB") or (languageCode = "en-GB")
    or (languageCode = "en-IE") or (languageCode = "en-JM")
    or (languageCode = "en-NZ") or (languageCode = "en-PH")
    or (languageCode = "en-TT") or (languageCode = "en-US")
    or (languageCode = "en-ZA") or (languageCode = "en-ZW")
    {
      return "en"
    }
  }

  ; if user language unrecognized, use language Windows was installed with
  if (languageCode = "") {
    languageCode := languageCode_%A_Language% ; get code of the system's install language.
  }

  languageCode := languageCode + 0            ; convert to numeric type

  ; determine language based off locale code (multiple codes for same language)
  ; Spanish
  if (languageCode = 040a) or (languageCode = 080a) or (languageCode = 0c0a)
  or (languageCode = 100a) or (languageCode = 140a) or (languageCode = 180a)
  or (languageCode = 1c0a) or (languageCode = 200a) or (languageCode = 240a)
  or (languageCode = 280a) or (languageCode = 2c0a) or (languageCode = 300a)
  or (languageCode = 340a) or (languageCode = 380a) or (languageCode = 3c0a)
  or (languageCode = 400a) or (languageCode = 440a) or (languageCode = 480a)
  or (languageCode = 4c0a) or (languageCode = 500a)
  {
    return "es"
  }
  ; default to English
  else {
    return "en"
  }
}

setupTrayMenu() {
  ;-----------------------------------------------------------------------------
  ; Adds options to Windows tray menu (also called Notification Area).
  ;-----------------------------------------------------------------------------
  Menu, Tray, NoStandard ; default options incompatible, must use custom created options
  if (userLanguage = "es")
  {
    Menu, tray, add, Configurar el comienzo automático, StartupConfig
    Menu, Tray, add, Desinstalar, RunUninstall
    IfEqual, A_ScriptDir, %A_Startup%
       {
          Menu, tray, ToggleCheck, Configurar el comienzo automático
       }
    Menu, Tray, add, Ayuda, OpenHelp
    Menu, tray, add, Salir, Exit
  }
  ; default to English
  else {
    Menu, tray, add, Configure Automatic Startup, StartupConfig
    Menu, Tray, add, Uninstall, RunUninstall
    IfEqual, A_ScriptDir, %A_Startup%
       {
          Menu, tray, ToggleCheck, Configure Automatic Startup
       }
    Menu, Tray, add, Help, OpenHelp
    Menu, tray, add, Exit, Exit
  }
}

StartupSettings() {
  ;-----------------------------------------------------------------------------
  ; Configure if program should auto-start after log-in or not.
  ;-----------------------------------------------------------------------------
  if (userLanguage = "es")
  {
    Msgbox, 35, Configurar iniciar automáticamente,
    (
      ¿Quieres iniciar esta aplicación automáticamente después del login?
    )
  }
  else {
    Msgbox, 35, Startup settings,
    (
      Do you want to start this program automatically after login?
    )
  }
  IfMsgbox, YES
  {
    IfEqual, A_ScriptDir, %A_Startup%
    {
      if (userLanguage = "es")
      {
        Msgbox, Ya comience automáticamente. Nada cambió.
      }
      else
      {
        Msgbox, Program already auto-starts. No changes made.
      }
      return
    }
    ; Sometimes when compiled AHK is not fully loaded at this point.
    ; To avoid errors, give time for it to load.
    Sleep, 60000
    FileMove, %A_ScriptFullPath%, %A_Startup%, 1
    if ErrorLevel {
      if (userLanguage = "es")
      {
        Msgbox,
        (
          Error: No podemos mudarse el archivo a la carpeta necesaria para
          comenzarla automáticamente. Eso probablemente occurió porque el
          archivo está en una unidad externa (como una memoria USB) o por una
          política de Directorio Activo o porque no podía cargar en suficiente
          tiempo. Controles Multimedia Para Todos continuará ejecutar, pero
          no iniciará automáticamente.
        )
      }
      else {
        Msgbox,
        (
          Error: Could not move file to startup folder. This is likely either
          due to it being on an external drive (such as a USB drive), due to an
          Active Directory policy, or because the program failed to load in time.
          Media Controls for All will continue to run, but will not start
          automatically.
        )
      }
      return
    }
    Run, %A_Startup%\%A_ScriptName%
    ExitApp
  }
  IfMsgbox, NO
  {
    IfEqual, A_ScriptDir, %A_Startup%
      {
        FileMove, %A_ScriptFullPath%, %A_Desktop%, 1
        Run, %A_Desktop%\%A_ScriptName%
        ExitApp
      }
  }
  return
}

initialSetup() {
  ;-----------------------------------------------------------------------------
  ; Calls for pop-up to configure startup settings if this is the first time
  ; the program is being ran.
  ;-----------------------------------------------------------------------------
  if !FileExist(path) ; check to see if first time running program
  {
    FileAppend,
    (
    (English) This file is used to see if this is the first time the program Media
    Controls for All is running.
    (Español) La aplicación Controles Multimedia Para Todos se usa este archivo
    para ver si es la primera vez esta aplicación está ejecutando.
    ), %path%
    StartupSettings()
  }
}

StartupConfig:
  StartupSettings()
  return

Exit:
  ExitApp

RunUninstall:
  ;-----------------------------------------------------------------------------
  ; Program is actually portable, but this deletes all associated files if ran.
  ;-----------------------------------------------------------------------------
  if (userLanguage = "es")
  {
    Msgbox, 35, Desinstalar,
    (
      ¿Quieres desinstalar Controles Multimedia Para Todos?
    )
  }
  else {
    Msgbox, 35, Uninstall,
    (
      Do you want to uninstall Media Controls for All?
    )
  }
  IfMsgbox, YES
  {
    FileDelete, %path%
    ; Windows doesn't allow .exe files to delete themselves directly
    ; must create batch file to delete the .exe file and itself
    FileAppend,
    (
    del "%A_ScriptFullPath%"
    del "`%~f0" & exit
    ), %A_ScriptDir%\del.bat
    run, %comspec% /c "%A_ScriptDir%\del.bat"
    ExitApp
  }
  return

OpenHelp:
; Spacing in this section intentionally obscure in order to manually align text.
; Programmatic text alignment not directly available in this scripting language to the best of my knowledge
if (userLanguage = "es")
{
  Msgbox, , Ayuda,
(
Controles del volumen:
Pulsar (al mismo tiempo)...        Para...
Ctrl + Mayús + flecha arriba     subir el volumen 10 por ciento
Ctrl + Mayús + flecha abajo     bajar el volumen 10 por ciento
Alt + flecha abajo                      activar/desactivar el silenciamiento

Controles de música:
Pulsar (al mismo tiempo)...      Para...
Ctrl + Alt + Print Screen          tocar/para la música
Ctrl + Alt + flecha derecha     tocar la próxmia canción
Ctrl + Alt + flecha izquierda   tocar la canción anterior
(A veces hay que comenzar a mano la canción de un reproductor de medios (como Spotify) la primera vez la computadora o la aplicación enciende.)

Para comenzar esta aplicación automáticamente (después del login), haz clic con el botón derecho del ratón en el icono de la aplicación y haz clic "Configurar el comienzo automático".

Para salir de esta aplicación, haz clic con el botón derecho en el icono de la aplicación y haz clic "Salir".

Para desinstalar, haz clic con el botón derecho en el icono de la aplicación y haz clic "Desinstalar".

Creado por John Fernow.
)
}
else {                                  ; default to English
  Msgbox, , Help,
(
Volume controls:
Press (at same time)...          To...
Ctrl + Shift + up arrow        increase volume 10 percent
Ctrl + Shift + down arrow   decrease volume 10 percent
Alt + down arrow                 mute/unmute sound

Music controls:
Press (at same time)...         To...
Ctrl + Alt + Print Screen     play/pause music
Ctrl + Alt + right arrow      play next song
Ctrl + Alt + left arrow         play previous song
(Note: may have to start song manually from player first time PC boots or when the application starts to get the hotkeys working.)

To run this program at log-in, right click on the program's icon and click "Configure Automatic Startup". `n
To quit this program, right click on the program's icon and click Exit. `n
To uninstall, right click on the program's icon and click "Uninstall". `n

Created by John Fernow.
)
}
return
