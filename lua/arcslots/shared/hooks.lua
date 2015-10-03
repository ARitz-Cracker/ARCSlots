
hook.Add( "ARCLoad_OnUpdate", "ARCSlots Remuv",function(loaded)
	if loaded != "ARCSlots" then return end
	if SERVER then
		for k,v in pairs(player.GetAll()) do 
			ARCSlots.MsgCL(v,"Updating...") 
		end
		ARCSlots.SaveDisk()
		ARCSlots.ClearAntennas()
	end
end)

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
	if ent.ARCPhone_MapEntity then return false end 
end )
if SERVER then
	hook.Add( "ShutDown", "ARCSlots Shutdown", function()
		for _, oldatms in pairs( ents.FindByClass("sent_arc_phone_antenna") ) do
			oldatms.ARCSlots_MapEntity = false
			--oldatms:Remove()
		end
		ARCSlots.SaveDisk()
	end)
	hook.Add( "ARCLoad_OnPlayerLoaded", "ARCSlots PlyAuth", function( ply ) 
		if IsValid(ply) && ply:IsPlayer() then
			ARCLib.SendAddonLanguage("ARCSlots",ply)
			ARCLib.SendAddonSettings("ARCSlots",ply) 
		end
	end)
end