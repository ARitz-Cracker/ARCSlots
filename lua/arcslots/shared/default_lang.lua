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
ARCSlots.Msgs.VaultMsgs.Insecure = "**BREACHED**"
ARCSlots.Msgs.VaultMsgs.GettingCash = "You are entitled to receiving casino profits for the next %TIME%."
ARCSlots.Msgs.VaultMsgs.WithdrawAmount = "You can currently withdraw %AMOUNT%"
ARCSlots.Msgs.VaultMsgs.NotGettingCash = "You are currently not receiving casino profits."
ARCSlots.Msgs.VaultMsgs.PleaseCheckIn = "Please authenticate to start receiving casino profits"
ARCSlots.Msgs.VaultMsgs.CheckIn = "Authenticate as manager"
ARCSlots.Msgs.VaultMsgs.Exit = "Exit"
ARCSlots.Msgs.VaultMsgs.WithdrawCash = "Withdraw earnings as cash"
ARCSlots.Msgs.VaultMsgs.WithdrawBank = "Transfer earnings to bank account"
ARCSlots.Msgs.VaultMsgs.NotManager = "You are not a casino manager"
ARCSlots.Msgs.VaultMsgs.NoCash = "You cannot withdraw that much money"
ARCSlots.Msgs.VaultMsgs.NotAuthed = "You are not authenticated"
ARCSlots.Msgs.VaultMsgs.MaxManagers = "There are already the maximum amount of managers"
ARCSlots.Msgs.VaultMsgs.WhichAccount = "Which account would you like to send your funds to?"
ARCSlots.Msgs.VaultMsgs.Robbed = "The vault was robbed while you were on duty. You may not authenticate until your previous authentication expires or you regained the casino's profits."


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
ARCSlots.SettingsDesc["vault_steal_rate"] = "The amount of money a player can take from the vault per second."

ARCSlots.SettingsDesc["slots_incr"] = "How much the bet should increase by when the + button is pressed"
ARCSlots.SettingsDesc["slots_incr_big"] = "How much the bet should increase by when the ++ button is pressed"
ARCSlots.SettingsDesc["slots_handle"] = "If enabled, the slot machines will have the pull lever on their side"
ARCSlots.SettingsDesc["language"] = "Which language to use. If you want a custom language, create your own file in SERVER/garrysmod/data/_arcbank/languages"
ARCSlots.SettingsDesc["slots_volume"] = "How loud the slot machines should be (Between 0 and 1)"
ARCSlots.SettingsDesc["money_symbol"] = "The symbol of currency to display"
ARCSlots.SettingsDesc["legacy_bet_interface"] = "If enabled, the slot machines will use a popup window to select the bet instead of the immsersive interface."
ARCSlots.SettingsDesc["admins"] = "List of in game rank(s) that can use the admin GUI and the admin commands."
ARCSlots.SettingsDesc["vault_hack_max"] = "The maximum amount of money that can be taken from the vault by hacking it."
ARCSlots.SettingsDesc["vault_hack_min"] = "The minumum amount of money that can be taken from the vault by hacking it."
ARCSlots.SettingsDesc["vault_hack_time_max"] = "The maximum amount of time it takes to hack the vault."
ARCSlots.SettingsDesc["vault_hack_time_min"] = "The minimum amount of time it takes to hack the vault."
ARCSlots.SettingsDesc["vault_hack_time_stealth_rate"] = "Setting the ATM Hacker to \"stealth mode\" will multiply the hacking time by this amount"
ARCSlots.SettingsDesc["vault_hack_time_curve"] = "Please see aritzcracker.ca/uploads/aritz/atm_hack_time_curve.png"
ARCSlots.SettingsDesc["manager_auth_time"] = "The amount of minutes a casino manager will recieve profits after authenticating"
ARCSlots.SettingsDesc["manager_auth_teams"] = "People in these teams will be considered potential casino managers"
