**Spicetify Autoupdater**
=======================================

This updater is intended to automatically update [Spicetify](https://spicetify.app/) everytime you start your computer. It can also be used to update Spicetify as needed if you don't want it to run with every restart.


### Script details:

`spicetify.ps1` checks for updates [`spicetify update --no-restart`] , restores the previous backup [`spicetify restore backup apply --no-restart`], and restarts the client (if running) [`spicetify restart`], and logs all actions into a simple log file.

> [!NOTE]
> A batch file (`update.bat`) is included in case anyone has issues with the powershell script but both function mostly identically.


### How to use:

1. Download latest release zip file
2. Extract zip file wherever you choose
3. Move new `Spicetify Autoupdater` folder wherever you want to save it permanently
4. Run install.ps1 file.
5. Enjoy <3

`start.vbs` will now be set to run everytime you start your computer. You can test the script by running `start.vbs` (just double click it) and checking the `spicetify.log` file to see the results. You can also run the `spicetify.ps1` script directly from the terminal.

> [!IMPORTANT]
> PowerShell defaults to blocking scripts as a security measure so you may need to adjust your settings. This restriction can be bypassed using `powershell.exe -ExecutionPolicy Bypass -File spicetify.ps1`. Alternatively, you can disable the script protection altogether using `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted`.


### Future plans:

- [X] Add additional functionality that will handle full instalation of necessary folders & shortcuts


### Links

* [Spicetify](https://spicetify.app/)
* [Spicetify Docs](https://spicetify.app/docs/getting-started "Getting Started")