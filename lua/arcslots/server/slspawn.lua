-- slspawn.lua - Slots spawner
-- This file is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2015 Aritz Beobide-Cardinal All rights reserved.

function ARCSlots.SpawnSlotMachines()
	local shit = file.Read(ARCSlots.Dir.."/saved_atms/"..string.lower(game.GetMap())..".txt", "DATA" )
	if !shit then
		ARCSlots.Msg("Cannot spawn Slot Machines. No file associated with this map.")
		return false
	end
	local atmdata = util.JSONToTable(shit)
	if !atmdata then
		ARCSlots.Msg("Cannot spawn Slot Machines. Corrupt file associated with this map.")
		return false
	end
	for _, oldatms in pairs( ents.FindByClass("sent_arc_antenna") ) do
		oldatms.ARCSlots_MapEntity = false
		oldatms:Remove()
	end
	ARCSlots.Msg("Spawning Map Slot Machines...")
	for i=1,atmdata.atmcount do
			local shizniggle = ents.Create("sent_arc_antenna")
			if !IsValid(shizniggle) then
				atmdata.atmcount = 1
				ARCSlots.Msg("Slot Machines failed to spawn.")
			return false end
			if atmdata.pos[i] && atmdata.angles[i] then
				shizniggle:SetPos(atmdata.pos[i]+Vector(0,0,ARCLib.BoolToNumber(!atmdata.NewATMModel)*8.6))
				shizniggle:SetAngles(atmdata.angles[i])
				shizniggle:SetPos(shizniggle:GetPos()+(shizniggle:GetRight()*ARCLib.BoolToNumber(!atmdata.NewATMModel)*-4.1)+(shizniggle:GetForward()*ARCLib.BoolToNumber(!atmdata.NewATMModel)*19))
				if atmdata.atmtype then
					shizniggle.ARCSlots_InitSpawnType = atmdata.atmtype[i]
				end
				shizniggle:Spawn()
				shizniggle:Activate()
			else
				shizniggle:Remove()
				atmdata.atmcount = 1
				ARCSlots.Msg("Corrupt File")
				return false 
			end
			local phys = shizniggle:GetPhysicsObject()
			if IsValid(phys) then
				phys:EnableMotion( false )
			end
			shizniggle.ARCSlots_MapEntity = true
			shizniggle.ARitzDDProtected = true
	end
	return true
end
function ARCSlots.SaveSlotMachines()
	ARCSlots.Msg("Saving Slot Machines...")
	local atmdata = {}
	atmdata.angles = {}
	atmdata.pos = {}
	atmdata.atmtype = {}
	local atms = ents.FindByClass("sent_arc_slotmachine")
	atmdata.atmcount = table.maxn(atms)
	atmdata.NewATMModel = true
	if atmdata.atmcount <= 0 then
		ARCSlots.Msg("No Slot Machines to save!")
		return false
	end
	for i=1,atmdata.atmcount do
		local phys = atms[i]:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion( false )
		end
		atms[i].ARCSlots_MapEntity = true
		atms[i].ARitzDDProtected = true
		atmdata.pos[i] = atms[i]:GetPos()
		atmdata.angles[i] = atms[i]:GetAngles()
		atmdata.atmtype[i] = atms[i]:GetATMType()
	end
	PrintTable(atmdata)
	local savepos = ARCSlots.Dir.."/saved_atms/"..string.lower(game.GetMap())..".txt"
	file.Write(savepos,util.TableToJSON(atmdata))
	if file.Exists(savepos,"DATA") then
		ARCSlots.Msg("Slot Machines Saved in: "..savepos)
		return true
	else
		ARCSlots.Msg("Error while saving map.")
		return false
	end
end
function ARCSlots.UnSaveSlotMachines()
	ARCSlots.Msg("UnSaving Slot Machines...")
	local atms = ents.FindByClass("sent_arc_slotmachine")
	if table.maxn(atms) <= 0 then
		ARCSlots.Msg("No Slot Machines to Unsave!")
		return false
	end
	for i=1,table.maxn(atms) do
		local phys = atms[i]:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion( true )
		end
		atms[i].ARCSlots_MapEntity = false
		atms[i].ARitzDDProtected = false
	end
	local savepos = ARCSlots.Dir.."/saved_atms/"..string.lower(game.GetMap())..".txt"
	file.Delete(savepos)
	return true
end
function ARCSlots.ClearSlotMachines() -- Make sure this doesn't crash (dump %%CONFIRMATION_HASH%%)
	for _, oldatms in pairs( ents.FindByClass("sent_arc_slotmachine") ) do
		oldatms.ARCSlots_MapEntity = false
		oldatms:Remove()
	end
	ARCSlots.Msg("All Slot Machines Removed.")
end
