;------------------------------------------------------------------------------
; Media Controls for All!
; John Fernow (johnfernow@gmail.com)
; Add hotkeys for volume and media controls to keyboards without dedicated buttons.
;------------------------------------------------------------------------------
; TODO:
; test Spanish version
;------------------------------------------------------------------------------

; setup
#NoEnv ; Avoids checking empty variables to see if they are environment variables (documentation recommends it for all new scripts).
SetWorkingDir %A_ScriptDir%
global userLanguage := getUserLanguage()
global path := A_ScriptDir "\media_controls_for_all.txt"
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
  languageCode := languageCode_%A_Language% ; Get the name of the system's default language.

  ; Spanish
  if languageCode in 040a, 080a, 0c0a, 100a, 140a, 180a, 1c0a, 200a, 240a, 280a, 2c0a, 300a, 340a, 380a, 3c0a, 400a, 440a, 480a, 4c0a, 500a
  {
    userLanguage := "es"
  }
  ; default to English
  else {
    userLanguage := "en"
  }

  return userLanguage
}

setupTrayMenu() {
  ;-----------------------------------------------------------------------------
  ; Adds options to Windows tray menu (also called Notification Area).
  ;-----------------------------------------------------------------------------
  Menu, Tray, NoStandard ; default options incompatible, must use custom created options
  if userLanguage = "es"
  {
    Menu, tray, add, Configurar el comienzo automático, StartupConfig
    Menu, Tray, add, Desintalar, RunUninstall
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
  if userLanguage = "es"
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
      if userLanguage = "es"
      {
        Msgbox, Ya comience automáticamente. Nada cambió.
      }
      else
      {
        Msgbox, Program already auto-starts. No changes made.
      }
      return
    }
    ; sometimes when compiled AHK is not fully loaded at this point
    ; to avoid errors, give time for it to load
    Sleep, 60000
    FileMove, %path%, %A_Startup%, 1
    FileMove, %A_ScriptFullPath%, %A_Startup%, 1
    if ErrorLevel {
      if userLanguage = "es"
      {
        Msgbox,
        (
          Error: No podemos mudarse el archivo a la carpeta necesaria para
          comenzarla automáticamente. Eso probablemente occurió porque el
          archivo está en una unidad externa (como una memoria USB) o por una
          política de Directorio Activo o porque no podía cargar en suficiente
          tiempo. Controles de multimedia para todos continuará ejecutar, pero
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
        FileMove, %path%, %A_Desktop%, 1
        Run, %A_Desktop%\%A_ScriptName%
        ExitApp
      }
  }
  return
}

initialSetup() {
  ;-----------------------------------------------------------------------------
  ; Calls for pop-up to configure startup settings if this is the first time
  ; they program is being ran.
  ;-----------------------------------------------------------------------------
  if !FileExist(path) ; check to see if first time running program
  {
    FileAppend,
    (
    This file is used to see if this is the first time the program Media
    Controls for All is running.
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
  if userLanguage = "es"
  {
    Msgbox, 35, Desintalar,
    (
      ¿Quieres desintalar Controles multimedia para todos?
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
; spacing in this section intentionally obscure in order to manually align text
; programmatic text alignment not available in this scripting language to the best of my knowledge
if userLanguage = "es"
{
  Msgbox, , Ayuda,
(
Controles del volumen:
Pulsar (al mismo tiempo)...     Para...
Ctrl + Mayús + flecha arriba    subir el volumen 10 por ciento
Ctrl + Mayús + flecha abajo     bajar el volumen 10 por ciento
Alt + flecha abajo              activar/desactivar el silenciamiento

Controles de música:
Pulsar (al mismo tiempo)...     Para...
Ctrl + Alt + Print Screen       tocar/para la música
Ctrl + Alt + flecha derecha     tocar la próxmia canción
Ctrl + Alt + flecha izquierda   tocar la canción anterior
(A veces hay que comenzar a mano la canción de un reproductor de medios (como Spotify) la primera vez la computadora o la aplicación enciende.)

Para comenzar esta aplicación automáticamente (después del login), haz clic con el botón derecho del ratón en el icono de la aplicación y haz clic "Configurar el comienzo automático".

Para salir de esta aplicación, haz clic con el botón derecho del ratón en el icono de la aplicación y haz clic "Salir".

Para desinstalar, haz clic con el botón derecho del ratón en el icono de la aplicación y haz clic "Desintalar".

Si tienes problemas, envíame un correo electrónico a
johnfernow@gmail.com
con el sujeto "Media Controls For All".

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

If you have problems, please email me at johnfernow@gmail.com with "Media Controls For All" in the subject line.

Created by John Fernow.
)
}
return
