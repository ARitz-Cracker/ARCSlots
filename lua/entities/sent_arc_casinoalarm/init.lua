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

function ARCSlots.SoundVaultAlarm(doit)
	local ent = ents.FindByClass("sent_arc_casinoalarm")
	net.Start("arcslots_alarm")
	net.WriteBit(doit)
	net.WriteUInt(#ent,32)
	for i=1,#ent do
		net.WriteUInt(ent[i]:EntIndex(),32)
	end
	net.Broadcast()
end

function ENT:Initialize()
	if #ents.FindByClass("sent_arc_casinovault") < 1 then
		ARCLib.NotifyBroadcast("You can't have an alarm without a vault",NOTIFY_ERROR,5,true)
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

end
