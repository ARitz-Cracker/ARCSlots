--stngs.lua - default settings

-- This shit is under copyright.
-- Any 3rd party content has been used as either public domain or with permission.
-- � Copyright 2014-2016 Aritz Beobide-Cardinal All rights reserved.
ARCSlots.Loaded = false
ARCSlots.Settings = {}

--[[
 ____   ___    _   _  ___ _____   _____ ____ ___ _____   _____ _   _ _____   _    _   _   _      _____ ___ _     _____ _ 
|  _ \ / _ \  | \ | |/ _ \_   _| | ____|  _ \_ _|_   _| |_   _| | | | ____| | |  | | | | / \    |  ___|_ _| |   | ____| |
| | | | | | | |  \| | | | || |   |  _| | | | | |  | |     | | | |_| |  _|   | |  | | | |/ _ \   | |_   | || |   |  _| | |
| |_| | |_| | | |\  | |_| || |   | |___| |_| | |  | |     | | |  _  | |___  | |__| |_| / ___ \  |  _|  | || |___| |___|_|
|____/ \___/  |_| \_|\___/ |_|   |_____|____/___| |_|     |_| |_| |_|_____| |_____\___/_/   \_\ |_|   |___|_____|_____(_)

 ____   ___    _   _  ___ _____   _____ ____ ___ _____   _____ _   _ _____   _    _   _   _      _____ ___ _     _____ _ 
|  _ \ / _ \  | \ | |/ _ \_   _| | ____|  _ \_ _|_   _| |_   _| | | | ____| | |  | | | | / \    |  ___|_ _| |   | ____| |
| | | | | | | |  \| | | | || |   |  _| | | | | |  | |     | | | |_| |  _|   | |  | | | |/ _ \   | |_   | || |   |  _| | |
| |_| | |_| | | |\  | |_| || |   | |___| |_| | |  | |     | | |  _  | |___  | |__| |_| / ___ \  |  _|  | || |___| |___|_|
|____/ \___/  |_| \_|\___/ |_|   |_____|____/___| |_|     |_| |_| |_|_____| |_____\___/_/   \_\ |_|   |___|_____|_____(_)
                                                                                                                         

 ____   ___    _   _  ___ _____   _____ ____ ___ _____   _____ _   _ _____   _    _   _   _      _____ ___ _     _____ _ 
|  _ \ / _ \  | \ | |/ _ \_   _| | ____|  _ \_ _|_   _| |_   _| | | | ____| | |  | | | | / \    |  ___|_ _| |   | ____| |
| | | | | | | |  \| | | | || |   |  _| | | | | |  | |     | | | |_| |  _|   | |  | | | |/ _ \   | |_   | || |   |  _| | |
| |_| | |_| | | |\  | |_| || |   | |___| |_| | |  | |     | | |  _  | |___  | |__| |_| / ___ \  |  _|  | || |___| |___|_|
|____/ \___/  |_| \_|\___/ |_|   |_____|____/___| |_|     |_| |_| |_|_____| |_____\___/_/   \_\ |_|   |___|_____|_____(_)
                                                                                                                         
Let me try to explain something to you...
																														 
DO NOT EDIT THIS FILE TO CHANGE THE CONFIG! READ THE README!
These are the default settings in order to prevent you from screwing it up!

arcslots help
^ GIVES YOU A FULL AND DETAILED DESCRIPTION OF ALL COMMANDS

arcslots settings_help (setting)
^ GIVES YOU A FULL DESCRIPTION OF ALL SETTINGS (Leave blank to show a list of all settings.)

arcslots settings (setting) (value)
^ SETS THE SETTING YOU WANT TO THE SPECIFIED VALUE.
]]
function ARCSlots.SettingsReset() --DO NOT EDIT THIS!!!!
	ARCSlots.Settings["slots_max_bet"] = 50 --DO NOT EDIT THIS!!!!
	ARCSlots.Settings["slots_min_bet"] = 25 --DO NOT EDIT THIS!!!!
	ARCSlots.Settings["slots_incr"] = 5 --DO NOT EDIT THIS!!!!
	ARCSlots.Settings["slots_incr_big"] = 10 --DO NOT EDIT THIS!!!!
	ARCSlots.Settings["slots_handle"] = true --DO NOT EDIT THIS!!!!
	ARCSlots.Settings["name"] = "ARCSlots" --DO NOT EDIT THIS!!!!
	ARCSlots.Settings["name_long"] = "ARitz Cracker Gambling" --DO NOT EDIT THIS!!!!

	ARCSlots.Settings["slots_idle_text"] = "FEELIN LUCKY TODAY? $$$ COME TRY YOUR LUCK" --DO NOT EDIT THIS!!!!
	ARCSlots.Settings["money_symbol"] = "$" --DO NOT EDIT THIS!!!!
	ARCSlots.Settings["legacy_bet_interface"] = false --DO NOT EDIT THIS!!!!
	ARCSlots.Settings["admins"] = {"owner","superadmin","admin"} --DO NOT EDIT THIS!!!!
	
	ARCSlots.Settings["vault_steal_rate"] = 50
	
	
end
--
ARCSlots.SettingsReset()