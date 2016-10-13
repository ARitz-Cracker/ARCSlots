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
ARCSlots.Msgs.Notifications = ARCSlots.Msgs.Notifications or {}
ARCSlots.Msgs.SlotMsgs = ARCSlots.Msgs.SlotMsgs or {}
ARCSlots.Msgs.VaultMsgs = ARCSlots.Msgs.VaultMsgs or {}

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

ARCSlots.Msgs.CommandOutput.SysReset = "System reset required! Please enter \"arcslots reset\""
ARCSlots.Msgs.CommandOutput.SysSetting = "%SETTING% has been changed to %VALUE%"
ARCSlots.Msgs.CommandOutput.AdminCommand = "You must be one of these ranks to use this command: %RANKS%"
ARCSlots.Msgs.CommandOutput.SettingsSaved = "Settings have been saved!"
ARCSlots.Msgs.CommandOutput.AdvSettingsSaved = "Advanced setting %SETTING% saved."
ARCSlots.Msgs.CommandOutput.SettingsError = "Error saving settings."

ARCSlots.Msgs.CommandOutput.ResetYes = "System reset!"
ARCSlots.Msgs.CommandOutput.ResetNo = "Error. Check server console for details. Or look at the latest system log located in garrysmod/data/_arcslots on the server."

ARCSlots.Msgs.CommandOutput.SaveSlots = "Slot Machines saved!"
ARCSlots.Msgs.CommandOutput.SaveSlotsNo = "Error while saving slot machines."
ARCSlots.Msgs.CommandOutput.UnSaveSlots = "Slot Machines detached from map!"
ARCSlots.Msgs.CommandOutput.UnSaveSlotsNo = "An error occurred while detaching Slot Machines from map."
ARCSlots.Msgs.CommandOutput.SpawnSlots = "Map-Based Slot Machines Spawned!"
ARCSlots.Msgs.CommandOutput.SpawnSlotsNo = "No Slot Machines associated with this map. (Non-existent/Corrupt file)"

ARCSlots.Msgs.CommandOutput.SaveVault = "Casino Vault and alarms saved!"
ARCSlots.Msgs.CommandOutput.SaveVaultNo = "Error while saving vault and alarms."
ARCSlots.Msgs.CommandOutput.UnSaveVault = "Casino Vault and alarms detached from map"
ARCSlots.Msgs.CommandOutput.UnSaveVaultNo = "An error occurred while detaching the Casino Vault from map."

ARCSlots.Msgs.Items.SlotMachine = "Slot Machine"

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
ARCSlots.Msgs.AdminMenu.AdvSettings = "Advanced Settings"
ARCSlots.Msgs.AdminMenu.ChooseSetting = "Choose setting"
ARCSlots.Msgs.AdminMenu.Commands = "Commands"
ARCSlots.Msgs.AdminMenu.SaveSettings = "Save Settings"
ARCSlots.Msgs.AdminMenu.Logs = "System Logs"
ARCSlots.Msgs.AdminMenu.Unavailable = "This feature is currently unavailable"

ARCSlots.Msgs.AdminMenu.SlotConfig = "Slot machine configuration menu"
ARCSlots.Msgs.AdminMenu.SlotIncome = "Income multiplier:"
ARCSlots.Msgs.AdminMenu.FreeSpin = "Free spin percent chance:"
ARCSlots.Msgs.AdminMenu.SlotPrize = "Prize:"
ARCSlots.Msgs.AdminMenu.SlotChance = "Chances:"
ARCSlots.Msgs.AdminMenu.Explination = "Some of these setting options are counter-intuitive and require explination. Would you like to see the explination?"


ARCSlots.Msgs.Notifications.NoMoney = "You do not have enough cash!"
ARCSlots.Msgs.Notifications.Pocket = "No matter how hard to try, you can't fit this giant thing in your pants!"
ARCSlots.Msgs.Notifications.AlarmVault = "You cannot spawn an alarm without a vault"
ARCSlots.Msgs.Notifications.VaultOne = "There can only be one vault"
ARCSlots.Msgs.Notifications.VaultARCBank = "The vault requires ARCBank v1.3.6 or later (the paid version)"

ARCSlots.Msgs.SlotMsgs.Yes = "Yes"
ARCSlots.Msgs.SlotMsgs.No = "No"


ARCSlots.Msgs.SlotMsgs.Lucky = "Feeling lucky today?"
ARCSlots.Msgs.SlotMsgs.Win = "YOU WON %AMOUNT%"
ARCSlots.Msgs.SlotMsgs.MegaWin = "WOW YOU WON %AMOUNT%"
ARCSlots.Msgs.SlotMsgs.Jackpot = "CONGRATULATIONS YOU HAVE WON THE MEGA JACKPOT *** YOU WON %AMOUNT%"

ARCSlots.Msgs.SlotMsgs.LooseMock = "HA HA HA NOT TODAY"
ARCSlots.Msgs.SlotMsgs.Loose = "BETTER LUCK NEXT TIME"
ARCSlots.Msgs.SlotMsgs.FreeSpins = "%AMOUNT% FREE SPINS!"

ARCSlots.Msgs.SlotMsgs.Bet = "bet"
ARCSlots.Msgs.SlotMsgs.BadLuck = "Being broke is bad Luck! If you get that bad card, you loose!"
ARCSlots.Msgs.SlotMsgs.Wild = "The WILD card can substitute for any other symbol!"
ARCSlots.Msgs.SlotMsgs.MaxPrize = "MAX PRIZE: %AMOUNT%"

ARCSlots.Msgs.SlotMsgs.BetMsg = "Select the amount you wish to bet:"


ARCSlots.Msgs.VaultMsgs.Funds = "VAULT FUNDS:"
ARCSlots.Msgs.VaultMsgs.TotalFunds = "TOTAL FUNDS:"
ARCSlots.Msgs.VaultMsgs.Status = "VAULT STATUS:"
ARCSlots.Msgs.VaultMsgs.Secure = "**SECURE**"
ARCSlots.Msgs.VaultMsgs.Warning = "** WARNING **"
ARCSlots.Msgs.VaultMsgs.Insecure = "**BREACHED**:"

ARCSlots.Msgs.Commands["slots_save"] = "Save all Slot machines"
ARCSlots.Msgs.Commands["slots_unsave"] = "Unsave all Slot machines"
ARCSlots.Msgs.Commands["slots_respawn"] = "Respawn Slot machines"

ARCSlots.Msgs.Commands["vault_save"] = "Save the vault"
ARCSlots.Msgs.Commands["vault_unsave"] = "Unsave the vault"

ARCSlots.SettingsDesc["name"] = "The displayed \"short\" name of the addon."
ARCSlots.SettingsDesc["name_long"] = "The displayed \"long\" name of the addon."
ARCSlots.SettingsDesc["slots_max_bet"] = "The maximum people can bet on the Slot Machines"
ARCSlots.SettingsDesc["slots_min_bet"] = "The minimum people can bet on the Slot Machines"
ARCSlots.SettingsDesc["slots_idle_text"] = "Text to display while the slot machine is idle"
ARCSlots.SettingsDesc["vault_steal_rate"] = "The amount of money a player can take per second."
ARCSlots.SettingsDesc["superadmin_only"] = "Only superadmins can use admin commands"
ARCSlots.SettingsDesc["owner_only"] = "Only someone with the \"owner\" usergroup can use admin commands (WARNING! IF YOU DON'T HAVE AN OWNER RANK, DO NOT ENABLE THIS SETTING)"

