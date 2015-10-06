-- cmds.lua - Commands for ARCSlots (Can be editable using a plugin)

-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- � Copyright 2014 Aritz Beobide-Cardinal All rights reserved.
ARCSlots.Loaded = false
ARCSlots.Commands = { --Make sure they are less then 16 chars long.$
	["about"] = {
		command = function(ply,args) 
			if !ARCSlots.Loaded then ARCSlots.MsgCL(ply,ARCSlots.Msgs.CommandOutput.SysReset) return end
			ARCSlots.MsgCL(ply,"ARitz Cracker Gambling v"..ARCSlots.Version.." Last updated on "..ARCSlots.Update )
			ARCSlots.MsgCL(ply,ARCSlots.About)
		end, 
		usage = "",
		description = "About ARitz Cracker Gambling.",
		adminonly = false,
		hidden = false
	},
	["help"] = {
		command = function(ply,args) 
			if !ARCSlots.Loaded then ARCSlots.MsgCL(ply,ARCSlots.Msgs.CommandOutput.SysReset) return end
			if args[1] then
				if ARCSlots.Commands[args[1]] then
					ARCSlots.MsgCL(ply,args[1]..tostring(ARCSlots.Commands[args[1]].usage).." - "..tostring(ARCSlots.Commands[args[1]].description))
				else
					ARCSlots.MsgCL(ply,"No such command as "..tostring(args[1]))
				end
			else
				local cmdlist = "\n*** ARCSLOTS HELP MENU ***\n\nSyntax:\n<name(type)> = required argument\n[name(type)] = optional argument\n\nList of commands:"
				for key,a in SortedPairs(ARCSlots.Commands) do
					if !ARCSlots.Commands[key].hidden then
						local desc = "*                                                 - "..ARCSlots.Commands[key].description.."" -- +2
						for i=1,string.len( key..ARCSlots.Commands[key].usage ) do
							desc = string.SetChar( desc, (i+2), string.GetChar( key..ARCSlots.Commands[key].usage, i ) )
						end
						cmdlist = cmdlist.."\n"..desc
					end
				end
				for _,v in pairs(string.Explode( "\n", cmdlist ))do
					ARCSlots.MsgCL(ply,v)
				end
			end
			
		end, 
		usage = " [command(string)]",
		description = "Gives you a description of every command.",
		adminonly = false,
		hidden = false
	},
	["owner"] = {
		command = function(ply,args) 
			ARCSlots.MsgCL(ply,"%%SID%%")
		end, 
		usage = "",
		description = "Who owns this copy of ARCSlots?",
		adminonly = false,
		hidden = true
	},
	["print_json"] = {
		command = function(ply,args) 
			if !ARCSlots.Loaded then ARCSlots.MsgCL(ply,ARCSlots.Msgs.CommandOutput.SysReset) return end
			local translations = {}
			translations.errmsgs = ARCBANK_ERRORSTRINGS
			translations.msgs = ARCSlots.Msgs
			translations.settingsdesc = ARCSlots.SettingsDesc
			local strs = ARCLib.SplitString(util.TableToJSON(translations),4000)
			for i = 1,#strs do
				Msg(strs[i])
			end
			Msg("\n")
		end, 
		usage = "",
		description = "Prints a JSON of all the translation shiz.",
		adminonly = true,
		hidden = true
	},
	["slots_save"] = {
		command = function(ply,args)
			if !ARCSlots.Loaded then ARCSlots.MsgCL(ply,"System reset required!") return end
			ARCSlots.MsgCL(ply,"Saving Slot Machines to map...")
			if ARCSlots.SaveSlotMachines() then
				ARCSlots.MsgCL(ply,"Slot Machines saved onto map!")
			else
				ARCSlots.MsgCL(ply,"An error occurred while saving the Slot Machines onto the map.")
			end
		end, 
		usage = "",
		description = "Makes all active Slot Machines a part of the map.",
		adminonly = true,
		hidden = false
	},
	["slots_unsave"] = {
		command = function(ply,args)
			if !ARCSlots.Loaded then ARCSlots.MsgCL(ply,"System reset required!") return end
			ARCSlots.MsgCL(ply,"Detatching Slot Machines from map...")
			if ARCSlots.UnSaveSlotMachines() then
				ARCSlots.MsgCL(ply,"Slot Machines Detached from map!")
			else
				ARCSlots.MsgCL(ply,"An error occurred while detaching Slot Machines from map.")
			end
		end, 
		usage = "",
		description = "Makes all saved Slot Machines moveable again.",
		adminonly = true,
		hidden = false
	},
	["slots_respawn"] = {
		command = function(ply,args) 
			if !ARCSlots.Loaded then ARCSlots.MsgCL(ply,"System reset required!") return end
			ARCSlots.MsgCL(ply,"Spawning Map-Based Slot Machines...")
			if ARCSlots.SpawnSlotMachines() then
				ARCSlots.MsgCL(ply,"Map-Based Slot Machines Spawned!")
			else
				ARCSlots.MsgCL(ply,"No Slot Machines associated with this map. (Non-existent/Currupt file)")
			end
		end, 
		usage = "",
		description = "Respawns all Map-Based Slot Machines.",
		adminonly = true,
		hidden = false
	},
	["reset_settings"] = {
		command = function(ply,args) 
			ARCSlots.SettingsReset()
		end, 
		usage = "",
		description = "Resets all settings to their default. (Doesn't save)",
		adminonly = true,
		hidden = false
	},
	["vault_save"] = {
		command = function(ply,args)
			if !ARCSlots.Loaded then ARCSlots.MsgCL(ply,"System reset required!") return end
			if ARCLib.SaveVault() then
				ARCSlots.MsgCL(ply,"Vault saved!")
			else
				ARCSlots.MsgCL(ply,"There ain't no vault to save")
			end
		end, 
		usage = "",
		description = "Makes all the vault a part of the map.",
		adminonly = true,
		hidden = false
	},
	["vault_unsave"] = {
		command = function(ply,args)
			if !ARCSlots.Loaded then ARCSlots.MsgCL(ply,"System reset required!") return end
			ARCSlots.MsgCL(ply,"Detatching Slot Machines from map...")
			if ARCSlots.UnSaveValt() then
				ARCSlots.MsgCL(ply,"Slot Machines Detached from map!")
			else
				ARCSlots.MsgCL(ply,"An error occurred while detaching Slot Machines from map.")
			end
		end, 
		usage = "",
		description = "Makes all the vault moveable again.",
		adminonly = true,
		hidden = false
	},
	["reset"] = {
		command = function(ply,args) 
			ARCSlots.MsgCL(ply,"Resetting ARCSlots system...")
			ARCSlots.SaveDisk()
			ARCSlots.Load()
			timer.Simple(math.Rand(4,5),function()
				if ARCSlots.Loaded then
					ARCSlots.MsgCL(ply,"System reset!")
				else
					ARCSlots.MsgCL(ply,"Error. Check server console for details.")
				end
			end)
		end, 
		usage = "",
		description = "Updates settings and checks for any currupt or invalid accounts. (SAVE YOUR SETTINGS BEFORE DOING THIS!)",
		adminonly = true,
		hidden = false}
}

ARCLib.AddSettingConsoleCommands("ARCSlots")
ARCLib.AddAddonConcommand("ARCSlots","arcslots") 