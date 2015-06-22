-- This shit is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

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
if !isfunction(ARCSlots_AddMoneyPlayer) then
	ARCSlots_AddMoneyPlayer = function(ply,amount)
		if string.lower(GAMEMODE.Name) == "gmod day-z" then
			if amount > 0 then
				ply:GiveItem("item_money", amount)
			else
				amount = amount * -1
				ply:TakeItem("item_money", amount)
			end
		
		elseif ply.addMoney then -- DarkRP 2.5+
			ply:addMoney(amount)
		elseif ply.AddMoney then -- DarkRP 2.4
			ply:AddMoney(amount)
		else
			ply:SendLua("notification.AddLegacy( \"I'm going to pretend that your wallet is unlimited because this is an unsupported gamemode.\", 0, 5 )")
		end
	end
end
if true then -- Yeah... long story.
	resource.AddWorkshop("251070018")
end
if !isfunction(ARCSlots_PlayerCanAfford) then
	ARCSlots_PlayerCanAfford = function(ply,amount)
		if string.lower(GAMEMODE.Name) == "gmod day-z" then
			return ply:HasItemAmount("item_money", amount)
		elseif ply.canAfford then
			return ply:canAfford(amount)
		elseif ply.CanAfford then
			return ply:CanAfford(amount)
		else
			return false
		end
	end
end
local ARCSlots_MaxBet = 50
local ARCSlots_MinBet = 25
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
	self.Winnings[1] = 0
	self.Winnings[2] = 0
	self.Winnings[3] = 0
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
	net.WriteInt(self.Winnings[1]-5,4)
	net.WriteInt(self.Winnings[2]-5,4)
	net.WriteInt(self.Winnings[3]-5,4)
	net.WriteInt(self.Status,2)
	net.WriteInt(self.WinningThing-5,4)
	net.WriteString(self.ScreenMsg)
	net.WriteInt(ARCSlots_MinBet-(2^31),32)
	net.WriteInt(ARCSlots_MaxBet-(2^31),32)
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

end
local Last = 0
local LastLast = 0
local slotmachineequation = function()
	local dice = math.random(1,100000)
	if dice <= 1 then
		LastLast = Last
		Last = 8
	elseif dice <= 10 then
		LastLast = Last
		if Last == 7 && math.random(1,10) == 1 then
			Last = 8
		else
			Last = 7
		end
	elseif dice <= 100 then
		LastLast = Last
		if Last == 6 && math.random(1,10) == 1 then
			Last = 8
		else
			Last = 6
		end
	elseif dice <= 3100 then
		LastLast = Last
		if Last == 5 && math.random(1,10) == 1 then
			Last = 8
		else
			Last = 5
		end
	elseif dice <= 6300 then
		LastLast = Last
		if Last == 4 && math.random(1,10) == 1 then
			Last = 8
		else
			Last = 4
		end
	elseif dice <= 9600 then
		LastLast = Last
		if Last == 3 && math.random(1,10) == 1 then
			Last = 8
		else
			Last = 3
		end
	elseif dice <= 15000 then
		LastLast = Last
		if Last == 2 && math.random(1,10) == 1 then
			Last = 8
		else
			Last = 2
		end
	elseif dice <= 22500 then
		LastLast = Last
		if Last == 1 && math.random(1,10) == 1 then
			Last = 8
		else
			Last = 1
		end
	elseif dice <= 37500 then
		LastLast = Last
		Last = 0
	else
	--0.0000001
		--MsgN("Loose (psudo almost)")
		local dothing = true
		local riggeddice = math.random(0,7)
		while (Last == riggeddice)||(LastLast > 0 && LastLast < 6 && LastLast == riggeddice) do
			riggeddice = math.random(0,7)
			if LastLast != Last && Last > 0 && Last < 6 then
				if math.random() > 0.5 then
					riggeddice = math.random(6,7)
				else
					riggeddice = math.Round(math.random())
				end
			end
		end
		LastLast = Last
		Last = riggeddice
	end
	return Last
end
--[[
local test_attempt = 0
for i = 1,5000 do
	while slotmachineequation() != 8 || slotmachineequation() != 8 || slotmachineequation() != 8 do
		test_attempt = test_attempt + 1
	end
end
MsgN(5000/test_attempt)

.003
]]
function ENT:GiveOutPrize(ply,prize)
	if self.UseARCBank then
		ARCBank.ReadAccountFile(ARCBank.GetAccountID(ply:SteamID()),false,function(accountdata)
			if accountdata then
				accountdata.money = accountdata.money + prize
				ARCBank.WriteAccountFile(accountdata,function(diditwork) 
					if diditwork then
						ARCLib.NotifyPlayer(ply,"ARCBank: "..ARCBANK_ERRORSTRINGS[ARCBANK_ERROR_NONE],NOTIFY_GENERIC,3,true)
						ARCBankAccountMsg(accountdata,"("..ply:SteamID()..")\nWon "..prize.." on a slot machine. ("..accountdata.money..")")
					else
						ARCLib.NotifyPlayer(ply,"ARCBank: "..ARCBANK_ERRORSTRINGS[ARCBANK_ERROR_WRITE_FAILURE],NOTIFY_ERROR,6,true)
						ARCSlots_AddMoneyPlayer(ply,prize)
					end
				end)
			else
				ARCLib.NotifyPlayer(ply,"ARCBank: "..ARCBANK_ERRORSTRINGS[ARCBANK_ERROR_READ_FAILURE],NOTIFY_ERROR,6,true)
				ARCSlots_AddMoneyPlayer(ply,prize)
			end
		end) 
	else
		ARCSlots_AddMoneyPlayer(ply,prize)
	end
end
function ENT:DidWin(ply,amount) -- Check what happened, and give out prizes.g
	if !IsValid(ply) || !ply:IsPlayer() then return false end
	local winn = {}
	for i = 1,8 do
		winn[i] = 0
		for ii = 1,3 do
			if self.Winnings[ii] == i then
				winn[i] = winn[i] + 1
			end
		end
	end
	if winn[8] == 3 then
		self.WinningThing = 8
		--100,000 * 10 (1,000,000)
		local prize = 100000 * amount
		self.ScreenMsg = "JACKPOT *** YOU WIN "..prize.." *** CONGRATULATIONS "..string.gsub(ply:Nick(), "[^(^)^{^}^[^]^ ^_%w]", "_").." ***"
		ARCLib.NotifyPlayer(ply,"YOU WON THE "..string.Comma(prize).." JACKPOT! CONGRATULATIONS!!",NOTIFY_GENERIC,45,true)
			self:GiveOutPrize(ply,prize)
		self:EmitSound("music/hl1_song25_remix3.mp3",115,100)
		return true
	end
	if winn[8] == 2 then
		for i = 1,7 do
			if winn[i] > 0 then
				winn[i] = 3
				winn[8] = 0
			end
		end
	end
	for i = 1,7 do
		if winn[i] == 2 && winn[8] > 0 then
			winn[i] = winn[i] + 1
			winn[8] = winn[8] - 1
		end
	end
	for i = 1,7 do
		if winn[i] == 1 && winn[8] > 0 then
			winn[i] = winn[i] + 1
			winn[8] = winn[8] - 1
		end
	end
	if self.Winnings[1] == 0 || self.Winnings[2] == 0 || self.Winnings[3] == 0 then 
		if winn[8] == 2 || winn[7] == 2 || winn[6] == 2 then
			self:EmitSound("arcslots/soooclose.mp3")
		end
		self.ScreenMsg = "BETTER LUCK NEXT TIME"
		return false 
	end
	if winn[7] == 3 then
		self.WinningThing = 7
		local prize = 10000 * amount
		self.ScreenMsg = "WOW  YOU WIN "..prize
		self:GiveOutPrize(ply,prize)
		self:EmitSound("arcslots/jackpot.wav")
		return true
	end
	if winn[6] == 3 then
		self.WinningThing = 6
		local prize = 1000 * amount
		self.ScreenMsg = "WOW  YOU WIN "..prize
		self:GiveOutPrize(ply,prize)
		self:EmitSound("arcslots/jackpot.wav")
		return true
	end
	
	
	if winn[5] == 3 then
		self.WinningThing = 5
		local prize = 300 * amount
		self.ScreenMsg = "YOU WIN "..prize
		self:GiveOutPrize(ply,prize)
		self:EmitSound("arcslots/winner.wav")
		return true
	end
	if winn[4] == 3 then
		self.WinningThing = 4
		local prize = 150 * amount
		self.ScreenMsg = "YOU WIN "..prize
		self:GiveOutPrize(ply,prize)
		self:EmitSound("arcslots/winner.wav")
		return true
	end
	if winn[3] == 3 then
		self.WinningThing = 3
		local prize = 100 * amount
		self.ScreenMsg = "YOU WIN "..prize
		self:GiveOutPrize(ply,prize)
		self:EmitSound("arcslots/winner.wav")
		return true
	end
	if winn[2] == 3 then
		self.WinningThing = 2
		local prize = 50 * amount
		self.ScreenMsg = "YOU WIN "..prize
		self:GiveOutPrize(ply,prize)
		self:EmitSound("arcslots/winner.wav")
		return true
	end
	local thing = winn[2] + winn[3] + winn[4] + winn[5]
	if thing >= 3 then
		self.WinningThing = 10
		local prize = 5 * amount
		self.ScreenMsg = "YOU WIN "..prize
		self:GiveOutPrize(ply,prize)
		self:EmitSound("arcslots/winner.wav")
		return true
	end
	if winn[2] == 2 || winn[3] == 2 || winn[4] == 2 || winn[5] == 2 then
		for i = 2,5 do
			if winn[i] == 2 then
				self.WinningThing = i
			end
		end
		--5 * 10 (50)
		local prize = 2 * amount
		self.ScreenMsg = "YOU WIN "..prize
		self:GiveOutPrize(ply,prize)
		self:EmitSound("arcslots/winner.wav")
		return true
	end
	if winn[1] == 2 then
		self.WinningThing = 1
		self.ScreenMsg = "2 FREE SPINS"
		self.FreeSpins = self.FreeSpins + 2
		self:EmitSound("arcslots/winner.wav")
		return true
	elseif winn[1] == 3 then
		self.WinningThing = 1
		self.ScreenMsg = "5 FREE SPINS"
		self.FreeSpins = self.FreeSpins + 5
		self:EmitSound("arcslots/winner.wav")
		return true
	end
	if winn[8] == 2 || winn[7] == 2 || winn[6] == 2 then
		self:EmitSound("arcslots/soooclose.mp3")
	end
	self.ScreenMsg = "BETTER LUCK NEXT TIME"
	return false
end
--[[
ARitz Cracker: ??? = 100,000 * bet
ARitz Cracker: 777 = 10,000 * bet
ARitz Cracker: $$$ = 1,000 * bet
ARitz Cracker: 3 Spades = 300 * bet
ARitz Cracker: 3 Diamonds = 150 * bet
ARitz Cracker: 3 Clubs = 100 * bet
ARitz Cracker: 3 Hearts = 50 * bet
ARitz Cracker: All cards = 5 * bet
ARitz Cracker: 2 cards = 2* bet

]]
local winper = {}

--[[ TEST FUNCTION!!!!!!



--]]

local function DidWinTest(Winnings) -- Check what happened, and give out prizes.
	local winn = {}
	for i = 1,8 do
		winn[i] = 0
		for ii = 1,3 do
			if Winnings[ii] == i then
				winn[i] = winn[i] + 1
			end
		end
	end
	if winn[8] == 3 then
		return 8
	end
	if winn[8] == 2 then
		for i = 1,7 do
			if winn[i] > 0 then
				winn[i] = 3
				winn[8] = 0
			end
		end
	end
	for i = 1,7 do
		if winn[i] == 2 && winn[8] > 0 then
			winn[i] = winn[i] + 1
			winn[8] = winn[8] - 1
		end
	end
	for i = 1,7 do
		if winn[i] == 1 && winn[8] > 0 then
			winn[i] = winn[i] + 1
			winn[8] = winn[8] - 1
		end
	end
	if Winnings[1] == 0 || Winnings[2] == 0 || Winnings[3] == 0 then 
		return -1
	end
	if winn[7] == 3 then
		return 7
	end
	if winn[6] == 3 then
		return 6
	end
	
	
	if winn[5] == 3 then
		return 5
	end
	if winn[4] == 3 then
		return 4
	end
	if winn[3] == 3 then
		return 3
	end
	if winn[2] == 3 then
		return 2
	end
	local thing = winn[2] + winn[3] + winn[4] + winn[5]
	if thing >= 3 then
		return 1
	end
	if winn[2] == 2 || winn[3] == 2 || winn[4] == 2 || winn[5] == 2 then
		return 0
	end
	return -1
end

hook.Remove("Think","Hahaha")
local think_i = 0
function TESTDEHSLOTS() -- You shouldn't really call this unless you want to test out the slot machines yourself. It will make your server unresponsive for about 10 hours.
	local timetest = {}
	local oldtime = SysTime()
	--[[
	for i = 1,50 do
		timetest[i] = math.huge
	end
	]]
	think_i = 0
	for i = -1,8 do
		winper[i] = 0
	end
	hook.Add("Think","Hahaha",function()
		think_i = think_i + 1
		for i = 1,100000 do
			local prize = DidWinTest({slotmachineequation(),slotmachineequation(),slotmachineequation()})
			winper[prize] = winper[prize] + 1
		end
	
		timetest[#timetest + 1] = SysTime() - oldtime
		oldtime = SysTime()
		
		local averagetime = 0
		for i = 1,#timetest do
			averagetime = averagetime + timetest[i]
		end
		averagetime = averagetime/#timetest
		MsgN("Steps left: "..tostring((40000000000/100000)-think_i))
		local remainingtime = averagetime * ((40000000000/100000)-think_i)
		
		MsgN(((think_i/(40000000000/100000))*100).."%")
		MsgN("ETA: "..ARCLib.TimeString(remainingtime).." ("..remainingtime..")")
		--ARCLib.TimeString(sec)
		
		
		PrintMessage(HUD_PRINTTALK,((think_i/(40000000000/100000))*100).."%")
		PrintMessage(HUD_PRINTTALK,"ETA: "..ARCLib.TimeString(remainingtime))
		if #timetest > 100 then
			timetest = {averagetime}
		end
		if think_i == 40000000000/100000 then
			local winstrings = {}
			winstrings[-1] = "Loose/Spin"
			winstrings[0] = "Bet x 2"
			winstrings[1] = "Bet x 5"
			winstrings[2] = "Bet x 50"
			winstrings[3] = "Bet x 100"
			winstrings[4] = "Bet x 150"
			winstrings[5] = "Bet x 300"
			winstrings[6] = "Bet x 1,000"
			winstrings[7] = "Bet x 10,000"
			winstrings[8] = "Bet x 100,000"
			local str = ""
			for i = -1,8 do
																  --20000000000
				str = str..winstrings[i].." - "..tostring(winper[i]/400000000).."%".."\n"
				PrintMessage(HUD_PRINTTALK,winstrings[i].." - "..tostring(winper[i]/400000000).."%")
				MsgN(winstrings[i].." - "..tostring(winper[i]/400000000).."%")
			end
			file.Write("slotstestresult.txt",str)
			hook.Remove("Think","Hahaha")
		end
	end)

end

--]]
local winnnnn = function(mac,ply,amount)
	if !IsValid(mac) then return end
	if mac:DidWin(ply,amount) then
		mac.Status = 1
		mac.UseDelay = CurTime() + 2.75 + (ARCLib.BoolToNumber(mac.Winnings[1] > 5 && mac.Winnings[2] > 5 && mac.Winnings[3] > 5)*3.25) + (ARCLib.BoolToNumber(mac.Winnings[1] == 8 && mac.Winnings[2] == 8 && mac.Winnings[3] == 8)*52.75)
		timer.Simple(2.75 + (ARCLib.BoolToNumber(mac.Winnings[1] > 5 && mac.Winnings[2] > 5 && mac.Winnings[3] > 5)*3.25) + (ARCLib.BoolToNumber(mac.Winnings[1] == 8 && mac.Winnings[2] == 8 && mac.Winnings[3] == 8)*52.75),function()
			if !IsValid(mac) then return end
			mac.Idle = true
			mac.Status = 0
			mac:UpdateIcons()
			if mac.FreeSpins > 0 then
				mac:Spin( ply, math.random(ARCSlots_MinBet,amount) )
				mac.FreeSpins = mac.FreeSpins - 1
			end
		end)
	else
		mac.Status = -1
		mac.UseDelay = CurTime() + 1.25
		timer.Simple(1.25,function()
			if !IsValid(mac) then return end
			mac.Idle = true
			mac.Status = 0
			mac:UpdateIcons()
			if mac.FreeSpins > 0 then
				mac:Spin( ply, math.random(ARCSlots_MinBet,amount) )
				mac.FreeSpins = mac.FreeSpins - 1
			end
		end)
	end
	mac:UpdateIcons()
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
	self.ScreenMsg = string.gsub(ply:Nick(), "[^(^)^{^}^[^]^ ^_%w]", "_").." * BET "..amount
	self.SpinSound = CreateSound( self, "arcslots/spin_loop1.wav" ) 
	if IsValid(ply.SlotMachine) && ply.SlotMachine.UseDelay > CurTime() then
	return end
	if self.UseDelay > CurTime() then 
	return end
	if self.FreeSpins <= 0 then
		if self.UseARCBank then
			self:EmitSound("arcbank/atm/cardremove.wav",65,math.random(95,105))
		else
			if !ARCSlots_PlayerCanAfford(ply,amount) then 
				if ARCBank then
					ARCLib.NotifyPlayer(ply,ARCBANK_ERRORSTRINGS[4],NOTIFY_ERROR,4,true)
				else
					ARCLib.NotifyPlayer(ply,"Check yer wallet.",NOTIFY_GENERIC,4,true)
				end
				return 
			end
			self:EmitSound("arcslots/coin.wav")
			ARCSlots_AddMoneyPlayer(ply,-amount)
		end
	end
	ply.SlotMachine = self
	self.UseDelay = CurTime() + 20
	timer.Simple(ARCLib.BoolToNumber(self.FreeSpins <= 0),function() 
		if !IsValid(self) then return end
		self:EmitSound("arcslots/start.wav")
		self.SpinSound:PlayEx(70,100)
		self.Winnings[1] = -3
		self.Winnings[2] = -3
		self.Winnings[3] = -3
		self.Idle = false
		self:UpdateIcons()
		timer.Simple(math.Rand(1.1,1.7),function()
			if !IsValid(self) then return end
			self.Winnings[1] = slotmachineequation()
			self:EmitSound("arcslots/stop1.wav")
			self:UpdateIcons()
		end)
		timer.Simple(math.Rand(1.7,2.3),function()
			if !IsValid(self) then return end
			self.Winnings[2] = slotmachineequation()
			self:EmitSound("arcslots/stop2.wav")
			self:UpdateIcons()
		end)
		timer.Simple(math.Rand(2.3,3),function()
			if !IsValid(self) then return end
			if ((self.Winnings[1] == self.Winnings[2] && self.Winnings[1] > 5) || (self.Winnings[1] == 8 || self.Winnings[2] == 8)) && self.Winnings[1] > 5 && self.Winnings[2] > 5 then
				--timer.Simple(math.Rand(1,5),function()
				timer.Simple(1,function()
					if !IsValid(self) then return end
					
					self.SpinSound:ChangePitch(90,1.5) 
					self.Winnings[3] = -2
					self:UpdateIcons()
					--timer.Simple(math.Rand(2,3.5),function()
					timer.Simple(2,function()
						if !IsValid(self) then return end
						self.SpinSound:ChangePitch(80,1.5) 
						self.Winnings[3] = -1
						self:UpdateIcons()
						--timer.Simple(math.Rand(0,6),function()
						timer.Simple(3,function()
							if !IsValid(self) then return end
							self.Winnings[3] = slotmachineequation()
							self:UpdateIcons()
							self:EmitSound("arcslots/stop3.wav")
							self.SpinSound:Stop()
							timer.Simple(0.5,function() winnnnn(self,ply,amount) end)
						end)
					end)
				end)
			else
				self.Winnings[3] = slotmachineequation()
				self:UpdateIcons()
				self:EmitSound("arcslots/stop3.wav")
				self.SpinSound:Stop()
				timer.Simple(0.5,function() winnnnn(self,ply,amount) end)
			end
		end)
	end)
	
end
net.Receive( "ARCSlots_Update", function(length,ply)
	local ent = net.ReadEntity()
	local num = net.ReadInt(32)
	local UseARCBank = tobool(net.ReadBit())
	if isnumber(num) then
		num = num + 2^31
		ent.UseARCBank = (UseARCBank && ARCBank)
		if ent.UseARCBank then
			ARCBank.CanAfford(ply,math.Clamp(num,ARCSlots_MinBet,ARCSlots_MaxBet),"",function(errorcode)
				if errorcode == ARCBANK_ERROR_NONE then
					ARCBank.ReadAccountFile(ARCBank.GetAccountID(ply:SteamID()),false,function(accountdata)
						if accountdata then
							accountdata.money = accountdata.money - math.Clamp(num,ARCSlots_MinBet,ARCSlots_MaxBet)
							ARCBank.WriteAccountFile(accountdata,function(diditwork) 
								if diditwork then
									ent:Spin(ply,math.Clamp(num,ARCSlots_MinBet,ARCSlots_MaxBet))
									ARCLib.NotifyPlayer(ply,"ARCBank: "..ARCBANK_ERRORSTRINGS[ARCBANK_ERROR_NONE],NOTIFY_GENERIC,3,true)
									ARCBankAccountMsg(accountdata,"("..ply:SteamID()..")\nSpent "..math.Clamp(num,ARCSlots_MinBet,ARCSlots_MaxBet).." on a slot machine. ("..accountdata.money..")")
								else
									ARCLib.NotifyPlayer(ply,"ARCBank: "..ARCBANK_ERRORSTRINGS[ARCBANK_ERROR_WRITE_FAILURE],NOTIFY_ERROR,6,true)
								end
							end)
						else
							ARCLib.NotifyPlayer(ply,"ARCBank: "..ARCBANK_ERRORSTRINGS[ARCBANK_ERROR_READ_FAILURE],NOTIFY_ERROR,6,true)
						end
					end) 
				else
					ARCLib.NotifyPlayer(ply,"ARCBank: "..ARCBANK_ERRORSTRINGS[errorcode],NOTIFY_ERROR,6,true)
				end
			end)
		else
			ent:Spin(ply,math.Clamp(num,ARCSlots_MinBet,ARCSlots_MaxBet))
		end
		
		
	end
end)
--[[
local thing = 0
for i = 1,10000 do
	innthing = 1
	while slotmachineequation() != 8 || slotmachineequation() != 8 || slotmachineequation() != 8 do
		innthing = innthing + 1
	end
	thing = thing + innthing
end
MsgN(thing/10000)
]]


if !file.IsDir( "arcslots","DATA" ) then
	file.CreateDir("arcslots")
end

local function ARCSlots_SpawnSlotMachines()
	local shit = file.Read("arcslots/"..string.lower(game.GetMap())..".txt", "DATA" )
	if !shit then
		MsgN("ARCSlots: Cannot spawn Slot Machines. No file associated with this map.")
		return false
	end
	local atmdata = util.JSONToTable(shit)
	if !atmdata then
		MsgN("ARCSlots: Cannot spawn Slot Machines. Currupt file associated with this map.")
		return false
	end
	for _, oldatms in pairs( ents.FindByClass("sent_arc_slotmachine") ) do
		oldatms.ARCSlots_MapEntity = false
		oldatms:Remove()
	end
	MsgN("ARCSlots: Spawning Map Slot Machines...")
	for i=1,atmdata.atmcount do
			local shizniggle = ents.Create ("sent_arc_slotmachine")
			if !IsValid(shizniggle) then
				atmdata.atmcount = 1
				MsgN("ARCSlots: Slot Machines failed to spawn.")
			return false end
			if atmdata.pos[i] && atmdata.angles[i] then
				shizniggle:SetPos(atmdata.pos[i])
				shizniggle:SetAngles(atmdata.angles[i])
				shizniggle:Spawn()
				shizniggle:Activate()
			else
				shizniggle:Remove()
				atmdata.atmcount = 1
				MsgN("ARCSlots: Currupt File")
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
function ENT:OnRemove()
	self.SpinSound:Stop()
	if self.ARCSlots_MapEntity then
		timer.Simple(1,function()
			ARCSlots_SpawnSlotMachines()
		end)
	end
end

local function ARCSlots_SaveSlotMachines()
	MsgN("ARCSlots: Saving Slot Machines...")
	local atmdata = {}
	atmdata.angles = {}
	atmdata.pos = {}
	local atms = ents.FindByClass("sent_arc_slotmachine")
	atmdata.atmcount = table.maxn(atms)
	if atmdata.atmcount <= 0 then
		MsgN("ARCSlots: No Slot Machines to save!")
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
	end
	PrintTable(atmdata)
	local savepos = "arcslots/"..string.lower(game.GetMap())..".txt"
	file.Write(savepos,util.TableToJSON(atmdata))
	if file.Exists(savepos,"DATA") then
		MsgN("ARCSlots: Slot Machines Saved in: "..savepos)
		return true
	else
		MsgN("ARCSlots: Error while saving map.")
		return false
	end
end
local function ARCSlots_UnSaveSlotMachines()
	MsgN("ARCSlots: UnSaving Slot Machines...")
	local atms = ents.FindByClass("sent_arc_slotmachine")
	if table.maxn(atms) <= 0 then
		MsgN("ARCSlots: No Slot Machines to Unsave!")
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
	local savepos = "arcslots/"..string.lower(game.GetMap())..".txt"
	file.Delete(savepos)
	return true
end



local ARCSlots_Commands = {
	["save"] = {
		command = function(ply,args)
			if ARCSlots_SaveSlotMachines() then
				ARCLib.MsgCL(ply,"Slot Machines saved onto map!")
			else
				ARCLib.MsgCL(ply,"An error occured while saving the Slot Machines onto the map.")
			end
		end, 
		adminonly = true,
	},
	["unsave"] = {
		command = function(ply,args)
			if ARCSlots_UnSaveSlotMachines() then
				ARCLib.MsgCL(ply,"Slot Machines Detached from map!")
			else
				ARCLib.MsgCL(ply,"An error occured while detatching Slot Machines from map.")
			end
		end, 
		adminonly = true,
	},
	["respawn"] = {
		command = function(ply,args) 
			if ARCSlots_SpawnSlotMachines() then
				ARCLib.MsgCL(ply,"Map-Based Slot Machines Spawned!")
			else
				ARCLib.MsgCL(ply,"No Slot Machines associated with this map. (Non-existent/Currupt file)")
			end
		end, 
		adminonly = true,
	},
	["max_bet"] = {
		command = function(ply,args) 
			ARCSlots_MaxBet = tonumber(args[1])
			if !ARCSlots_MaxBet || ARCSlots_MaxBet < 2 || ARCSlots_MaxBet+1 > 2^32 then
				ARCLib.MsgCL(ply,"Invalid number. Using default.")
				ARCSlots_MaxBet = 50
			else
				ARCSlots_MaxBet = math.Round(ARCSlots_MaxBet)
				if ARCSlots_MinBet > ARCSlots_MaxBet then
					ARCSlots_MinBet = math.Round(ARCSlots_MaxBet/2)
				end
				ARCLib.MsgCL(ply,"Max bet set to "..ARCSlots_MaxBet)
			end
			file.Write("arcslots/bet.txt",""..ARCSlots_MinBet.." "..ARCSlots_MaxBet.."")
			for k,v in pairs(ents.FindByClass("sent_arc_slotmachine")) do
				v:UpdateIcons()
			end
		end, 
		adminonly = true,
	},
	["min_bet"] = {
		command = function(ply,args) 
			ARCSlots_MinBet = tonumber(args[1])
			if !ARCSlots_MinBet || ARCSlots_MinBet < 1 || ARCSlots_MinBet+1 > 2^32 then
				ARCLib.MsgCL(ply,"Invalid number. Using default.")
				ARCSlots_MinBet = 25
			else
				ARCSlots_MinBet = math.Round(ARCSlots_MinBet)
				if ARCSlots_MinBet > ARCSlots_MaxBet then
					ARCSlots_MinBet = ARCSlots_MaxBet
				end
				ARCLib.MsgCL(ply,"Min bet set to "..ARCSlots_MinBet)
			end
			file.Write("arcslots/bet.txt",""..ARCSlots_MinBet.." "..ARCSlots_MaxBet.."")
			for k,v in pairs(ents.FindByClass("sent_arc_slotmachine")) do
				v:UpdateIcons()
			end
		end, 
		adminonly = true,
	}
}
hook.Add( "PlayerAuthed", "ARCSlots PlyAuth", function( ply ) 
	timer.Simple(10,function()
		for k,v in pairs(ents.FindByClass("sent_arc_slotmachine")) do
			v:UpdateIcons()
		end
	end)
end)
concommand.Add( "arcslots", function( ply, cmd, args )
	local comm = args[1]
	table.remove( args, 1 )
	if ARCSlots_Commands[comm] then
		if ARCSlots_Commands[comm].adminonly && ply && ply:IsPlayer() && !ply:IsSuperAdmin() then
			ARCLib.MsgCL(ply,"You must be an superadmin to use this command!")
		return end
		ARCSlots_Commands[comm].command(ply,args)
	elseif !comm then
		ARCLib.MsgCL(ply,"No command. Valid Commands: save , unsave , respawn , max_bet , min_bet")
	else
		ARCLib.MsgCL(ply,"Invalid command '"..tostring(comm).."' Valid Commands: save , unsave , respawn , max_bet , min_bet")
	end
end)

hook.Add( "InitPostEntity", "ARCSlots SpawnATMs", function()
	ARCSlots_SpawnSlotMachines() 
end)

local data = file.Read("arcslots/bet.txt","DATA")
if data then
	local nums = string.Explode(" ",data)
	ARCSlots_MinBet = tonumber(nums[1])
	ARCSlots_MaxBet = tonumber(nums[2])
end