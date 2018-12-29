; Media Controls for All!
; John Fernow (johnfernow@gmail.com)
; Add hotkeys for volume and media controls to keyboards without dedicated buttons.

; TODO:
; test Spanish version
; code format: make more functions, use case statements instead of if isSpanish (that way more languages can be added)
; instead of adding to desktop, add to original file location. Can save that in media_controls_for_all.txt

#NoEnv ; Avoids checking empty variables to see if they are environment variables (documentation recommends it for all new scripts).
SetWorkingDir %A_ScriptDir%
userLanguage := languageCode_%A_Language% ; Get the name of the system's default language.

if userLanguage in 040a, 080a, 0c0a, 100a, 140a, 180a, 1c0a, 200a, 240a, 280a, 2c0a, 300a, 340a, 380a, 3c0a, 400a, 440a, 480a, 4c0a, 500a
{
  isSpanish := true
}

; add options to tray
Menu, Tray, NoStandard                  ; default options incompatible, must use custom created options
if isSpanish
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

; first-time running prompt
path := A_ScriptDir "\media_controls_for_all.txt"
if !FileExist(path) ; check to see if first time running program
{
  FileAppend, This file is used to see if this is the first time the program Media Controls for All is running.`n, %path%
  StartupSettings()
}

; main controls
^+Up::SoundSet +5                       ; Ctrl + Shift + up -- volume up 10%
^+Down::SoundSet -5                     ; Ctrl + Shift + down -- volume down 10%
^!Left::Media_Prev                      ; Ctrl + Alt + left -- previous song
^!Right::Media_Next                     ; Ctrl + Alt + right -- next song
^!PrintScreen::Media_Play_Pause         ; Ctrl + Alt + printscreen -- play/pause
!DOWN::SoundSet, +1, , mute             ; Alt + down -- toggle the master mute

OpenHelp:
; spacing in this section intentionally obscure in order to manually align text
; programmatic text alignment not available in this scripting language to the best of my knowledge
if isSpanish
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

StartupConfig:
  StartupSettings()
  return

Exit:
ExitApp

RunUninstall:
  if isSpanish
  {
    Msgbox, 35, Uninstall settings,
    (
      ¿Quieres desintalar Controles multimedia para todos?
    )
  }
  else {
    Msgbox, 35, Uninstall settings,
    (
      Do you want to uninstall Media Controls for All?
    )
  }
  IfMsgbox, YES
  {
    FileDelete, %A_ScriptDir%\media_controls_for_all.txt
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


StartupSettings()
{
  if isSpanish
  {
    Msgbox, 35, Startup settings,
    (
      ¿Quieres comenzar esta aplicación automáticamente después del login?
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
      if isSpanish
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
    FileMove, %A_ScriptDir%\media_controls_for_all.txt, %A_Startup%, 1
    FileMove, %A_ScriptFullPath%, %A_Startup%, 1
    ; can't delete  original file if it's on a different drive
    if ErrorLevel {
      FileMove, %A_ScriptFullPath%, %A_Startup%, 1
      if ErrorLevel {
        Msgbox, Trouble moving file.
      }
    }
    Run, %A_Startup%\%A_ScriptName%
    ExitApp
  }
  IfMsgbox, NO
  {
    IfEqual, A_ScriptDir, %A_Startup%
      {
        FileMove, %A_ScriptFullPath%, %A_Desktop%, 1
        FileMove, %A_ScriptDir%\media_controls_for_all.txt, %A_Desktop%, 1
        Run, %A_Desktop%\%A_ScriptName%
        ExitApp
      }
  }
  return
}
