-- This shit is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- � Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

-- WARNING! SPEGETTI CODE THAT I CAN READ PERFECTLY!

--[[

From the creators of the Crack Machine, we bring forth the 'Crack-Slot'! 
This state-of-the-art machine revolutionises the betting to an extreme level. 
Now ladies and gentlegamers, you can sniff crack in a slot while producing crack in the crack-machine!

]]
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--[[
resource.AddFile("resource/fonts/TRANA___.TTF")
resource.AddFile("resource/fonts/TRANGA__.TTF")
ARCLib.AddDir("sound/arcslots")
ARCLib.AddDir("materials/arc/slotmachine")
]]


util.AddNetworkString( "ARCSlots_Update" )
function ENT:Initialize()
	self:SetModel( "models/thedoctor/crackslot.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self.phys = self:GetPhysicsObject()
	if self.phys:IsValid() then
		self.phys:Wake()
	end
	self.Winnings = {}
	self.Icon1 = math.random(0,8)
	self.Icon2 = math.random(0,8)
	self.Icon3 = math.random(0,8)
	self.UseDelay = CurTime()
	self.Status = 0
	self.WinningThing = 1
	self.FreeSpins = 0
	self:SetUseType( SIMPLE_USE )
	self.Idle = true
	self.SpinSound = CreateSound( self, "arcslots/spin_loop1.wav" ) 
	self.ScreenMsg = ""
	timer.Simple(1,function() if IsValid(self) then self:UpdateIcons() end end)
	
end
function ENT:UpdateIcons()
	net.Start("ARCSlots_Update")
	net.WriteEntity(self.Entity)
	net.WriteBit(self.Idle)
	net.WriteInt(self.Icon1-5,4)
	net.WriteInt(self.Icon2-5,4)
	net.WriteInt(self.Icon3-5,4)
	net.WriteInt(self.Status,2)
	net.WriteInt(self.WinningThing-5,4)
	net.WriteString(self.ScreenMsg)
	net.Broadcast()
end
function ENT:SpawnFunction( ply, tr )
 	if ( !tr.Hit ) then return end
	local blarg = ents.Create ("sent_arc_slotmachine")
	blarg:SetPos(tr.HitPos + tr.HitNormal * 40)
	blarg:Spawn()
	blarg:Activate()
	blarg.Hacker = ply
	return blarg
end

function ENT:Think()
	if self.PermaProps then
		ARCLib.NotifyBroadcast("Do not use PermaProps with the slot machines! Please go to aritzcracker.ca/faq/arcslots",NOTIFY_ERROR,10,true)
		if self.ID then
			sql.Query("DELETE FROM permaprops WHERE id = ".. self.ID ..";")
		end
		self:Remove()
		self.PermaProps = false
	end
end
function ENT:OnRemove()
	if IsValid(self.SpinSound) then
		self.SpinSound:Stop()
		self.SpinSound:Stop()
	end
end
function ENT:GiveOutPrize(ply,prize)
	if self.UseARCBank then
		ARCSlots.ARCBankAddMoney(ply,prize,"","Slot machine prize",function(worked)
			if !worked then
				ARCSlots.PlayerAddMoney(ply,prize)
			end
		end)
	else
		ARCSlots.PlayerAddMoney(ply,prize)
	end
end

function ENT:Use( ply, caller )
	if IsValid(ply.SlotMachine) && ply.SlotMachine.UseDelay > CurTime() then
	return end
	if self.UseDelay > CurTime() then return end
	if ply:IsPlayer() then
		ply:SendLua("ents.GetByIndex("..self:EntIndex().."):ReqSpin(false)")
	end
end
function ENT:ATM_USE(activator)
	if IsValid(activator) && activator:IsPlayer() then
		if IsValid(activator.SlotMachine) && activator.SlotMachine.UseDelay > CurTime() then
		return end
		if self.UseDelay > CurTime() then 
			ARCLib.NotifyPlayer(activator,ARCBank.Msgs.CardMsgs.NoCard,NOTIFY_GENERIC,5,true)
		else
			activator:SendLua("ents.GetByIndex("..self:EntIndex().."):ReqSpin(true)")
		end
	end
end
function ENT:Spin(ply,amount)
	if !IsValid(ply) then
	return end
	if IsValid(ply.SlotMachine) && ply.SlotMachine.UseDelay > CurTime() then
	return end
	if self.UseDelay > CurTime() then 
	return end
	self.ScreenMsg = string.gsub(ply:Nick(), "[^_%w]", "_").." * BET "..amount
	self.SpinSound = CreateSound( self, "arcslots/spin_loop1.wav" ) 
	if self.FreeSpins <= 0 then
		if self.UseARCBank then
			self:EmitSound("arcbank/atm/cardremove.wav",65,math.random(95,105))
		else
			if !ARCSlots.PlayerCanAfford(ply,amount) then 
				if ARCBank then
					ARCLib.NotifyPlayer(ply,ARCSlots.Msgs.Notifications.NoMoney,NOTIFY_ERROR,4,true)
				else
					ARCLib.NotifyPlayer(ply,ARCSlots.Msgs.Notifications.NoMoney,NOTIFY_GENERIC,4,true)
				end
				return 
			end
			self:EmitSound("arcslots/coin.wav")
			ARCSlots.PlayerAddMoney(ply,-amount)
		end
	end
	ply.SlotMachine = self
	self.UseDelay = CurTime() + 20
	timer.Simple(ARCLib.BoolToNumber(self.FreeSpins <= 0),function() 
		if !IsValid(self) then return end
		self.FreeSpins = self.FreeSpins - 1
		if self.FreeSpins < 0 then
			self.FreeSpins = 0
		end
		self:EmitSound("arcslots/start.wav")
		self.SpinSound:PlayEx(70,100)
		self.Icon1 = -3
		self.Icon2 = -3
		self.Icon3 = -3
		self.Idle = false
		self:UpdateIcons()
		local icon1,icon2,icon3,payout,winicon = ARCSlots.SlotPrizePayout()
		timer.Simple(math.Rand(0.7,1.7),function()
			if !IsValid(self) then return end
			self.Icon1 = icon1
			self:EmitSound("arcslots/stop1.wav")
			self:UpdateIcons()
			local time = math.Rand(0.1,0.9)
			if self.Icon1 == 0 then time = 0.1 end
			timer.Simple(time,function()
				if !IsValid(self) then return end
				self.Icon2 = icon2
				self:EmitSound("arcslots/stop2.wav")
				self:UpdateIcons()
				local time = math.Rand(0.1,0.9)
				if self.Icon1 == 0 then time = 0.1 end
				timer.Simple(time,function()
					if !IsValid(self) then return end
					if ((self.Icon1 == self.Icon2) || (self.Icon1 == 8 || self.Icon2 == 8)) && self.Icon1 > 5 && self.Icon2 > 5 then
						timer.Simple(math.Rand(1,5),function()
						--timer.Simple(1,function()
							if !IsValid(self) then return end
							
							self.SpinSound:ChangePitch(90,1.5) 
							self.Icon3 = -2
							self:UpdateIcons()
							timer.Simple(math.Rand(1.5,3.5),function()
							--timer.Simple(2,function()
								if !IsValid(self) then return end
								self.SpinSound:ChangePitch(80,1.5) 
								self.Icon3 = -1
								self:UpdateIcons()
								timer.Simple(math.Rand(1.5,6),function()
								--timer.Simple(3,function()
									if !IsValid(self) then return end
									self.Icon3 = icon3
									self:UpdateIcons()
									self:EmitSound("arcslots/stop3.wav")
									self.SpinSound:Stop()
									timer.Simple(0.5,function() self:DingDing(payout,winicon,amount,ply) end)
								end)
							end)
						end)
					else
						self.Icon3 = icon3
						self:UpdateIcons()
						self:EmitSound("arcslots/stop3.wav")
						self.SpinSound:Stop()
						timer.Simple(0.5,function() self:DingDing(payout,winicon,amount,ply) end)
					end
				end)
			end)
		end)

	end)
end
function ENT:DingDing(payout,winicon,amount,ply)
	self.WinningThing = winicon
	local idletime = 2
	if payout < 0 then
		self.Status = 1
		self:EmitSound("arcslots/winner.wav")
		self.FreeSpins = self.FreeSpins - payout
		self.ScreenMsg = ARCLib.PlaceholderReplace(ARCSlots.Msgs.SlotMsgs.FreeSpins,{AMOUNT=tostring(-1*payout)}).."("..self.FreeSpins..")"
	elseif payout == 0 then
		if ((self.Icon1 == self.Icon2) || (self.Icon1 == 8 || self.Icon2 == 8)) && self.Icon1 > 5 && self.Icon2 > 5 then
			self:EmitSound("arcslots/soooclose.mp3")
			idletime = 4
			if math.random(1,10) == 1 then
				self.ScreenMsg = ARCSlots.Msgs.SlotMsgs.LooseMock
			else
				self.ScreenMsg = ARCSlots.Msgs.SlotMsgs.Loose
			end
		else
			idletime = 1
			self.ScreenMsg = ARCSlots.Msgs.SlotMsgs.Loose
		end
		self.Status = -1
	else
		self:GiveOutPrize(ply,amount*payout)
		--self.FreeSpins = self.FreeSpins + payout
		if winicon >= 8 then
			self:EmitSound("music/hl1_song25_remix3.mp3",115,100)
			self.ScreenMsg = ARCLib.PlaceholderReplace(ARCSlots.Msgs.SlotMsgs.Jackpot,{AMOUNT=tostring(-1*payout)})--.."("..self.FreeSpins..")"
			idletime = 60
		elseif winicon >= 6 then
			self:EmitSound("arcslots/jackpot.wav")
			self.ScreenMsg = ARCLib.PlaceholderReplace(ARCSlots.Msgs.SlotMsgs.MegaWin,{AMOUNT=tostring(-1*payout)})
			idletime = 6
		else
			self:EmitSound("arcslots/winner.wav")
			self.ScreenMsg = ARCLib.PlaceholderReplace(ARCSlots.Msgs.SlotMsgs.Win,{AMOUNT=tostring(-1*payout)})
		end
		self.Status = 1
	end
	self.UseDelay = CurTime() + idletime
	self:UpdateIcons()
	
	timer.Simple(idletime,function()
		self.Status = 0
		self.Idle = true
		if self.FreeSpins > 0 then
			self:Spin(ply,amount)
		else
			self:UpdateIcons()
		end
	end)
	ply.SlotMachine = nil
end

net.Receive( "ARCSlots_Update", function(length,ply)
	local ent = net.ReadEntity()
	local num = net.ReadInt(32)
	local UseARCBank = tobool(net.ReadBit())
	if isnumber(num) then
		num = num + 2^31
		num = math.Clamp(num,ARCSlots.Settings.slots_min_bet,ARCSlots.Settings.slots_max_bet)
		ent.UseARCBank = (UseARCBank && ARCBank)
		if ent.UseARCBank then
			ARCSlots.ARCBankAddMoney(ply,-num,"","Slot machine",function(worked)
				if worked then
					ent:Spin(ply,num)
				end
			end)
		else
			ent:Spin(ply,num)
		end
		
		
	end
end)
