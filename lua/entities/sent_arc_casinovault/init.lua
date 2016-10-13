-- This shit is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

util.AddNetworkString("arcslots_casino_vault_anim")

function ENT:Initialize()
	if !ARCLib.IsVersion("1.3.6","ARCBank") then
		ARCLib.NotifyBroadcast(ARCSlots.Msgs.Notifications.VaultARCBank,NOTIFY_ERROR,5,true)
		self:Remove()
		return
	end
	if #ents.FindByClass("sent_arc_casinovault") > 1 then
		ARCLib.NotifyBroadcast(ARCSlots.Msgs.Notifications.VaultOne,NOTIFY_ERROR,5,true)
		self:Remove()
		return
	end

	self:SetModel( "models/props/de_train/de_train_signalbox_01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self.phys = self:GetPhysicsObject()
	if self.phys:IsValid() then
		self.phys:Wake()
	end
	self:SetUseType( CONTINUOUS_USE  )
	self.Open = false
	if !IsValid(self.ConsoleEnt) then
		self.ConsoleEnt = ents.Create ("sent_arc_casinovault_console")
		self.ConsoleEnt:SetPos(self:LocalToWorld(Vector(28.323858, -29.860254, 42.507160)))
		self.ConsoleEnt:SetAngles(self:GetAngles())
		self.ConsoleEnt.Vault = self
		self.ConsoleEnt:Spawn()
		self.ConsoleEnt:Activate()
		constraint.Weld( self, self.ConsoleEnt, 0, 0, 0, true, false ) 
	end
	if !self.Screens then
		self.Screens = {}
		self.Screens[1] = ents.Create ("sent_arc_casinovault_screen")
		self.Screens[1]:SetPos(self:LocalToWorld(Vector(16.5, -48.3, 64.3)))
		self.Screens[1]:SetAngles(self:LocalToWorldAngles(Angle(18,0,0)))
		self.Screens[1].Vault = self
		self.Screens[1].ScrType = 1
		self.Screens[1]:Spawn()
		self.Screens[1]:Activate()
		self.Screens[2] = ents.Create ("sent_arc_casinovault_screen")
		self.Screens[2]:SetPos(self:LocalToWorld(Vector(16.5, -25.5, 64.3)))
		self.Screens[2]:SetAngles(self:LocalToWorldAngles(Angle(18,0,0)))
		self.Screens[2].Vault = self
		self.Screens[2].ScrType = 2
		self.Screens[2]:Spawn()
		self.Screens[2]:Activate()
		self.Screens[3] = ents.Create ("sent_arc_casinovault_screen")
		self.Screens[3]:SetPos(self:LocalToWorld(Vector(18, -19.5, 78.9)))
		self.Screens[3]:SetAngles(self:LocalToWorldAngles(Angle(16,-35,-100)))
		self.Screens[3].Vault = self
		self.Screens[3].ScrType = 3
		self.Screens[3]:Spawn()
		self.Screens[3]:Activate()
		constraint.Weld( self, self.Screens[1], 0, 0, 0, true, true ) 
		constraint.Weld( self, self.Screens[2], 0, 0, 0, true, true ) 
		constraint.Weld( self, self.Screens[3], 0, 0, 0, true, true ) 
		constraint.Weld( self.ConsoleEnt, self.Screens[1], 0, 0, 0, true, true ) 
		constraint.Weld( self.ConsoleEnt, self.Screens[2], 0, 0, 0, true, true ) 
		constraint.Weld( self.ConsoleEnt, self.Screens[3], 0, 0, 0, true, true ) 
		constraint.Weld( self.Screens[1], self.Screens[2], 0, 0, 0, true, true ) 
		constraint.Weld( self.Screens[2], self.Screens[3], 0, 0, 0, true, true ) 
		constraint.Weld( self.Screens[3], self.Screens[1], 0, 0, 0, true, true ) 
	end
	
	--28.323858 -29.860254 42.507160
	--16.5 -48.3 64.3
	--16.5 -25.5 64.3
	--18.0 -19.50 78.9

	--0 0 0
	--18 0 0
	--18 0 0
	--16 -35 -100
end

function ENT:SpawnFunction( ply, tr )
 	if ( !tr.Hit ) then return end
	local blarg = ents.Create ("sent_arc_casinovault")
	blarg:SetPos(tr.HitPos + tr.HitNormal * 40)
	blarg:Spawn()
	blarg:Activate()
	return blarg
end

function ENT:Think()
	if self.PermaProps then
		ARCLib.NotifyBroadcast("Do not use PermaProps with the Casino Vault! Please go to aritzcracker.ca/faq/arcslots",NOTIFY_ERROR,10,true)
		if self.ID then
			sql.Query("DELETE FROM permaprops WHERE id = ".. self.ID ..";")
		end
		self:Remove()
		self.PermaProps = false
	end
end
function ENT:OnRemove()
	if IsValid(self.ConsoleEnt) then
		self.ConsoleEnt:Remove()
	end
	
	if istable(self.Screens) then
		for i=1,3 do
			if IsValid(self.Screens[i]) then
				self.Screens[i]:Remove()
			end
		end
	end
end
function ENT:Use( ply, caller )
	if self.Open && ARCSlots.Disk.VaultFunds > ARCSlots.Settings["vault_steal_rate"] then
		if !ply._VaultTime then
			ply._VaultTime = 1
		end
		if ply._VaultTime <= CurTime() then
			ARCSlots.RawPlayerAddMoney(ply,ARCSlots.Settings["vault_steal_rate"])
			ARCSlots.Disk.VaultFunds = ARCSlots.Disk.VaultFunds - ARCSlots.Settings["vault_steal_rate"]
			net.Start("arcslots_worth")
			net.WriteDouble(ARCSlots.Disk.CasinoFunds)
			net.WriteDouble(ARCSlots.Disk.VaultFunds)
			net.Broadcast()
			self:EmitSound("items/ammopickup.wav",60,math.random(80,110))
			ply._VaultTime = CurTime() + 1
		end
	end
end
function ENT:BeginHacked(amount)
	self.Hacked = true
	self.Screens[1]:SetScrType(4)
	self.Screens[3]:SetScrType(6)
	self:EmitSound("arcslots/vault/lock.wav")
	timer.Simple(2,function() 
		if !IsValid(self) then return end
		self.Screens[2]:SetScrType(5)
		ARCSlots.SoundVaultAlarm(true)
		self:ToggleDoor(true)
		timer.Simple(amount/ARCSlots.Settings["vault_steal_rate"]+0.5,function() 
			if !IsValid(self) then return end
			self:ToggleDoor(false)
			self.Screens[1]:SetScrType(1)

			timer.Simple(4.20,function()
				if !IsValid(self) then return end
				self.Hacked = false
				self:EmitSound("arcslots/vault/lock.wav")
				timer.Simple(math.Rand(5,10),function()
					if !IsValid(self) then return end
					self.Screens[2]:SetScrType(2)
					ARCSlots.SoundVaultAlarm(false)
				end)
			end)
		end)
	end)
end

function ENT:ToggleDoor(state)
	if self.Open != state then
		self.Open = state
		net.Start("arcslots_casino_vault_anim")
		net.WriteEntity(self)
		net.WriteBit(self.Open)
		if self.Open then
			net.WriteDouble(4.5)
			self:EmitSound("arcslots/vault/open.wav")
		else
			net.WriteDouble(4.20) -- Smoke w33d everyday
			self:EmitSound("arcslots/vault/close.wav")
		end
		net.Broadcast()
	end
end