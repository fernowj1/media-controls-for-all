; Media Controls for All!
; John Fernow (johnfernow@gmail.com)
; Add hotkeys for volume and media controls to keyboards without dedicated buttons.

; TODO:
; improve help format
; test Spanish version

#NoEnv ; Avoids checking empty variables to see if they are environment variables (documentation recommends it for all new scripts).
SetWorkingDir %A_ScriptDir%
userLanguage := languageCode_%A_Language% ; Get the name of the system's default language.
if userLanguage in 040a, 080a, 0c0a, 100a, 140a, 180a, 1c0a, 200a, 240a, 280a, 2c0a, 300a, 340a, 380a, 3c0a, 400a, 440a, 480a, 4c0a, 500a
{
  isSpanish := true
}

; add options to tray
Menu, Tray, NoStandard                    ; default options incompatible, must use custom created options
if isSpanish
{
  Menu, tray, add, Configurar el login, StartupConfig
  IfEqual, A_ScriptDir, %A_Startup%
     {
        Menu, tray, ToggleCheck, Configurar el login
     }
  Menu, Tray, add, Ayuda, OpenHelp
  Menu, tray, add, Salir, Exit
}
; default to English
else {
  Menu, tray, add, Start on log-in configuration, StartupConfig
  IfEqual, A_ScriptDir, %A_Startup%
     {
        Menu, tray, ToggleCheck, Start on log-in configuration
     }
  Menu, Tray, add, Help, OpenHelp
  Menu, tray, add, Exit, Exit
}
; main controls
^+Up::SoundSet +5                       ; Ctrl + Shift + up volume up 10%
^+Down::SoundSet -5                     ; Ctrl + Shift + down volume down 10%
^!Left::Media_Prev                      ; Ctrl + Alt + left
^!Right::Media_Next                     ; Ctrl + Alt + right
^!PrintScreen::Media_Play_Pause         ; Ctrl + Alt + printscreen
!DOWN::SoundSet, +1, , mute             ; Toggle the master mute (set it to the opposite state) Alt + down

OpenHelp:
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
    Ctrl + Alt + Print Screen       tocar/para la música (hay que comenzar a mano la canción de un reproductor de medios (como Spotify) la primera vez la computadora enciende.)
    Ctrl + Alt + flecha derecha     tocar la próxmia canción
    Ctrl + Alt + flecha izquierda   tocar la canción anterior

    Para comenzar esta aplicación automáticamente (después del login), haz clic con el botón derecho del ratón en el icono de la aplicación y haz clic "Configurar el login".

    Para salir de esta aplicación, haz clic con el botón derecho del ratón en el icono de la aplicación y haz clic "Salir".

    Para desinstalar, bora este archivo: %A_ScriptFullPath%

    Si tienes problemas, envíame un correo electrónico a
    johnfernow@gmail.com
    con el sujeto "Media Controls For All".
  )
}
else {                                ; default to English
  Msgbox, , Help,
  (
    Volume controls:
    Press (at same time)...     To...
    Ctrl + Shift + up arrow     increase volume 10 percent
    Ctrl + Shift + down arrow   decrease volume 10 percent
    Alt + down arrow            mute/unmute sound

    Music controls:
    Press (at same time)...     To...
    Ctrl + Alt + Print Screen   play/pause music (have to start song manually from music player first time PC boots)
    Ctrl + Alt + right arrow    play next song
    Ctrl + Alt + left arrow     play previous song

    To run this program at log-in, right click on the program's icon and click "Startup settings".

    To quit this program, right click on the program's icon and click Exit.

    To uninstall, delete this file: %A_ScriptFullPath%

    If you have problems, please email me at
    johnfernow@gmail.com
    with "Media Controls For All" in the subject line.
  )
}
return

StartupConfig:
if isSpanish {
  Msgbox, 35, Startup settings,
  (
    ¿Quieres comenzar esta aplicación automáticamente después del login?
  )
  IfMsgbox, YES
  {
    IfEqual, A_ScriptDir, %A_Startup%
    {
      Msgbox, Ya comience automáticamente. Nada cambió.
      return
    }
    FileMove, %A_ScriptFullPath%, %A_Startup%, 1
    ; can't delete  original file if it's on a different drive
    if ErrorLevel
      Msgbox, Error: no podemos encontrar el archivo. Por favor, intenta ponerlo en disco primario.
    ; can't simply reload, because not in original location anymore
    ; all of this is so can move to startup, then move out without restarting script manually
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
    else
    {
      Msgbox, Ya no ejecuta automáticamente. Nada cambió.
    }
  }
}
else {
  Msgbox, 35, Startup settings,
  (
    Do you want to start this program automatically after login?
  )
  IfMsgbox, YES
  {
    IfEqual, A_ScriptDir, %A_Startup%
    {
      Msgbox, Program already auto-starts. No changes made.
      return
    }
    FileMove, %A_ScriptFullPath%, %A_Startup%, 1
    ; can't delete  original file if it's on a different drive
    if ErrorLevel
      Msgbox, Error: file could not be found. Try moving file to your main drive.
    ; can't simply reload, because not in original location anymore
    ; all of this is so can move to startup, then move out without restarting script manually
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
    else
    {
      Msgbox, Already was not auto-starting. No action taken.
    }
  }
}
return

Exit:
ExitApp
