-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.
if ARCSlots then
	util.AddNetworkString( "ARCSlots_Admin_GUI" )
	ARCSlots.Commands["admin_gui"] = {
		command = function(ply,args) 
			if !ARCSlots.Loaded then ARCSlots.MsgCL(ply,ARCSlots.Msgs.CommandOutput.SysReset) return end
			if !args[1] then
				local place = 0
				local tab = {}
				
				for k,v in pairs(ARCSlots.SpecialSettings) do
					place = place + 1
					tab[place] = k
				end
				net.Start( "ARCSlots_Admin_GUI" )
				net.WriteString("")
				net.WriteTable(tab)
				net.Send(ply)
			elseif args[1] == "logs" then
				net.Start( "ARCSlots_Admin_GUI" )
				net.WriteString("logs")
				net.WriteTable(file.Find( ARCSlots.Dir.."/systemlog*", "DATA", "datedesc" ) )
				net.Send(ply)
			elseif args[1] == "adv" then
				if ARCSlots.SpecialSettings[args[2]] then
					net.Start( "ARCSlots_Admin_GUI" )
					net.WriteString("adv_"..args[2])
					net.WriteTable(ARCSlots.SpecialSettings[args[2]])
					net.Send(ply)
				end
			else
				ARCSlots.MsgCL(ply,"Invalid AdminGUI request")
			end
		end, 
		usage = "",
		description = "Opens the admin interface.",
		adminonly = true,
		hidden = false
	}
	net.Receive("ARCSlots_Admin_GUI",function(len,ply) 
		if !table.HasValue(ARCSlots.Settings.admins,string.lower(ply:GetUserGroup())) then
			ARCSlots.MsgCL(ply,ARCLib.PlaceholderReplace(ARCSlots.Msgs.CommandOutput.AdminCommand,{RANKS=table.concat( ARCSlots.Settings.admins, ", " )}))
		return end
		
		local setting = net.ReadString()
		local tab = net.ReadTable()
		ARCLib.RecursiveTableMerge(ARCSlots.SpecialSettings[setting],tab)
		ARCSlots.MsgCL(ply,ARCLib.PlaceholderReplace(ARCSlots.Msgs.CommandOutput.AdvSettingsSaved,{SETTING=setting}))
		if setting == "Slot" then
			net.Start("arcslots_prizes")
			for i=1,9 do
				net.WriteUInt(ARCSlots.SpecialSettings.Slot.Prizes[i],32)
			end
			net.Broadcast()
			if ARCSlots.SpecialSettings.Slot.Profit < 1 then
				ARCSlots.SpecialSettings.Slot.Profit = 1
			end
		end
		ARCLib.AddonSaveSpecialSettings("ARCSlots")
	end)
end

