hook.Add( "PhysgunPickup", "ARCSlots NoPhys", function( ply, ent ) 
	if ent.ARCSlots_MapEntity then return false end 
end)
hook.Add( "CanTool", "ARCSlots NoTool", function( ply, tr, tool  ) 
	if tr.Entity.ARCSlots_MapEntity then return false end 
end)

hook.Add( "CanProperty", "ARCSlots BlockProperties", function( ply, property, ent )
	if ent.ARCSlots_MapEntity then return false end 
end )
hook.Add( "CanPlayerUnfreeze", "ARCSlots BlockUnfreeze", function( ply, ent, phys )
	if ent.ARCSlots_MapEntity then return false end 
end )

local pocketfunction = function(ply,ent)
	if ent.ARCSlots_MapEntity then return false,ARCSlots.Msgs.Notifications.Pocket end 
end
hook.Add( "CanPocket", "ARCSlots Pocket", pocketfunction)
hook.Add( "canPocket", "ARCSlots Pocket", pocketfunction)

if SERVER then
	hook.Add( "ShutDown", "ARCSlots Shutdown", function()
		for _, oldatms in pairs( ents.FindByClass("sent_arc_slotmachine") ) do
			oldatms.ARCSlots_MapEntity = false
			--oldatms:Remove()
		end
		ARCSlots.SaveDisk()
	end)
	hook.Add( "ARCLib_OnPlayerFullyLoaded", "ARCSlots PlyAuth", function( ply ) 
		if IsValid(ply) && ply:IsPlayer() then
			ARCLib.SendAddonLanguage("ARCSlots",ply)
			ARCLib.SendAddonSettings("ARCSlots",ply) 
			net.Start("arcslots_prizes")
			for i=1,9 do
				net.WriteUInt(ARCSlots.SpecialSettings.Slot.Prizes[i],32)
			end
			net.Send(ply)
			net.Start("arcslots_worth")
			net.WriteDouble(ARCSlots.Disk.CasinoFunds)
			net.WriteDouble(ARCSlots.Disk.VaultFunds)
			net.Send(ply)
		end
	end)
	
	--[[
	hook.Add( "ARCLoad_OnUpdate", "ARCSlots RemuvStuffs",function(loaded)
		if loaded != "ARCSlots" then return end
		for k,v in pairs(player.GetAll()) do 
			ARCSlots.MsgCL(v,"Updating...") 
		end
		ARCSlots.SaveDisk()
		ARCSlots.ClearVaults()
		ARCSlots.ClearSlotMachines()
	end)
	]]
else
end
