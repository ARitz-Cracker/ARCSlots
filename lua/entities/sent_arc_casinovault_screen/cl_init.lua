-- This file is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

-- WARNING! SPEGETTI CODE THAT I CAN READ PERFECTLY!

include('shared.lua')

--[
ENT.DisplayAng = Angle(0,90,90)
ENT.DisplayPos = Vector(3.3,-10.36,24.55)
ENT.ResX = 518/2
ENT.ResY = 392/2
ENT.ScrType = 5
--]]

--[[
ENT.ResY = 518/2
ENT.ResX = 392/2
ENT.DisplayAng = Angle(-90,90,90)
ENT.DisplayPos = Vector(3.23,-10.36,8.875)
ENT.ScrType = 3
--]]
surface.CreateFont( "ARCBankATMConsoleSmall", {
	font = "Lucida Console",
	size = 8,
	weight = 100,
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
	outline = false
} )



ENT.TallScroolText = {}

ENT.TriangleDraw = {}
ENT.TriangleDraw[1] = {x=ENT.ResX/2,y=ENT.ResY/2 - 64}
ENT.TriangleDraw[2] = {x=ENT.ResX/2 + 70,y=ENT.ResY/2 + 64}
ENT.TriangleDraw[3] = {x=ENT.ResX/2 - 70,y=ENT.ResY/2 + 64}
function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is need for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	draw.NoTexture()
	surface.DrawPoly( cir )
end

for i=1,32 do
	ENT.TallScroolText[i] = ARCLib.RandomChars(math.random(10,39))
end
function ENT:Initialize()
	net.Start("arcslots_monitortype")
	net.WriteEntity(self)
	net.SendToServer()
end

function ENT:Think()

end

function ENT:Draw()
	self:DrawModel()
	if LocalPlayer():GetPos():DistToSqr(self:GetPos()) > 1000000 then return end
	cam.Start3D2D(self:LocalToWorld(self.DisplayPos), self:LocalToWorldAngles(self.DisplayAng), 0.08)
		
		surface.SetDrawColor(0,0,0,255)
		surface.DrawRect(0,0,self.ResX,self.ResY)
		if self.ScrType == 1 then
			for i=1,20 do
				draw.SimpleText( ARCSlots.Settings["money_symbol"], "Trebuchet24",self.ResX/2 + i*13 - (21*13/2), self.ResY/2 + math.sin(CurTime()+i/2)--[[*math.sin(CurTime()/4)]]*85, Color(0,64,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
				draw.SimpleText( ARCSlots.Settings["money_symbol"], "Trebuchet24",self.ResX/2 + i*13 - (21*13/2), self.ResY/2 + math.sin(CurTime()/3.5+i)--[[*math.sin(CurTime()/4)]]*85, Color(0,64,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
				draw.SimpleText( ARCSlots.Settings["money_symbol"], "Trebuchet24",self.ResX/2 + i*13 - (21*13/2), self.ResY/2 + math.sin(CurTime()+i)--[[*math.sin(CurTime()/4)]]*85, Color(0,64,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
			end
			draw.SimpleText( ARCSlots.Msgs.VaultMsgs.TotalFunds, "Trebuchet24",self.ResX/2, self.ResY/2 - 12 - 36, Color(0,255,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
			draw.SimpleText( ARCSlots.Settings["money_symbol"]..ARCSlots.CasinoFunds, "Trebuchet24",self.ResX/2, self.ResY/2 + 12 - 36, Color(0,255,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
			draw.SimpleText( ARCSlots.Msgs.VaultMsgs.Funds, "Trebuchet24",self.ResX/2, self.ResY/2 - 12 + 36, Color(0,255,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
			draw.SimpleText( ARCSlots.Settings["money_symbol"]..ARCSlots.VaultFunds, "Trebuchet24",self.ResX/2, self.ResY/2 + 12 + 36, Color(0,255,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
		elseif self.ScrType == 2 then			
			for i=1,20 do
				draw.SimpleText( ARCSlots.Settings["money_symbol"], "Trebuchet24",self.ResX/2 + i*13 - (21*13/2), self.ResY/2 + math.sin(CurTime()+i/4)--[[*math.sin(CurTime()/4)]]*75, Color(0,255,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
			end
		elseif self.ScrType == 3 then
			for i=1,#self.TallScroolText do
				draw.SimpleText( self.TallScroolText[math.floor((CurTime()*15+i)%(#self.TallScroolText-1)+1)], "ARCBankATMConsoleSmall",0,i*8, Color(0,128,0,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM  )
			end
			draw.SimpleText( ARCSlots.Msgs.VaultMsgs.Status, "Trebuchet24",self.ResX/2, self.ResY/2 - 24, Color(0,255,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
			
			surface.SetDrawColor(0,255,0,255)
			surface.DrawRect(self.ResX/2 - 80, self.ResY/2 + 24 - 14 ,160, 28)
			draw.SimpleText( ARCSlots.Msgs.VaultMsgs.Secure, "Trebuchet24",self.ResX/2, self.ResY/2 + 24, Color(0,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
		elseif self.ScrType == 4 then

				draw.SimpleText( ARCSlots.Msgs.VaultMsgs.Warning, "Trebuchet24",self.ResX/2 + math.sin(CurTime()*2+2)*40, self.ResY/2 + math.sin(CurTime()+1/2)--[[*math.sin(CurTime()/4)]]*85, Color(64,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
				draw.SimpleText( ARCSlots.Msgs.VaultMsgs.Warning, "Trebuchet24",self.ResX/2 + math.sin(CurTime()*2.5+4)*40, self.ResY/2 + math.sin(CurTime()/3.5+1)--[[*math.sin(CurTime()/4)]]*85, Color(64,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
				draw.SimpleText( ARCSlots.Msgs.VaultMsgs.Warning, "Trebuchet24",self.ResX/2 + math.sin(CurTime()+1)*40, self.ResY/2 + math.sin(CurTime()+1)--[[*math.sin(CurTime()/4)]]*85, Color(64,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )

			draw.SimpleText( ARCSlots.Msgs.VaultMsgs.TotalFunds, "Trebuchet24",self.ResX/2, self.ResY/2 - 12 - 36, Color(255,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
			draw.SimpleText( ARCSlots.Settings["money_symbol"]..ARCSlots.CasinoFunds, "Trebuchet24",self.ResX/2, self.ResY/2 + 12 - 36, Color(255,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
			draw.SimpleText( ARCSlots.Msgs.VaultMsgs.Funds, "Trebuchet24",self.ResX/2, self.ResY/2 - 12 + 36, Color(255,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
			draw.SimpleText( ARCSlots.Settings["money_symbol"]..ARCSlots.VaultFunds, "Trebuchet24",self.ResX/2, self.ResY/2 + 12 + 36, Color(255,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
		elseif self.ScrType == 5 then
			surface.SetDrawColor(255,0,0,255)
			if ARCSlots.LightOn then
				draw.NoTexture()
				surface.DrawPoly(self.TriangleDraw)
				surface.SetDrawColor(255,255,255,255)
			end
			surface.DrawLine(self.TriangleDraw[1].x,self.TriangleDraw[1].y,self.TriangleDraw[2].x,self.TriangleDraw[2].y)
			surface.DrawLine(self.TriangleDraw[2].x,self.TriangleDraw[2].y,self.TriangleDraw[3].x,self.TriangleDraw[3].y)
			surface.DrawLine(self.TriangleDraw[3].x,self.TriangleDraw[3].y,self.TriangleDraw[1].x,self.TriangleDraw[1].y)
			surface.DrawRect(self.ResX/2 - 8,self.ResY/2 - 30,18,50)
			draw.Circle(self.ResX/2,140,12,20)
		elseif self.ScrType == 6 then
			for i=1,#self.TallScroolText-1 do	
				if i%6 < 5 || math.sin(CurTime()*math.pi*2) > 0 then
					draw.SimpleText( self.TallScroolText[i], "ARCBankATMConsoleSmall",0,i*8, Color(128,0,0,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM  )
				end
			end
			
			
			draw.SimpleText( ARCSlots.Msgs.VaultMsgs.Status, "Trebuchet24",self.ResX/2, self.ResY/2 - 24, Color(255,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
			
			if math.sin(CurTime()*math.pi*2) > 0 then
				draw.SimpleText( self.TallScroolText[#self.TallScroolText], "ARCBankATMConsoleSmall",0,#self.TallScroolText*8, Color(128,0,0,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM  )
				
				surface.SetDrawColor(255,0,0,255)
				surface.DrawRect(self.ResX/2 - 80, self.ResY/2 + 24 - 14 ,160, 28)
				draw.SimpleText( ARCSlots.Msgs.VaultMsgs.Insecure, "Trebuchet24",self.ResX/2, self.ResY/2 + 24, Color(0,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
			else
				draw.SimpleText( self.TallScroolText[#self.TallScroolText].."_", "ARCBankATMConsoleSmall",0,#self.TallScroolText*8, Color(128,0,0,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM  )
			
				surface.SetDrawColor(0,0,0,255)
				surface.DrawRect(self.ResX/2 - 80, self.ResY/2 + 24 - 14 ,160, 28)
				draw.SimpleText( ARCSlots.Msgs.VaultMsgs.Insecure, "Trebuchet24",self.ResX/2, self.ResY/2 + 24, Color(255,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
			end
		elseif self.ScrType == 9 then
			for i=1,#self.TallScroolText do	
				if math.random(0,300) == 300 then
					self.TallScroolText[i] = ARCLib.RandomChars(math.random(10,39))
				end
				draw.SimpleText( self.TallScroolText[i], "ARCBankATMConsoleSmall",0,i*8, Color(0,math.random(0,255),0,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM  )
			end
			draw.SimpleText( ARCSlots.Msgs.VaultMsgs.Status, "Trebuchet24",self.ResX/2, self.ResY/2 - 24, Color(255,255,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
			
			if math.sin(CurTime()*math.pi*2) > 0 then
				surface.SetDrawColor(255,255,0,255)
				surface.DrawRect(self.ResX/2 - 80, self.ResY/2 + 24 - 14 ,160, 28)
				draw.SimpleText( ARCSlots.Msgs.VaultMsgs.Warning, "Trebuchet24",self.ResX/2, self.ResY/2 + 24, Color(0,0,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
			else
				surface.SetDrawColor(0,0,0,255)
				surface.DrawRect(self.ResX/2 - 80, self.ResY/2 + 24 - 14 ,160, 28)
				draw.SimpleText( ARCSlots.Msgs.VaultMsgs.Warning, "Trebuchet24",self.ResX/2, self.ResY/2 + 24, Color(255,255,0,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER  )
			end
		end
	cam.End3D2D()
end
net.Receive("arcslots_monitortype",function(len)
	local ent = net.ReadEntity()
	local typ = net.ReadUInt(8) 
	if !IsValid(ent) then return end
	ent.ScrType = typ
	if typ % 3 == 0 then
		ent.ResY = 518/2
		ent.ResX = 392/2
		ent.DisplayAng = Angle(-90,90,90)
		ent.DisplayPos = Vector(3.23,-10.36,8.875)
	end
end)