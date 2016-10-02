-- This file is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.


include('shared.lua')

surface.CreateFont( "ARCBankATMConsole", {
	font = "Lucida Console",
	size = 12,
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

net.Receive("arcslots_fakeconsolehack",function(len)
	local ent = net.ReadEntity()
	if IsValid(ent) then
		if ent.Fakehack <= CurTime() then
			ent.Fakehackcount = 1
		else
			ent.Fakehackcount = ent.Fakehackcount + 1
		end
		ent.Fakehack = CurTime() + 10
	end
end)

function ENT:Initialize()
	self.Fakehack = 0
	self.Texts = {}
	self.Texts[1] = "RockOS 0.0.1 vault.arcslots.gmod tty1"
	self.Percent = 0
	self.SparkTime = SysTime()
	self.Fakehackcount = 1
end

function ENT:Think()

end

function ENT:HackSpark()
	self.SparkTime = SysTime() + 0.1
	for i=1,26 do
		self.Texts[i] = ARCLib.RandomChars(math.random(10,39))
	end
end

function ENT:Hackable()
	return true
end
function ENT:HackStop()
	self.Hacked = false
	self.Fakehack = CurTime() + 1
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
end


function ENT:DrawIdle()
	local logintext = "vault login: "
	
	local textend = 2
	if self.Fakehack <= CurTime() && !self.Hacked then
		self.Texts[1] = "RockOS 0.0.1 vault.arcslots.gmod tty1"
		self.Texts[2] = logintext
		for i=3,26 do
			self.Texts[i] = ""
		end

		--text2 = "vault login: root"
		--text3 = "Password:"
		--text4 = "Login incorrect"
	else
		for i=1,self.Fakehackcount do
			local mul = i-1
			self.Texts[2 + 4*mul] = logintext.."root"
			self.Texts[3 + 4*mul] = "Password:"
			self.Texts[5 + 4*mul] = "Login incorrect"
			self.Texts[6 + 4*mul] = logintext
			textend = 6 + 4*mul
		end
	end
	

	if math.sin(CurTime()*math.pi*2) > 0 then
		self.Texts[textend] = self.Texts[textend] .. "_"
	end
	
	for i=1,26 do
		draw.SimpleText( self.Texts[i], "ARCBankATMConsole",-138, -154 + i*12, Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM  )
	end
	
end

function ENT:DrawHack()
	if (self.SparkTime > SysTime()) then
		for i=1,26 do
			draw.SimpleText( self.Texts[i], "ARCBankATMConsole",-138, -154 + i*12, Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM  )
		end
	else
		draw.SimpleText( "Unlocking vault...", "ARCBankATMConsole",0,-10, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
		draw.SimpleText( "|"..string.rep( "#", math.floor(self.Percent*18) )..string.rep( "-", 18 - math.floor(self.Percent*18) ).."|", "ARCBankATMConsole",0,14, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
	end
end

function ENT:Draw()
	self:DrawModel()

	if LocalPlayer():GetPos():DistToSqr(self:GetPos()) > 1000000 then return end
	
	self.DisplayPos = self:GetPos() + ((self:GetAngles():Up() * 8.72) + (self:GetAngles():Forward() * -6.4) + (self:GetAngles():Right() * (-0.015) ))
	self.displayangle1 = self:GetAngles()+Angle( 0, 0, 90 )
	self.displayangle1:RotateAroundAxis( self.displayangle1:Right(), -90 )
	self.displayangle1:RotateAroundAxis( self.displayangle1:Forward(), -25 )
	--self.screenpos = self:WorldToLocal(LocalPlayer():GetEyeTrace().HitPos)
	

	
	
	cam.Start3D2D(self.DisplayPos, self.displayangle1, 0.043)
		if self.Hacked then
			self:DrawHack()
		else
			self:DrawIdle()
		end
	cam.End3D2D()
end

