-- This file is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

util.AddNetworkString("arcslots_monitortype")
net.Receive("arcslots_monitortype",function(len,ply)
	local ent = net.ReadEntity()
	if ent:GetClass() == "sent_arc_casinovault_screen" then
		net.Start("arcslots_monitortype")
		net.WriteEntity(ent)
		net.WriteUInt(ent.ScrType,8)
		net.Send(ply)
	end

end)

ENT.ScrType = 1

function ENT:SetScrType(typ)
	net.Start("arcslots_monitortype")
	net.WriteEntity(self)
	net.WriteUInt(typ,8)
	net.Broadcast()
	self.ScrType = typ
end
function ENT:Initialize()
	self:SetModel( "models/props/cs_office/computer_monitor.mdl" )
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

end

function ENT:Think()

end
function ENT:OnRemove()

end
