-- This shit is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

-- WARNING! SPEGETTI CODE THAT I CAN READ PERFECTLY!

include('shared.lua')
local ARCSlots_MaxBet_CL = 50
local ARCSlots_MinBet_CL = 25
surface.CreateFont( "ARCSlotMachine", {
	font = "Transponder AOE",
	size = 24,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "ARCSlotMachineBack", {
	font = "Transponder Grid AOE",
	size = 24,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

function ENT:Initialize()
	self.Winnings = {}
	self.Winnings[1] = math.random(0,8)
	self.Winnings[2] = math.random(0,8)
	self.Winnings[3] = math.random(0,8)
	self.ClickTime = {}
	self.ClickTime[1] = 0
	self.ClickTime[2] = 0
	self.ClickTime[3] = 0
	self.Status = 0
	self.IdleTime = CurTime()
	self.Idle = true
	
	self.SScreenScroll = 1
	self.SScreenScrollDelay = CurTime() + 0.1
	self.ScreenScroll = 1
	self.ScreenScrollDelay = CurTime() + 0.1
	self.TopScreenText = "FEELIN LUCKY TODAY? $$$ MAX PRIZE *** "..ARCLib.ShortScale(ARCSlots_MaxBet_CL*100000,0).." ***"
	self.BottomScreenText = "FEELIN LUCKY TODAY? $$$ MAX PRIZE *** "..ARCLib.ShortScale(ARCSlots_MaxBet_CL*100000,0).." ***"
	
		--Special thanks to swep construction kit
	local selectsprite = { sprite = "effects/yellowflare", nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false}
	local name = selectsprite.sprite.."-"
	local params = { ["$basetexture"] = selectsprite.sprite }
	local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
	for i, j in pairs( tocheck ) do
		if (selectsprite[j]) then
			params["$"..j] = 1
			name = name.."1"
		else
			name = name.."0"
		end
	end
	self.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
end

function ENT:Think()

end

function ENT:OnRestore()
end
--[[fadsadad
function ENT:Draw()
	self:DrawModel()
	self:DrawShadow( true )
end
--]]
net.Receive( "ARCSlots_Update", function(length)
	local machine = net.ReadEntity()
	local idle = tobool(net.ReadBit())
	local one = net.ReadInt(4) + 5
	local two = net.ReadInt(4) + 5
	local three = net.ReadInt(4) + 5
	local status = net.ReadInt(2)
	local winning = net.ReadInt(4) + 5
	local msg = net.ReadString()
	ARCSlots_MinBet_CL = net.ReadInt(32) + 2^31
	ARCSlots_MaxBet_CL = net.ReadInt(32) + 2^31
	if !IsValid(machine) then return end
	if !machine.Winnings then return end
	
	machine.Idle = idle
	
	if machine.Winnings[1] != one then
		machine.ClickTime[1] = CurTime()
	end
	if machine.Winnings[2] != two then
		machine.ClickTime[2] = CurTime()
	end
	if machine.Winnings[3] != three then
		machine.ClickTime[3] = CurTime()
	end
	machine.Status = status
	machine.WinningThing = winning
	machine.Winnings[1] = one
	machine.Winnings[2] = two
	machine.Winnings[3] = three
	machine.Idle = idle
	machine.BottomScreenText = tostring(msg)
	if idle then
		machine.IdleTime = CurTime() + math.Rand(5,15)
	end
	machine.TopScreenText = "FEELIN LUCKY TODAY? $$$ MAX PRIZE *** "..ARCLib.ShortScale(ARCSlots_MaxBet_CL*100000,0).." ***"
	if machine.Winnings[1] == -3 then
		machine.ScreenScroll = 26
	end
end)
local winicons = {}
local winiconstext = {}
winiconstext[-3] = "*******"
winiconstext[-2] = "*******"
winiconstext[-1] = "ALMOST*"
winiconstext[0] = " BROKE"
winiconstext[1] = " SPIN"
winiconstext[2] = " HEART"
winiconstext[3] = " CLUB"
winiconstext[4] = "DIAMOND"
winiconstext[5] = " SPADE"
winiconstext[6] = " MONEY"
winiconstext[7] = " SEVEN"
winiconstext[8] = " WILD~"
for i = 0,8 do
	winicons[i] = surface.GetTextureID("arc/slotmachine/winners/icon"..tostring(i).."")
end
winicons[-1] = surface.GetTextureID("arc/slotmachine/spin")
winicons[-2] = surface.GetTextureID("arc/slotmachine/spinfast")
winicons[-3] = surface.GetTextureID("arc/slotmachine/spinfastfast")
function ENT:Draw()
	self:DrawModel()
	self:DrawShadow( true )
	
	
	
	
	
if self.ScreenScrollDelay < CurTime() && string.len(self.BottomScreenText) > 23 then
	self.ScreenScrollDelay = CurTime() + 0.1
	self.ScreenScroll = self.ScreenScroll + 1
	if (self.ScreenScroll) > string.len("                           "..self.BottomScreenText.."                           ") then
		self.ScreenScroll = 1
	end
end
if self.SScreenScrollDelay < CurTime() && string.len(self.TopScreenText) > 23 then
	self.SScreenScrollDelay = CurTime() + 0.1
	self.SScreenScroll = self.SScreenScroll + 1
	if (self.SScreenScroll) > string.len("                           "..self.TopScreenText.."                           ") then
		self.SScreenScroll = 1
	end
end
	
	
	
	
	local DisplayPos = self:GetPos() + (self:GetAngles():Up() * 17.15) + (self:GetAngles():Right() * 2.05 ) + (self:GetAngles():Forward() * 14.95 )
	cam.Start3D2D(DisplayPos, self:GetAngles()+Angle( 0, 0, 90 ), 0.1246)
		draw.SimpleText( "_______________________" , "ARCSlotMachineBack", -115,-49, Color(100,0,0,100), TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER   )
		draw.SimpleText( "_______________________" , "ARCSlotMachineBack", -115,45, Color(100,0,0,100), TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER   )
		if self.Idle && self.IdleTime < CurTime() then
			if string.len(self.TopScreenText) > 23 then
			--TopScreenText
				draw.SimpleText( string.Right(string.Left( "                           "..self.TopScreenText.."                           ", self.SScreenScroll ),23), "ARCSlotMachine",-115,-49, Color(255,0,0,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER  )
			else
				draw.SimpleText( self.TopScreenText, "ARCBankATM",-115,-49, Color(255,0,0,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER  )
			end
		else
			draw.SimpleText( winiconstext[self.Winnings[1]] , "ARCSlotMachine", -115,-49, Color(255,0,0,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER   )
			draw.SimpleText( winiconstext[self.Winnings[2]] , "ARCSlotMachine", -35,-49, Color(255,0,0,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER   )
			draw.SimpleText( winiconstext[self.Winnings[3]] , "ARCSlotMachine", 45,-49, Color(255,0,0,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER   )
			if string.len(self.BottomScreenText) > 23 then
				draw.SimpleText( string.Right(string.Left( "                           "..self.BottomScreenText.."                           ", self.ScreenScroll ),23), "ARCSlotMachine",-115,45, Color(255,0,0,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER  )
			else
				draw.SimpleText( self.BottomScreenText, "ARCSlotMachine",-115,45, Color(255,0,0,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER  )
			end
		end
		if self.Status == 0 then
			if self.Winnings[1] >= 0 && (self.ClickTime[1] - CurTime()) < -0.5 then
				if self.Winnings[1] == 0 then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 0, 255 )
				end
			else
				surface.SetDrawColor( 255, 255, 255, 255 )
			end
			surface.DrawRect(-112, -32, 64, 64 ) -- b1
			if self.Winnings[2] >= 0 && (self.ClickTime[2] - CurTime()) < -0.5 then
				if self.Winnings[2] == 0 then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 0, 255 )
				end
			else
				surface.SetDrawColor( 255, 255, 255, 255 )
			end
			surface.DrawRect(-32, -32, 64, 64 ) -- b2
			if self.Winnings[3] >= 0 && (self.ClickTime[3] - CurTime()) < -0.5 then
				if self.Winnings[3] == 0 then
					surface.SetDrawColor( 255, 0, 0, 255 )
				else
					surface.SetDrawColor( 255, 255, 0, 255 )
				end
			else
				surface.SetDrawColor( 255, 255, 255, 255 )
			end
			surface.DrawRect(48, -32, 64, 64 ) -- b3
		elseif self.Status == 1 then
			surface.SetDrawColor( 0, (math.sin(CurTime()*9)/2+0.5)*255, 0, 255 )
			if self.WinningThing == self.Winnings[1] || self.Winnings[1] == 8 || self.WinningThing == 10 then
				surface.DrawRect(-112, -32, 64, 64 ) -- b1
			end
			if self.WinningThing == self.Winnings[2] || self.Winnings[2] == 8 || self.WinningThing == 10 then
				surface.DrawRect(-32, -32, 64, 64 ) -- b2
			end
			if self.WinningThing == self.Winnings[3] || self.Winnings[3] == 8 || self.WinningThing == 10 then
				surface.DrawRect(48, -32, 64, 64 ) -- b3
			end
		elseif self.Status == -1 then
			surface.SetDrawColor( (math.sin(CurTime()*9)/2+0.5)*255, 0, 0, 255 )
			surface.DrawRect(-112, -32, 64, 64 ) -- b1
			surface.DrawRect(-32, -32, 64, 64 ) -- b2
			surface.DrawRect(48, -32, 64, 64 ) -- b3
		end
		
		--1

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture(winicons[self.Winnings[1]]) 
		if self.Winnings[1] >= 0 then
			--((self.ClickTime[1] - CurTime())*-1)
			surface.DrawTexturedRect(-112, -32+math.floor(1/((2*(((self.ClickTime[1] - CurTime())*-1)-0.05))^2+0.25)), 64, 64 ) 
		else
			surface.DrawTexturedRect(-112, -32, 64, 64 ) 
		end
		surface.DrawOutlinedRect(-112, -32, 64, 64 )
		--2

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture(winicons[self.Winnings[2]]) 
		if self.Winnings[2] >= 0 then
		--1/((2(x-0.15))^2+0.25)
		--
			surface.DrawTexturedRect(-32, -32+math.floor(1/((2*(((self.ClickTime[2] - CurTime())*-1)-0.05))^2+0.25)), 64, 64 ) 
		else
			surface.DrawTexturedRect(-32, -32, 64, 64 ) 
		end
		surface.DrawOutlinedRect(-32, -32, 64, 64 ) 
		--3

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture(winicons[self.Winnings[3]]) 
		if self.Winnings[3] >= 0 then
		--
			surface.DrawTexturedRect(48, -32+math.floor(1/((2*(((self.ClickTime[3] - CurTime())*-1)-0.05))^2+0.25)), 64, 64 )
		else
			surface.DrawTexturedRect(48, -32, 64, 64 ) 
		end
		surface.DrawOutlinedRect(48, -32, 64, 64 ) 
		
		for i = 0,8 do
			if self.Status == 0 then
				if self.Winnings[3] < 0 then
					surface.SetDrawColor( 255, 255, 255, (math.sin(-CurTime()*20+i)/2+0.5)*255 )
				else
					surface.SetDrawColor( 255, 255, 0, (math.sin(-CurTime()*2+i)/2+0.5)*255 )
				end
			elseif self.Status == -1 then
				surface.SetDrawColor( 255, 0, 0, (math.sin(-CurTime()*2+i)/2+0.5)*255 )
			elseif self.Status == 1 then
				if self.WinningThing < 6 || self.WinningThing == 10 then
					surface.SetDrawColor( 0, 255, 0, (math.sin(-CurTime()*2+i)/2+0.5)*255 )
				elseif self.WinningThing == 6 then
					surface.SetDrawColor( 0, 255, 0, (math.sin(-CurTime()*4+i)/2+0.5)*255 )
				elseif self.WinningThing == 7 then
					surface.SetDrawColor( 0, 255, 0, (math.sin(-CurTime()*8+i)/2+0.5)*255 )
				else
					surface.SetDrawColor((math.sin(-CurTime()*4+(2*math.pi/3)+i)/2+0.5)*255,(math.sin(-CurTime()*4+(4*math.pi/3)+i)/2+0.5)*255,(math.sin(-CurTime()*4+i)/2+0.5)*255,255)
				end
			end
			surface.DrawRect(-136, -62+(i*14), 12, 12 )
			surface.DrawRect(124, -62+(i*14), 12, 12 )
			surface.SetDrawColor(255,255,255,180)
			surface.DrawOutlinedRect(-136, -62+(i*14), 12, 12 )
			surface.DrawOutlinedRect(124, -62+(i*14), 12, 12 )
			
		end
	
		
		
	cam.End3D2D()
	
	if self.Status == 1 then
		--if math.sin(CurTime() * 24) > 0 then
			render.SetMaterial(self.spriteMaterial)
			--(math.sin(CurTime()+(2*math.pi/3))/2+0.5)*255
			if self.Winnings[1] == 8 && self.Winnings[2] == 8 && self.Winnings[3] == 8 then
			--(math.sin(CurTime()*4)*32)+48
				render.DrawSprite(self:LocalToWorld(Vector(15.6,12.7,36)), 32, 32, Color((math.sin(CurTime()*6+(2*math.pi/3))/2+0.5)*255,(math.sin(CurTime()*6+(4*math.pi/3))/2+0.5)*255,(math.sin(CurTime()*6)/2+0.5)*255,255))
			else
				render.DrawSprite(self:LocalToWorld(Vector(15.6,12.7,36)), 32, 32, Color(255,32,0,(math.sin(CurTime()*10)/2+0.5)*255))
			end
		--end
	end
end
local lastbet = 0

function ENT:ReqSpin(UseARCBank)
	if lastbet == 0 then
		lastbet = math.Round((ARCSlots_MinBet_CL+ARCSlots_MaxBet_CL)/2)
	end
	Derma_StringRequest( "Enter Bet", ""..ARCSlots_MinBet_CL.."-"..ARCSlots_MaxBet_CL.."", tostring(lastbet), function(text) 
		if IsValid(self) then
			local num = tonumber(text)
			if isnumber(num) then
				net.Start("ARCSlots_Update")
				net.WriteEntity(self.Entity)
				net.WriteInt(num - (2^31),32)
				net.WriteBit(UseARCBank)
				net.SendToServer()
				lastbet = math.Clamp(num,ARCSlots_MinBet_CL,ARCSlots_MaxBet_CL)
			end
		end
	end)
end