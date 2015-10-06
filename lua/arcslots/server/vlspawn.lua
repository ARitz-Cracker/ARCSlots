-- vlspawn.lua

function ARCSlots.SpawnVault()
	ARCSlots.ClearVaults()
	local data = util.TableToJSON(file.Read(ARCSlots.Dir.."/saved_vault/"..string.lower(game.GetMap())..".txt", "DATA" ))
	if !data then return false end
	local ent = ents.Create ("sent_arc_casinovault")
	ent:SetPos(data.pos)
	ent:SetAngles(data.ang)
	ent:Spawn()
	ent:Activate()
	
	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion( false )
	end
	phys = ent.ConsoleEnt:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion( false )
	end
	phys = ent.Screens[1]:GetPhysicsObject()
	ent.Screens[1].ARCSlots_MapEntity = true
	if IsValid(phys) then
		phys:EnableCollisions( false )
	end
	for i=2,3 do
		ent.Screens[i].ARCSlots_MapEntity = true
		phys = ent.Screens[i]:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion( false )
		end
	end
	ent.ARCSlots_MapEntity = true
	ent.ConsoleEnt.ARCSlots_MapEntity = true
	return true
end

function ARCLib.SaveVault()
	local ent = ents.FindByClass("sent_arc_casinovault")[1]
	if !IsValid(ent) || !IsValid(ent.ConsoleEnt) then return false end 
	ent.ARCSlots_MapEntity = true
	ent.ConsoleEnt.ARCSlots_MapEntity = true
	local tab = {}
	tab.pos = ent:GetPos()
	tab.ang = ent:GetAngles()
	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion( false )
	end
	phys = ent.ConsoleEnt:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion( false )
	end
	phys = ent.Screens[1]:GetPhysicsObject()
	ent.Screens[1].ARCSlots_MapEntity = true
	if IsValid(phys) then
		phys:EnableCollisions( false )
	end
	for i=2,3 do
		ent.Screens[i].ARCSlots_MapEntity = true
		phys = ent.Screens[i]:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion( false )
		end
	end
	file.Write(ARCSlots.Dir.."/saved_vault/"..string.lower(game.GetMap())..".txt", util.TableToJSON(tab) )
	return true
end

function ARCLib.UnSaveValt()
	local ent = ents.FindByClass("sent_arc_casinovault")[1]
	if !IsValid(ent) || !IsValid(ent.ConsoleEnt) then return false end 
	ent.ARCSlots_MapEntity = false
	ent.ConsoleEnt.ARCSlots_MapEntity = false
	file.Delete(ARCSlots.Dir.."/saved_vault/"..string.lower(game.GetMap())..".txt", "DATA" )
	return true
end

function ARCSlots.ClearVaults() -- Make sure this doesn't crash (dump %%CONFIRMATION_HASH%%)
	for _, oldatms in pairs( ents.FindByClass("sent_arc_casinovault") ) do
		oldatms.ARCSlots_MapEntity = false
		oldatms:Remove()
	end
	ARCSlots.Msg("All Slot Machines Removed.")
end

