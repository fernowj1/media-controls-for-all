![](images/logo_en.png)  
Add volume and music controls to keyboards that don't have dedicated buttons for them.

#### Translations
* [Español](README-es.md)

## Features
By using hotkeys (pressing combination of keys at same time), this program adds the following features to keyboards without dedicated media buttons.
* volume up &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (Ctrl + Shift + up arrow)
* volume down &nbsp;(Ctrl + Shift + down arrow)
* mute/unmute &nbsp;(Alt + down arrow)
* next song &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(Ctrl + Alt + right arrow)
* previous song (Ctrl + Alt + left arrow)
* play/pause &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(Ctrl + Alt + Print Screen)

## Download and Setup
<!---
Add link to YouTube video of me showing how to download and setup this program
-->
A link to download this program will be added once this program has been fully
tested. Once downloaded, click on the downloaded file, and it will run.  

<!---
Add animated SVG of showing how to do this
-->

By default, this program will stop running after log-out, and will require you
to click on it each time you log-in to utilize its features. If you want to run
this program automatically every time you log-in, go to the Windows tray menu,
right click on the *Media Controls for All* logo, and click "Configure Automatic
Startup".  

<!---
Add animated SVG of showing how to do this
-->

To uninstall, go to the same menu again, and click "No". It will stop starting
the program automatically, and you can then just delete the downloaded file.  

## Development
If you are interested in modifying this project, you will need to [install the
program AutoHotkey](https://www.autohotkey.com/). From there, you can modify
main.ahk and just execute that script to test. When you are happy with the
modifications, open Ahk2Exe (included with AutoHotkey installation) and link the
modified script and an .ico file for the icon.  

This program is currently only available for Windows, since it is dependent on
AutoHotkey, a Windows only program. Fortunately, almost all Macs come with
keyboards that have media keys. For Linux users, some distributions allow you
to create your own shortcuts (including media controls) without even writing a
script, but rather just going to settings, selecting a function, and then
pressing those keys. Specific setup, though, undoubtedly depends on your
distribution.

<!---
Add link to YouTube video of me showing how to do it on Ubuntu.
-->

### Creator
John Fernow
<!---
Add link to website, GitLab, GitHub, Twitter, Instagram, and YouTube channel.
-->

### Copyright and License
Code released under the [MIT License](LICENSE).
