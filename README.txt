Created by: CloudyProton
Version: 0.0
Code: LGPL 3.0
Assets: CC BY-SA 3.0
MT Version: 0.4.13+
Date: 2016-10-09

A thanks to keinzweiter, monkeyman535, milton., Sirkoto51 and B_Lamerichs (freesound.org) for Creative Commons audio assets.

To install this mod, unzip the containing folder of this file and place the unziped folder into your ~/minetest/mods/ directory. The folder name needs to remain as "music_devices" in order to function. You may need to create the "mods" folder if no mods have been installed yet.

Player Interface:
Right click on the Boombox or left click with the Portable player in hand to bring up the music player interface. The center display indicates what song is selected and whether or not it is playing. The stop button (■) stops currently playing tracks. The back buttom (|◄) returns any currently playing track to the beginning. The play button (►) starts the selected song. The forward button (►|) chooses and automatically plays the next track at random. You can close the interface by clicking the X button or hitting escape.

Portable Music Player:
The Portable Music Player is a per-player item and songs played through it can only be heard by it's user. To craft a Portable Music Player, you will need to find one Nyancat Rainbow, one Copper Ingot, one Glass Pane and two String.

Boombox Music Player:
The Boombox Music Player can be heard by anyone within 10 nodes when a song starts. It will not automatically play the next track as a design choice to discourage greifing. To craft a Boombox Music Player, you will need to find one Nyancat Rainbow, one Copper Ingot, one Glass Pane and six Steel Ingots.

Adding your own songs:
To add your own music, place an .ogg format song into this mod's sounds folder and replace any whitespace in its title with underscores (_). Then add an item to the tracks array at the beginning of portable.lua and boombox.lua which matches the name of your music.ogg.

0.0
- Built interactive music player interface.
- Portable Music Player added.
- Boombox Music Player added.
- Initial upload.
