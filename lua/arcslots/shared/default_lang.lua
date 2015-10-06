--default_lang.lua - default language

-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

ARCSlots.Msgs = ARCSlots.Msgs or {}
ARCSlots.Msgs.Time = ARCSlots.Msgs.Time or {}
ARCSlots.Msgs.AdminMenu = ARCSlots.Msgs.AdminMenu or {}
ARCSlots.Msgs.Commands = ARCSlots.Msgs.Commands or {}
ARCSlots.Msgs.CommandOutput = ARCSlots.Msgs.CommandOutput or {}
ARCSlots.Msgs.Items = ARCSlots.Msgs.Items or {}
ARCSlots.Msgs.LogMsgs = ARCSlots.Msgs.LogMsgs or {}

ARCSLOTS_ERRORSTRINGS = ARCPHONE_ERRORSTRINGS or {}
ARCSlots.SettingsDesc = ARCSlots.SettingsDesc or {}

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
                                                                                                                         
																														 
These are the default values in order to prevent you from screwing it up!

For a tutorial on how to create your own custom language, READ THE README!

There's even a command that lets you select from a range of pre-loaded languages!

type "arcslots settings language (lang)" in console
(lang) can be the following:
en -- English
fr -- French
ger -- German
pt_br -- Brazilian Portuguese
sp -- Spanish
]]

ARCSLOTS_ERRORSTRINGS[0] = "GIVE YOUR MONEY"

ARCSlots.Msgs.CommandOutput.SysReset = "System reset required!"
ARCSlots.Msgs.CommandOutput.SysSetting = "%SETTING% has been changed to %VALUE%"
ARCSlots.Msgs.CommandOutput.admin = "You must be an admin to use this command!"
ARCSlots.Msgs.CommandOutput.superadmin = "You must be an superadmin to use this command!"
ARCSlots.Msgs.CommandOutput.SettingsSaved = "Settings have been saved!"
ARCSlots.Msgs.CommandOutput.SettingsError = "Error saving settings."

ARCSlots.Msgs.CommandOutput.ResetYes = "System reset!"
ARCSlots.Msgs.CommandOutput.ResetNo = "Error. Check server console for details. Or look at the latest system log located in garrysmod/data/_arcslots on the server."

ARCSlots.Msgs.Items.Phone = "Phone"

ARCSlots.Msgs.Time.nd = "and"
ARCSlots.Msgs.Time.second = "second"
ARCSlots.Msgs.Time.seconds = "seconds"
ARCSlots.Msgs.Time.minute = "minute"
ARCSlots.Msgs.Time.minutes = "minutes"
ARCSlots.Msgs.Time.hour = "hour"
ARCSlots.Msgs.Time.hours = "hours"
ARCSlots.Msgs.Time.day = "day"
ARCSlots.Msgs.Time.days = "days"
ARCSlots.Msgs.Time.forever = "forever"
ARCSlots.Msgs.Time.now = "now"

ARCSlots.Msgs.AdminMenu.Remove = "Remove"
ARCSlots.Msgs.AdminMenu.Add = "Add"
ARCSlots.Msgs.AdminMenu.Description = "Description:"
ARCSlots.Msgs.AdminMenu.Enable = "Enable"
ARCSlots.Msgs.AdminMenu.Settings = "Settings"
ARCSlots.Msgs.AdminMenu.ChooseSetting = "Choose setting"
ARCSlots.Msgs.AdminMenu.Commands = "Commands"
ARCSlots.Msgs.AdminMenu.SaveSettings = "Save Settings"

ARCSlots.Msgs.Commands["slots_save"] = "Save and freeze all Slot machines"
ARCSlots.Msgs.Commands["slots_unsave"] = "Unsave and unfreeze all Slot machines"
ARCSlots.Msgs.Commands["slots_respawn"] = "Respawn frozen Slot machines"

ARCSlots.Msgs.Commands["vault_save"] = "Save and freeze the vault"
ARCSlots.Msgs.Commands["vault_unsave"] = "Unsave and unfreeze the vault"

ARCSlots.SettingsDesc["name"] = "The displayed \"short\" name of the addon."
ARCSlots.SettingsDesc["name_long"] = "The displayed \"long\" name of the addon."
