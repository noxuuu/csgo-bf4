## Description
This plugin is based on popular BF4 Rank Mod plugin by *pRED (from amxmodx).
Modification is characterised by simplicity, uniqueness, easy installation.
It is one of the few plugins, who survived time try and still have a lot of fans.
Plugin encourages players to compete with each other, earn badges, gain achievements, unblock skills, kill and improve statistics.
Plugin is based on gaining higher ranks, which are dependent on Exp. Exp we get for killing, winning rounds and others.
We can earn 100 badges (25 categories, 4 lvls) and 20 achievements, which gives us bonuses and super skills that makes game easier.

### Requirements

* Working Source-based Game Server with SourceMod installed.
* MySQL database, with a tool such as phpMyAdmin for database management. 
* [SDKHooks](http://forums.alliedmods.net/showthread.php?t=106748) 

### Features

* **Modular** and **Extensible** - This package is organized in modules, where each module is a different SourceMod plugin. You can extend the store, [add new items](https://github.com/alongubkin/store/wiki/Creating-items-for-Store) or anything you can think of just by writing a new SourceMod plugins.
* **Shop** - Players can buy various items from the shop. The item is added to the player's inventory. Items in the shop are organized in categories.
* **Inventory** - The player's personal inventory, allowing for storage for all in-game items. From their inventory, players can use or equip items they own. Items in the inventory are also organized in categories.
* **Loadout** - Players can have multiple sets of equipped items. You can switch between the sets anytime using the loadout menu. You can have specific loadouts for different games, different in-game (TF2) classes, different in-game teams or any combination of them.
* **Distributor** - Every X minutes, all players that are currently connected to server will get Y credits (configurable).
* **Logging** - The plugin maintains full logs of all errors, warnings and information.
* Custom currency name.
* Custom chat triggers for the store main menu, shop, inventory and loadout.

* **Rank System** - There is the rank system, based on players grades, acquired by experience.
* **Experience** - Acquire experience by killing enemies, plant bombs and others.. Experience is needed to get highest rank.
* **Badges** - Allows players to earn badges, who gives them super skills and addons.
* **Achievements** - Allow players to earn achievements.
* **Medals** - Allow players to collect medals for 1/2/3th position in table at the end match.
* **Daily Rewards** - Bonus system for steelworkers (day 1 - exp, day 2 - 2x exp, day 3 - exp and diamond, etc..)
* **Diamods** - Server currency, we can buy special bonuses for them (in shop).
* **Shop** - We can buy there special bonuses (2x exp, badges etc..)
* **Top-Server** - Shows a menu with the top players, SORTED BY experience.
* **Player Info** - Members have a detailed information (rank, weapon frags, kdr, accuracy, medals, badges, etc..)
* **WebDocs** - Plugin is integrated with www site, players can follow their progress there.

## Installation

Just download the attached zip archive and extract to your sourcemod folder intact. Then navigate to your `configs/` directory and add the following entry in `databases.cfg`:
    
    "nox_bf4"
    {
        "driver"        "mysql"
        "host"          "<your-database-host>"
        "database"		"<your-database-name>"
        "user"		    "<username>"
        "pass"		    "<password>"
    }
    
Plugin will create databaseautomatically after running serverfirst time.

## Others
This source is from 2017, and wasn't tested on live server. So if you find a bug, open the issue, but I don't promise I will find time to fix it. 

## License

Copyright (C) 2017  Patryk Szczepański

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.csgo-bf4
