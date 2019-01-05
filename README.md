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
[Click here to download *Media Controls for All* for Windows](http://bit.ly/MediaControlsForAllv1).

<!---
Add animated SVG of showing how to do this
-->

When you run the program, it will prompt you if you want it to automatically
start or not after log-in. To change this setting, go to the Windows tray menu,
right click on the *Media Controls for All* logo, and click "Configure Automatic
Startup".  

<!---
Add animated SVG of showing how to do this
-->

If you forget the shortcuts, you can always access the "Help" menu to see them.

<!---
Add animated SVG of showing how to do this
-->

To uninstall, go to the same menu again, and click "Uninstall".

<!---
Add animated SVG of showing how to do this
-->

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
