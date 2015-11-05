-- GUI for ARitz Cracker Bank (Serverside)
-- This shit is under a Creative Commons Attribution 4.0 International Licence
-- http://creativecommons.org/licenses/by/4.0/
-- You can mess around with it, mod it to your liking, and even redistribute it.
-- However, you must credit me.
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
		if !ply:IsAdmin() && !ply:IsSuperAdmin() then
			ARCSlots.MsgCL(ply,ARCSlots.Msgs.CommandOutput.admin)
		return end
		if ARCSlots.Settings["superadmin_only"] && !ply:IsSuperAdmin() then
			ARCSlots.MsgCL(ply,ARCSlots.Msgs.CommandOutput.superadmin)
		return end
		if ARCSlots.Settings["owner_only"] && string.lower(ply:GetUserGroup()) != "owner" then
			ARCSlots.MsgCL(ply,ARCSlots.Msgs.CommandOutput.superadmin)
		return end
		local setting = net.ReadString()
		local tab = net.ReadTable()
		ARCLib.RecursiveTableMerge(ARCSlots.SpecialSettings[setting],tab)
		ARCSlots.MsgCL(ply,"Advanced setting "..setting.." saved.")
		if setting == "Slot" then
			net.Start("arcslots_prizes")
			for i=1,9 do
				net.WriteUInt(ARCSlots.SpecialSettings.Slot.Prizes[i],32)
			end
			net.Broadcast()
		end
		ARCLib.AddonSaveSpecialSettings("ARCSlots")
	end)
end

