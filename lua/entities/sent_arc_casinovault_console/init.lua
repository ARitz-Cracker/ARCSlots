-- This file is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
util.AddNetworkString("arcslots_fakeconsolehack")
function ENT:Initialize()
	self:SetModel( "models/thedoctor/crackmachine_on.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self.phys = self:GetPhysicsObject()
	if self.phys:IsValid() then
		self.phys:Wake()
	end
	self:SetUseType( SIMPLE_USE )
	self.NextFakeHack = CurTime() + 1
end

function ENT:SpawnFunction( ply, tr )

end
function ENT:ATM_USE(ply)
	ARCLib.NotifyPlayer(ply,"This machine isn't accepting your card",NOTIFY_GENERIC,5,true)
end
function ENT:OnRemove()
	--MsgN(self.Vault)
	if IsValid(self.Vault) then
		self.Vault:Remove()
	end
end
function ENT:Use(ply, act)
	if self.NextFakeHack > CurTime() then return end
	self:EmitSound("ambient/machines/keyboard_fast"..math.random(1,3).."_1second.wav")
	timer.Simple(1,function()
		if !IsValid(self) then return end
		self:EmitSound("ambient/machines/keyboard_slow_1second.wav")

	end)
	timer.Simple(1.9,function()
		if !IsValid(self) then return end
		net.Start("arcslots_fakeconsolehack")
		net.WriteEntity(self)
		net.Broadcast()
	end)
	self.NextFakeHack = CurTime() + 2.1
end
function ENT:Spark()
	self.SparkTime = SysTime() + 0.1
end

function ENT:Hackable()
	return IsValid(self.Vault)
end
function ENT:HackStop()
	if IsValid(self.Vault) && self.Vault.Hacked then return true end
	self.Hacked = false
end
function ENT:HackStart()
	self.Hacked = true
end
function ENT:HackProgress(per)
	self.Percent = per
end
function ENT:HackComplete(ply,amount,rand)
	self.Percent = 1
	self.HackAmount = amount
	self.HackRandom = rand
	self.Vault:BeginHacked(amount)
end

function ENT:Think()

end
function ENT:OnRemove()

end
