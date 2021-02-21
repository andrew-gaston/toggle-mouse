Powershell script to quickly enable/disable all mouse devices on your PC. Tested using Windows 10 only.
# Examples
## Toggle based on current state
toggle_mouse.ps1 
## Explicitly enable
toggle_mouse.ps1 -enable 
## Explicitly disable
toggle_mouse.ps1 -disable 
# Usage ideas
1. Bind to a hotkey. My choice is to use it with AutoHotKey. Gives you flexibility, but also you have to make a conscious decision to re-enable.
2. Run using Task Scheduler. It will disable my mouse during work hours and then re-enable it after work.