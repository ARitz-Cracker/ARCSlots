-- This file is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
util.AddNetworkString("arcslots_fakeconsolehack")
util.AddNetworkString("arcslots_vaultwithdraw")
util.AddNetworkString("arcslots_vault_signin")
for i = 1,#ENT.ATMType.ErrorSound do
	ARCLib.AddToSoundWhitelist("sent_arc_casinovault_console",ENT.ATMType.ErrorSound[i],65,100)
end
for i = 1,#ENT.ATMType.PressSound do
	ARCLib.AddToSoundWhitelist("sent_arc_casinovault_console",ENT.ATMType.PressSound[i],65,100)
end
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
function ENT:ATM_USE(activator)
	if IsValid(activator) && activator:IsPlayer() then
		if self.Hacked then return end
		if self.UsePlayer then
			if activator == self.UsePlayer then
				
				if self.ATMType.CardRemoveAnimation != "" then
					self:ARCLib_SetAnimationTime(self.ATMType.CardRemoveAnimation,self.ATMType.CardRemoveAnimationLength)
				end
				self:EmitSoundTable(self.ATMType.WithdrawCardSound,65,math.random(95,105))
				
				local selfcard = ents.Create( "prop_physics" )
				selfcard:SetModel( self.ATMType.CardModel )
				selfcard:SetKeyValue("spawnflags","516")
				selfcard:SetPos( self:LocalToWorld(self.ATMType.CardRemoveAnimationPos))
				selfcard:SetAngles( self:LocalToWorldAngles(self.ATMType.CardRemoveAnimationAng) )
				selfcard:Spawn()
				selfcard:GetPhysicsObject():EnableCollisions(false)
				selfcard:GetPhysicsObject():EnableGravity(false)
				selfcard:GetPhysicsObject():SetVelocity(selfcard:GetForward()*self.ATMType.CardRemoveAnimationSpeed.x + selfcard:GetRight()*self.ATMType.CardRemoveAnimationSpeed.y + selfcard:GetUp()*self.ATMType.CardRemoveAnimationSpeed.z)
				timer.Simple(self.ATMType.CardRemoveAnimationLength-0.3,function() selfcard:GetPhysicsObject():SetVelocity(Vector(0,0,0)) end)
				timer.Simple(self.ATMType.CardRemoveAnimationLength,function() 
					--MsgN(self:WorldToLocal(selfcard:GetPos()))
					selfcard:Remove() 
				end)
				
				local ply = self.UsePlayer
				timer.Simple(0.5,function()
					ply:Give("weapon_arc_atmcard")
					ply:SelectWeapon("weapon_arc_atmcard")
				end)
				
				table.RemoveByValue(ARCBank.Disk.NommedCards,activator:SteamID())
				self.UsePlayer = nil
			else
				ARCLib.NotifyPlayer(activator,string.Replace(ARCBank.Msgs.UserMsgs.ATMUsed, "%PLAYER%", self.UsePlayer:Nick()) ,NOTIFY_GENERIC,5,true)
			end
		else

			if self.ATMType.CardInsertAnimation != "" then
				self:ARCLib_SetAnimationTime(self.ATMType.CardInsertAnimation,self.ATMType.CardInsertAnimationLength)
			end
			self:EmitSoundTable(self.ATMType.InsertCardSound,65,math.random(95,105))
			
			local selfcard = ents.Create( "prop_physics" )
			selfcard:SetModel( self.ATMType.CardModel )
			selfcard:SetKeyValue("spawnflags","516")
			selfcard:SetPos( self:LocalToWorld(self.ATMType.CardInsertAnimationPos))
			selfcard:SetAngles( self:LocalToWorldAngles(self.ATMType.CardInsertAnimationAng) )
			selfcard:Spawn()
			selfcard:GetPhysicsObject():EnableCollisions(false)
			selfcard:GetPhysicsObject():EnableGravity(false)
			selfcard:GetPhysicsObject():SetVelocity(selfcard:GetForward()*self.ATMType.CardInsertAnimationSpeed.x + selfcard:GetRight()*self.ATMType.CardInsertAnimationSpeed.y + selfcard:GetUp()*self.ATMType.CardInsertAnimationSpeed.z)
			timer.Simple(self.ATMType.CardInsertAnimationLength,function() 
				selfcard:Remove() 
			end)
			table.insert(ARCBank.Disk.NommedCards,activator:SteamID())
			self.UsePlayer = activator
			activator:SwitchToDefaultWeapon() 
			activator:StripWeapon( "weapon_arc_atmcard" ) 
			net.Start("arcslots_vault_signin")
			net.WriteEntity(self)
			net.WriteUInt(ARCSlots.EntitledAmount(activator),32)
			net.WriteDouble(ARCSlots.GetManagerEndTime(activator))
			net.Send(activator)
		end
	end
	self:SetNWEntity( "UsePlayer", self.UsePlayer || NULL) 
	return true
end
function ENT:OnRemove()
	if IsValid(self.Vault) then
		self.Vault:Remove()
	end
end
function ENT:Spark()
	self.SparkTime = SysTime() + 0.1
end

function ENT:Hackable()
	return IsValid(self.Vault) && !self.UsePlayer
end
function ENT:HackStop()
	if IsValid(self.Vault) && self.Vault.Hacked then return true end
	self.Hacked = false
	self.Vault.Screens[3]:SetScrType(3)
end
function ENT:HackStart()
	self.Hacked = true
	if IsValid(self.Vault) then
		self.Vault.Screens[3]:SetScrType(9)
	end
end
function ENT:HackSpark()

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

function ENT:WithdrawAnimation()
	local atm = self
	timer.Simple(atm.ATMType.PauseBeforeWithdrawAnimation,function() 
		if atm.ATMType.ModelOpen != "" then
			atm:SetModel( atm.ATMType.ModelOpen ) 
			atm:SetSkin(atm.ATMType.OpenSkin)
		end
		if atm.ATMType.OpenAnimation != "" then
			atm:ARCLib_SetAnimationTime(atm.ATMType.OpenAnimation,atm.ATMType.OpenAnimationLength)
		end
	end)
	timer.Simple(atm.ATMType.PauseBeforeWithdrawAnimation + atm.ATMType.PauseAfterWithdrawAnimation,function() 
		if atm.ATMType.UseMoneyModel then
			atm.moneyprop = ents.Create( "prop_physics" )
			atm.moneyprop:SetModel( atm.ATMType.MoneyModel )
			atm.moneyprop:SetKeyValue("spawnflags","516")
			atm.moneyprop:SetPos( atm:LocalToWorld(atm.ATMType.WithdrawAnimationPos))
			atm.moneyprop:SetAngles( atm:LocalToWorldAngles(atm.ATMType.WithdrawAnimationAng) )
			atm.moneyprop:Spawn()
			atm.moneyprop:GetPhysicsObject():EnableCollisions(false)
			atm.moneyprop:GetPhysicsObject():EnableGravity(false)
			timer.Simple(atm.ATMType.WithdrawAnimationLength,function() 
				atm.moneyprop:GetPhysicsObject():SetVelocity(Vector(0,0,0)) 
				atm.moneyprop:GetPhysicsObject():EnableMotion( false) 
			end)
			atm.moneyprop:GetPhysicsObject():SetVelocity(atm.moneyprop:GetForward()*atm.ATMType.WithdrawAnimationSpeed.x + atm.moneyprop:GetRight()*atm.ATMType.WithdrawAnimationSpeed.y + atm.moneyprop:GetUp()*atm.ATMType.WithdrawAnimationSpeed.z)
		end
		if atm.ATMType.WithdrawAnimation != "" then
			atm:ARCLib_SetAnimationTime(atm.ATMType.WithdrawAnimation,atm.ATMType.WithdrawAnimationLength)
		end
	end)
	atm:EmitSoundTable(atm.ATMType.WithdrawSound,65,100)
	atm.MonehDelay = CurTime() + atm.ATMType.PauseBeforeWithdrawAnimation + atm.ATMType.PauseAfterWithdrawAnimation + atm.ATMType.WithdrawAnimationLength
end

function ENT:Use( ply, caller )
	if ply == self.UsePlayer && self.PlayerNeedsToDoSomething then
		local hit,dir,frac = util.IntersectRayWithOBB(ply:GetShootPos(),ply:GetAimVector()*100, self:LocalToWorld(self.ATMType.MoneyHitBoxPos), self:LocalToWorldAngles(self.ATMType.MoneyHitBoxAng), vector_origin, self.ATMType.MoneyHitBoxSize)  
		if hit && self.MonehDelay <= CurTime() then
			self.MonehDelay = CurTime() + 5
			ARCSlots.RawPlayerAddMoney(self.UsePlayer,self.WithdrawAmount)
			ARCSlots.ManagerWithdrawFunds(self.UsePlayer,self.WithdrawAmount)
			self.errorc = 0
			if self.ATMType.UseMoneyModel then
				self.moneyprop:Remove()
			end
			self:EmitSound("foley/alyx_hug_eli.wav",65,math.random(225,255))
			self.PlayerNeedsToDoSomething = false
			if IsValid(self.UsePlayer) then
				net.Start( "ARCATM_COMM_WAITMSG" )
				net.WriteEntity( self.Entity )
				net.WriteUInt(0,2)
				net.Send(self.UsePlayer)
			end
			
		end
	elseif !self.UsePlayer then
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
end

function ENT:Think()
	if self.UsePlayer && !IsValid(self.UsePlayer) then
		self.UsePlayer = nil
		if self.PlayerNeedsToDoSomething then
			self.moneyprop:Remove()
			self.PlayerNeedsToDoSomething = false
		end
		return
	end
	
	if self.PlayerNeedsToDoSomething then
		self.Beep = true
	elseif self.Beep then
		--timer.Simple(0.1, function() self:SetSkin( 2 ) end)
		self:EmitSoundTable(self.ATMType.CloseSound,65,100)
		self:SetModel( self.ATMType.Model ) 
		if self.ATMType.ModelOpen != "" then
			self:SetModel( self.ATMType.Model )
		end
		self:SetSkin(self.ATMType.CloseSkin)
		if self.ATMType.CloseAnimation != "" then
			self:ARCLib_SetAnimationTime(atm.ATMType.CloseAnimation,atm.ATMType.CloseAnimationLength)
		end
		self.Beep = false
		self:ATM_USE(self.UsePlayer)
	end
	
	if self.Beep then
		self:EmitSound(table.Random(self.ATMType.WaitSound),65,100)
		if self.PlayerNeedsToDoSomething && IsValid(self.UsePlayer) && self:GetPos():DistToSqr( self.UsePlayer:GetPos() ) > 25000 then
			self.errorc = ARCBANK_ERROR_ABORTED
			self.moneyprop:Remove()
			if IsValid(self.UsePlayer) then
				net.Start( "ARCATM_COMM_WAITMSG" )
				net.WriteEntity( self.Entity )
				net.WriteUInt(0,2)
				net.Send(self.UsePlayer)
			end
			self.PlayerNeedsToDoSomething = false
		end
	
		self:NextThink( CurTime() + 1 )
		if self.ATMType.UseMoneylight then
			net.Start("ARCATM_COMM_BEEP")
			net.WriteEntity(self.Entity)
			net.WriteBit(true)
			net.Broadcast()
		end
		self:SetSkin(self.ATMType.LightSkin)
		timer.Simple(0.5, function() 
			if self.ATMType.UseMoneylight then
				net.Start("ARCATM_COMM_BEEP")
				net.WriteEntity(self.Entity)
				net.WriteBit(false)
				net.Broadcast()
			end
			self:SetSkin(self.ATMType.OpenSkin)
		end)
		return true
	end
	if IsValid(self.UsePlayer) && self.UsePlayer:Alive() && self:GetPos():DistToSqr( self.UsePlayer:GetPos() ) > 25000 then
		ARCLib.NotifyPlayer(self.UsePlayer,ARCBank.Msgs.ATMMsgs.PlayerTooFar,NOTIFY_ERROR,2,false)
		self:ATM_USE(self.UsePlayer)
	end
end
function ENT:OnRemove()

end

net.Receive("arcslots_vaultwithdraw",function(msglen,ply)
	local atm = net.ReadEntity()
	if atm:GetClass() != "sent_arc_casinovault_console" then return end
	if atm.UsePlayer != ply then return end
	local useARCBank = net.ReadBool()
	atm.WithdrawAmount = net.ReadUInt(32)
	--[[
	if !ARCSlots.IsManager(ply) then
		ARCLib.NotifyPlayer(ply,ARCSlots.Msgs.VaultMsgs.NotAuthed,NOTIFY_ERROR,6,true)
		atm:ATM_USE(atm.UsePlayer)
	return end
	]]
	if !ARCSlots.CanBeManager(ply) then
		ARCLib.NotifyPlayer(ply,ARCSlots.Msgs.VaultMsgs.NotManager,NOTIFY_ERROR,6,true)
		atm:ATM_USE(atm.UsePlayer)
	return end
	if atm.WithdrawAmount <= 0 then
		atm:ATM_USE(atm.UsePlayer)
		return
	end
	if atm.WithdrawAmount > ARCSlots.EntitledAmount(ply) then
		ARCLib.NotifyPlayer(ply,ARCSlots.Msgs.VaultMsgs.NoCash,NOTIFY_ERROR,6,true)
		atm:ATM_USE(atm.UsePlayer)
	return end
	
	if (useARCBank) then
		local account = net.ReadString()
		ARCSlots.RawARCBankAddMoney(ply,atm.WithdrawAmount,account,"Casino earnings",function(worked)
			if worked then
				ARCSlots.ManagerWithdrawFunds(ply,atm.WithdrawAmount)
			end
		end)
		atm:ATM_USE(atm.UsePlayer)
	else
		atm:WithdrawAnimation()
		timer.Simple(atm.ATMType.PauseBeforeWithdrawAnimation + atm.ATMType.PauseAfterWithdrawAnimation + atm.ATMType.WithdrawAnimationLength,function()
			if IsValid(atm.UsePlayer) then
				net.Start( "ARCATM_COMM_WAITMSG" )
				net.WriteEntity( atm )
				net.WriteUInt(2,2)
				net.Send(ply)
			end
			ARCLib.NotifyPlayer(ply,ARCBank.Msgs.UserMsgs.WithdrawATM,NOTIFY_HINT,5,false)
			atm.PlayerNeedsToDoSomething = true
		end)
	end
end)

net.Receive("arcslots_vault_signin",function(msglen,ply)
	local atm = net.ReadEntity()
	if atm:GetClass() != "sent_arc_casinovault_console" then return end
	if atm.UsePlayer != ply then return end
	local signin = net.ReadBool()
	if signin then
		if IsValid(ARCSlots.Manager) && ARCSlots.Manager != ply then
			ARCLib.NotifyPlayer(ply,ARCSlots.Msgs.VaultMsgs.MaxManagers,NOTIFY_ERROR,6,true)
		elseif ARCSlots.CanBeManager(ply) then
			ARCSlots.ManagerBegin(ply)
		else
			ARCLib.NotifyPlayer(ply,ARCSlots.Msgs.VaultMsgs.NotManager,NOTIFY_ERROR,6,true)
		end
	else
		atm:ATM_USE(ply)
	end
end)
