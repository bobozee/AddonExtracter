# Garry's Mod Addon Content Extracter

A Powershell script to extract all content (everything but lua) from your Garry's Mod addon's folder and (optionally) automatically update your workshop (content) addon with it.
This script is meant to work with locally installed addons. It does not work with Workshop artifacts (.gma), although you can a third party tool to extract them.

## Usage:
  -workshopId: The ID of your workshop (content) addon. If left blank, this script will just directly throw out the content compressed into one folder.
  -changeNote: The change note to push to the workshop update. Defaults to "Updated content" if left blank.
  -addonsDir: The path to your Garry's Mod addons. These have to be extracted addons (with lua, models, etc folder, NOT .gma)
  -garrysBinDir: The path to your Garry's Mod bin folder. Defaults to "C:\Program Files (x86)\Steam\steamapps\common\GarrysMod\bin" if lefft blank.
