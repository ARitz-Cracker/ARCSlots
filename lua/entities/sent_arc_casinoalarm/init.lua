-- This file is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

util.AddNetworkString("arcslots_alarm")
--[[
net.Receive("arcslots_alarm",function(len,ply)


end)
]]
ENT.ScrType = 1


local function ResetSounds(doit) --Old function name from when the sounds were clientside don't hurt me D:
	local ents = ents.FindByClass("sent_arc_casinoalarm")
	for k,v in pairs(ents) do
		--v:FadeOut(0.1) 
		if v.AlarmSound then
			v.AlarmSound:Stop()
		end
		
	end
	if !doit then return end
	timer.Simple(0.01,function()
		local filter = RecipientFilter()
		filter:AddAllPlayers()
		for k,v in pairs(ents) do
			v.AlarmSound = CreateSound( v, "ambient/alarms/alarm_citizen_loop1.wav", filter ) 
			v.AlarmSound:Play()
		end
	end)
end

function ARCSlots.SoundVaultAlarm(doit)
	
	net.Start("arcslots_alarm")
	ResetSounds(doit)
	net.WriteBit(doit)
	net.Broadcast()
end

function ENT:Initialize()
	if #ents.FindByClass("sent_arc_casinovault") < 1 then
		ARCLib.NotifyBroadcast(ARCSlots.Msgs.Notifications.AlarmVault,NOTIFY_ERROR,5,true)
		self:Remove()
		return
	end

	self:SetModel( "models/props_wasteland/speakercluster01a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self.phys = self:GetPhysicsObject()
	if self.phys:IsValid() then
		self.phys:Wake()
	end
	self:SetUseType( SIMPLE_USE )
	self:SetSkin(1)
	local entin = self:EntIndex()
end

function ENT:SpawnFunction( ply, tr )
 	if ( !tr.Hit ) then return end
	local blarg = ents.Create ("sent_arc_casinoalarm")
	blarg:SetPos(tr.HitPos + tr.HitNormal * 40)
	blarg:Spawn()
	blarg:Activate()
	return blarg
end

function ENT:Think()

end
function ENT:OnRemove()
	if self.AlarmSound then
		self.AlarmSound:Stop()
	end
end
