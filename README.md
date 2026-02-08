# Garry's Mod Addon Content Extracter

A Powershell script to extract all content (everything but lua) from your Garry's Mod addon's folder and (optionally) automatically update your workshop addon with it. This is useful if you have a seperate addon just for the content of your addon or your server.

This script is meant to work with locally installed addons. It does **not** work with Workshop artifacts (.gma), although you can a third party tool to extract them.

Make sure to be signed into Steam if you wish for your workshop addon to be updated, as this script uses *gmpublish.exe* from your Garry's Mod installation.

## Usage:

  - **-workshopId**: The ID of your workshop (content) addon. If left blank, this script will just directly throw out the content compressed into one folder, called *extracted-addon-content*, at the same location as the script.

  - **-changeNote**: If updating workshop addon: The change note to push to the workshop update. Defaults to "*Updated content*" if left blank.
    
  - **-addonJson**: If updating workshop addon: The path to the *addon.json* file for your workshop addon. Defaults to the current directory.

  - **-addonsDir**: The path to your Garry's Mod addons. These have to be extracted addons (with lua, models, etc folder, NOT .gma). If you extract local addons from your server, then point to the addons folder of your server. Defaults to "*C:\Program Files (x86)\Steam\steamapps\common\GarrysMod\garrysmod\addons*" if left blank.

  - **-garrysBinDir**: The path to your Garry's Mod bin folder. Defaults to "*C:\Program Files (x86)\Steam\steamapps\common\GarrysMod\bin*" if left blank.
