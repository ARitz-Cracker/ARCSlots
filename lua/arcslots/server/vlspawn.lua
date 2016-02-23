-- vlspawn.lua

function ARCSlots.SpawnVault()
	ARCSlots.ClearVaults()
	local str = file.Read(ARCSlots.Dir.."/saved_vault/"..string.lower(game.GetMap())..".txt", "DATA" )
	if !str then return end
	local data = util.JSONToTable(str)
	if !data then return false end
	local ent = ents.Create ("sent_arc_casinovault")
	ent:SetPos(data.pos)
	ent:SetAngles(data.ang)
	ent:Spawn()
	ent:Activate()
	if !IsValid(ent.ConsoleEnt) then return end
	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion( false )
	end
	phys = ent.ConsoleEnt:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion( false )
	end
	for i=1,3 do
		ent.Screens[i].ARCSlots_MapEntity = true
		phys = ent.Screens[i]:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion( false )
		end
	end
	ent.ARCSlots_MapEntity = true
	ent.ConsoleEnt.ARCSlots_MapEntity = true
	
	if !data.alarms then return end
	for i=1,#data.alarms do
		local ent = ents.Create("sent_arc_casinoalarm")
		ent:SetPos(data.alarms[i].pos)
		ent:SetAngles(data.alarms[i].ang)
		ent:Spawn()
		ent:Activate()
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion( false )
		end
		ent.ARCSlots_MapEntity = true
	end
	
	return true
end

function ARCSlots.SaveVault()
	local ent = ents.FindByClass("sent_arc_casinovault")[1]
	if !IsValid(ent) || !IsValid(ent.ConsoleEnt) then return false end 
	ent.ARCSlots_MapEntity = true
	ent.ConsoleEnt.ARCSlots_MapEntity = true
	local tab = {}
	tab.pos = ent:GetPos()
	tab.ang = ent:GetAngles()
	tab.alarms = {}
	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion( false )
	end
	phys = ent.ConsoleEnt:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion( false )
	end
	for i=1,3 do
		ent.Screens[i].ARCSlots_MapEntity = true
		phys = ent.Screens[i]:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion( false )
		end
	end
	
	local alarms = ents.FindByClass("sent_arc_casinoalarm")
	for i=1,#alarms do
		tab.alarms[i] = {}
		tab.alarms[i].pos = alarms[i]:GetPos()
		tab.alarms[i].ang = alarms[i]:GetAngles()
		local phys = alarms[i]:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion( false )
		end
		alarms[i].ARCSlots_MapEntity = true
	end
	file.Write(ARCSlots.Dir.."/saved_vault/"..string.lower(game.GetMap())..".txt", util.TableToJSON(tab) )
	return true
end

function ARCSlots.UnSaveValt()
	local ent = ents.FindByClass("sent_arc_casinovault")[1]
	if !IsValid(ent) || !IsValid(ent.ConsoleEnt) then return false end 
	ent.ARCSlots_MapEntity = false
	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion( true )
	end
	ent.ConsoleEnt.ARCSlots_MapEntity = false
	phys = ent.ConsoleEnt:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion( true )
	end
	for i=1,3 do
		ent.Screens[i].ARCSlots_MapEntity = false
		phys = ent.Screens[i]:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion( true )
		end
	end

	local alarms = ents.FindByClass("sent_arc_casinoalarm")
	for i=1,#alarms do
		alarms[i].ARCSlots_MapEntity = false
	end
	
	file.Delete(ARCSlots.Dir.."/saved_vault/"..string.lower(game.GetMap())..".txt", "DATA" )
	return true
end

function ARCSlots.ClearVaults() -- Make sure this doesn't crash (dump %%CONFIRMATION_HASH%%)
	for _, oldatms in pairs( ents.FindByClass("sent_arc_casinovault") ) do
		oldatms.ARCSlots_MapEntity = false
		oldatms:Remove()
	end
	local alarms = ents.FindByClass("sent_arc_casinoalarm")
	for i=1,#alarms do
		alarms[i].ARCSlots_MapEntity = false
		alarms[i]:Remove()
	end
	ARCSlots.Msg("All Slot Machines Removed.")
end

