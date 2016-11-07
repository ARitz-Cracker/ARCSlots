-- This shit is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- � Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

-- WARNING! SPEGETTI CODE THAT I CAN READ PERFECTLY!

include('shared.lua')
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
	self.LastStatus = 0
	self.Status = 0
	self.IdleTime = CurTime()
	self.Idle = true
	
	self.GreenCardLight = SysTime() + 1
	self.RedCardLight = SysTime() + 1
	
	self.FakeIcons = {math.random(0,8),math.random(0,8),math.random(0,8)}
	self.FakeIconsPos = {0,0,0}
	
	self.TopScreenText = "THIS IS A NEW SLOT MACHINE"
	self.BottomScreenText = "THIS IS A NEW SLOT MACHINE"
	
	self.WheelPos = table.FullCopy(self.WheelPos)
	self.prizecolours = table.FullCopy(self.prizecolours)
	
	self.SpinnerPos = {model="models/arc/slotmachine_pull_bar.mdl",pos=vector_origin,angle=angle_zero}
		--Special thanks to swep construction kit
		self.LastWildChange = SysTime()
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

function ENT:OnRestore()
end
--[[fadsadad
function ENT:Draw()
	self:DrawModel()
	self:DrawShadow( true )
end
--]]
net.Receive( "ARCSlots_cardlight", function(length)
	local ent = net.ReadEntity()
	if IsValid(ent) then
		if (net.ReadBool()) then
			ent.GreenCardLight = SysTime() + 1
		else
			ent.RedCardLight = SysTime() + 1
		end
	end
end)

net.Receive( "ARCSlots_Update", function(length)
	local machine = net.ReadEntity()
	local idle = tobool(net.ReadBit())
	local newnums = {}
	newnums[1] = net.ReadInt(4) + 4
	newnums[2] = net.ReadInt(4) + 4
	newnums[3] = net.ReadInt(4) + 4
	local status = net.ReadInt(2)
	local winning = net.ReadInt(4) + 4
	local msg = net.ReadString()
	if !IsValid(machine) then return end
	if !machine.Winnings then return end
	
	machine.Idle = idle
	
	if newnums[1] < -2 then
		machine.SpinAnimStartTime = SysTime()
	end
	
	for i=1,3 do
		if machine.Winnings[i] != newnums[i] then
			machine.ClickTime[i] = SysTime()
			
			machine.Winnings[i] = newnums[i]
			machine.WheelPos[i].ficon1 = ARCLib.RandomExclude(0,8,newnums[i])
			machine.WheelPos[i].ficon2 = ARCLib.RandomExclude(0,8,newnums[i])
			
			if !machine.ExtraCodeForDetail then
				if newnums[i] == 0 then
					machine.WheelPos[i].bdcol = Color(255,0,0,255)
				elseif newnums[i] > 0 then
					machine.WheelPos[i].bdcol = Color(0,255,0,255)
				elseif newnums[i] < 0 then
					machine.WheelPos[i].bgcol = color_white
					machine.WheelPos[i].bdcol = Color(0,0,255,255)
					machine.WheelPos[i].spintime = SysTime()
				end
			end
		end
	end
	if !machine.ExtraCodeForDetail then
		for i=1,3 do
			if machine.Winnings[i] == 0 then
				for ii=1,3 do
					machine.WheelPos[ii].bdcol = Color(255,0,0,255)
				end
			end
		end
	end
	

	
	machine.LastStatus = machine.Status 
	if status == -1 then
		for i=1,3 do
			machine.WheelPos[i].bdcol = Color(255,0,0,255)
		end
		machine.LastFlash = SysTime()
	elseif status == 1 then
		for i=1,3 do
			machine.WheelPos[i].bdcol = Color(0,255,0,255)
		end
		machine.LastFlash = SysTime()
	end
	machine.Status = status
	machine.WinningThing = winning
	machine.Idle = idle
	if machine.BottomScreenText != msg then
		machine.ScrollPos = -23 --len is 23
	end
	machine.BottomScreenText = tostring(msg)
	if idle then
		machine.IdleTime = SysTime() + math.random(5,15)
	end

end)
local winicons = {}
local winiconstext = {}
winiconstext[-4] = "*******"
winiconstext[-3] = "*******"
winiconstext[-2] = "*******"
winiconstext[-1] = "ALMOST*"
winiconstext[0] = " BROKE "
winiconstext[1] = " SPIN  "
winiconstext[2] = " HEART "
winiconstext[3] = " CLUB  "
winiconstext[4] = "DIAMOND"
winiconstext[5] = " SPADE "
winiconstext[6] = " MONEY "
winiconstext[7] = " SEVEN "
winiconstext[8] = " WILD~ "
for i = 0,8 do
	winicons[i] = surface.GetTextureID("arc/slotmachine/winners_new/icon"..tostring(i).."")
end
winicons[-1] = surface.GetTextureID("arc/slotmachine/spin_new")
winicons[-2] = surface.GetTextureID("arc/slotmachine/spinfast_new")
winicons[-3] = surface.GetTextureID("arc/slotmachine/spinfastfast_new")
winicons[-4] = surface.GetTextureID("arc/slotmachine/spinfastfast_new2")

ENT.SlotXRes = 304
ENT.SlotYRes = 186

ENT.CenterX = ENT.SlotXRes/2
ENT.CenterY = ENT.SlotYRes/2

ENT.WheelHight = 128
ENT.WheelWidth = 64
ENT.WheelPos = {{},{},{}}

ENT.WheelPos[2].x = ENT.CenterX - 32
ENT.WheelPos[2].y = ENT.CenterY - ENT.WheelHight/2

ENT.WheelPos[2].bgcol = Color(255,255,255,150)
ENT.WheelPos[2].bdcol = Color(0,0,255,255)
ENT.WheelPos[2].ficon1 = math.random(0,8)
ENT.WheelPos[2].ficon2 = math.random(0,8)

ENT.WheelPos[1].x = ENT.WheelPos[2].x - 80
ENT.WheelPos[1].y = ENT.WheelPos[2].y

ENT.WheelPos[1].bgcol = Color(255,255,255,150)
ENT.WheelPos[1].bdcol = Color(0,0,255,255)
ENT.WheelPos[1].ficon1 = math.random(0,8)
ENT.WheelPos[1].ficon2 = math.random(0,8)

ENT.WheelPos[3].x = ENT.WheelPos[2].x + 80
ENT.WheelPos[3].y = ENT.WheelPos[2].y

ENT.WheelPos[3].bgcol = Color(255,255,255,150)
ENT.WheelPos[3].bdcol = Color(0,0,255,255)
ENT.WheelPos[3].ficon1 = math.random(0,8)
ENT.WheelPos[3].ficon2 = math.random(0,8)

ENT.DoStencil = halo.RenderedEntity == nil

ENT.LastFlash = 0

ENT.ScrollPos = -22 --len is 23
ENT.ScrollTime = 0

ENT.FakeIconsSpeedPos = 0
ENT.LastFakeIconTime = 0
ENT.FakeIconSpeed = 10
color_black = Color(0,0,0,255)
ENT.ExtraCodeForDetail = false

ENT.SpinAnimStartTime = 0
function ENT:Think()
	if self.Winnings[3] == -1 || self.ExtraCodeForDetail then
	
		local x = SysTime() - self.WheelPos[3].spintime
		self.FakeIconSpeed = 0.8^(x-27) + 100
	
		--self.FakeIconSpeed
		self.FakeIconsSpeedPos = self.FakeIconsSpeedPos + self.FakeIconSpeed * (SysTime() - self.LastFakeIconTime)
		self.LastFakeIconTime = SysTime()
		if !self.ExtraCodeForDetail then
			self.ExtraCodeForDetail = true
			for i=1,3 do
				self.FakeIcons[i] = ARCLib.RandomExclude(0,8,unpack(self.FakeIcons))
			end
		end
	end
	if self.FakeIconsSpeedPos > 1e13 then
		self.FakeIconsSpeedPos = 0
	end
	
	if self.Idle && self.IdleTime <= SysTime() then
		for i=1,3 do
			if self.WheelPos[i].bdcol != color_black then
				self.WheelPos[i].bdcol = color_black
				self.WheelPos[i].bgcol = color_white
			end
		end
	elseif self.LastFlash <= SysTime() then
		if self.Status == 0 then
			if self.WheelPos[1].bdcol.b < 255 then
				if self.LastStatus == -1 then
					for i=1,3 do
					self.WheelPos[i].bdcol.r = 255
					end
				elseif self.LastStatus == 1 then
					for i=1,3 do
						self.WheelPos[i].bdcol.r = 0
						self.WheelPos[i].bdcol.b = 0
						self.WheelPos[i].bgcol.r = 255
						self.WheelPos[i].bgcol.g = 255
						self.WheelPos[i].bgcol.b = 255
					end
				end
			end
		elseif self.Status == -1 then
			local oneflash = true
			for i=1,3 do
				if self.Winnings[i] == 0 then
					if self.WheelPos[i].bdcol.r == 0 then
						self.WheelPos[i].bdcol.r = 255
					else
						self.WheelPos[i].bdcol.r = 0
					end
					oneflash = false
				end

			end
			if oneflash then
				for i=1,3 do
					if self.WheelPos[i].bdcol.r == 0 then
						self.WheelPos[i].bdcol.r = 255
					else
						self.WheelPos[i].bdcol.r = 0
					end
				end
			end
			self.LastFlash = self.LastFlash + 0.2
		elseif self.Status == 1 then
			if self.WinningThing == 8 then
				for i=1,3 do
					self.WheelPos[i].bdcol.r = (math.sin(-SysTime()*4+(2*math.pi/3))/2+0.5)*255
					self.WheelPos[i].bdcol.g = (math.sin(-SysTime()*4+(4*math.pi/3))/2+0.5)*255
					self.WheelPos[i].bdcol.b = (math.sin(-SysTime()*4)/2+0.5)*255
					
					--self.WheelPos[i].bgcol.r = 0
					--self.WheelPos[i].bgcol.b = 0
					--self.WheelPos[i].bgcol.g = (math.sin(SysTime()*10)/2+0.5)*255
				end
			else
				for i=1,3 do
					if self.Winnings[i] == 8 || self.WinningThing == 9 || self.Winnings[i] == self.WinningThing then
						if self.WheelPos[i].bdcol.g == 0 then
							self.WheelPos[i].bdcol.g = 255
							
							--self.WheelPos[i].bgcol.g = 0
						else
							self.WheelPos[i].bdcol.g = 0
							
							--self.WheelPos[i].bgcol.g = 255
						end
					end
					
				end
				self.LastFlash = self.LastFlash + 0.2
			end
		end
	end
	
end
function ENT:DrawMainScreen()


	
	--OLD EQUATION: 
	
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect(0,0,self.SlotXRes,self.SlotYRes)
	if (halo.RenderedEntity && halo.RenderedEntity() != self) || self.DoStencil then
	-- I have no idea how to stencil, but hey, it works, and doesn't cause significant FPS drop
	render.ClearStencil() --Clear stencil
	render.SetStencilEnable( true ) --Enable stencil
	render.SetStencilWriteMask( 255 )
	render.SetStencilTestMask( 255 )
	--STENCILOPERATION_KEEP
	--STENCILOPERATION_INCR
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
	render.SetStencilFailOperation( STENCILOPERATION_INCR )
	render.SetStencilPassOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation(  STENCILOPERATION_KEEP  )


	-- Yeah yeah, I know drawing a giant box around the phone is probaly not the best way to do it. If anyone is willing to teach me how to stencil, that would be appriciated (You'd get moneh for it toooo!)
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( self.WheelPos[1].x, self.WheelPos[1].y-64, 240, 64 )
	
	surface.DrawRect( self.WheelPos[1].x, self.WheelPos[1].y+128, 240, 64 )

	--surface.SetDrawColor( 255, 255, 255, 255 )
	--surface.DrawRect( -100, 0, 100, 100 ) --224

	render.SetStencilReferenceValue( 0 ) --Reference value 1
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL ) --Only draw if pixel value == reference value
	-----------------------------------
	--Thing to be drawn in the cutout--
	-----------------------------------
	end
	for i=1,3 do
		surface.SetDrawColor(ARCLib.ConvertColor(self.WheelPos[i].bgcol))
		surface.DrawRect(self.WheelPos[i].x, self.WheelPos[i].y, self.WheelWidth, self.WheelHight ) 
		
		--machine.WheelPos[i].ficon1
		
		if self.ExtraCodeForDetail && i==3 then
			for ii=1,3 do
				surface.SetDrawColor(255,255,255,255)
				
				surface.SetTexture(winicons[self.FakeIcons[ii]]) 
				local curpos = -64 + ( ii*64 + self.FakeIconsSpeedPos  )%192
				surface.DrawTexturedRect(self.WheelPos[i].x, self.WheelPos[i].y+curpos, 64, 64 ) 
				if self.FakeIconsPos[ii] > curpos then
					if self.Winnings[i] == -1 then
						self.FakeIcons[ii] = ARCLib.RandomExclude(0,8,unpack(self.FakeIcons))
					else
						local ok = true
						if ii > 1 then
							ok = ok && self.FakeIcons[1] == self.WheelPos[i].ficon1
						end
						if ii > 2 then
							ok = ok && self.FakeIcons[2] == self.Winnings[i]
						end
						if ok then
							if ii==1 then
								self.FakeIcons[1] = self.WheelPos[i].ficon1
							elseif ii==2 then
								self.FakeIcons[2] = self.Winnings[i]
							else
								self.FakeIcons[3] = self.WheelPos[i].ficon2
							end
						end
					end
				end
				self.FakeIconsPos[ii] = curpos
			end
			if self.Winnings[i] != -1 then
				local ok = true
				ok = ok && self.FakeIcons[1] == self.WheelPos[i].ficon1
				ok = ok && self.FakeIcons[2] == self.Winnings[i]
				ok = ok && self.FakeIcons[3] == self.WheelPos[i].ficon2
				ok = ok && self.FakeIconsPos[3] >= self.WheelPos[i].y+80
				if ok || self.Winnings[i] < -1 then
					self.ExtraCodeForDetail = false
					self.ClickTime[3] = SysTime()
					self:EmitSound("arcslots/stop3.wav",65,math.random(85,101))
					self.WheelPos[3].bdcol = Color(0,255,0,255)
					for i=1,3 do
						if self.Winnings[i] == 0 then
							for ii=1,3 do
								self.WheelPos[ii].bdcol = Color(255,0,0,255)
							end
						end
					end
				end
			end
		elseif self.Winnings[i] >= 0 then
			local x = SysTime() - self.ClickTime[i]
			local add = 1 / ((2*(x-0.05))^2+0.05)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetTexture(winicons[self.WheelPos[i].ficon1]) 
			surface.DrawTexturedRect(self.WheelPos[i].x, self.WheelPos[i].y-32 + add, 64, 64 ) 

			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetTexture(winicons[self.Winnings[i]]) 
			surface.DrawTexturedRect(self.WheelPos[i].x, self.WheelPos[i].y+32 + add, 64, 64 ) 
			
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetTexture(winicons[self.WheelPos[i].ficon2]) 
			surface.DrawTexturedRect(self.WheelPos[i].x, self.WheelPos[i].y+96 + add, 64, 64 ) 
			
			
		else
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetTexture(winicons[self.Winnings[i]])
			surface.DrawTexturedRect(self.WheelPos[i].x, self.WheelPos[i].y, 64, 128 ) 
		end
		surface.SetDrawColor(ARCLib.ConvertColor(self.WheelPos[i].bdcol))
		surface.DrawOutlinedRect(self.WheelPos[i].x, self.WheelPos[i].y, self.WheelWidth, self.WheelHight )
		surface.DrawOutlinedRect(self.WheelPos[i].x+1, self.WheelPos[i].y+1, self.WheelWidth-2, self.WheelHight-2 )
		
		
		
	end
	if (halo.RenderedEntity && halo.RenderedEntity() != self) || self.DoStencil then
		render.SetStencilEnable( false )
	end
	for i = 0,12 do
		if self.Status == 0 or self.ExtraCodeForDetail then
			if self.Winnings[3] < 0 or self.ExtraCodeForDetail then
				surface.SetDrawColor( 255, 255, 255, (math.sin(-SysTime()*20+i)/2+0.5)*255 )
			else
				local time = -SysTime()*2+i
				if self.Idle && self.IdleTime < SysTime() then
					time = time%(math.pi*6)
					if !(time > 3*math.pi/2 && time < 7*math.pi/2 ) then
						time = 3*math.pi/2
					end
				end
				surface.SetDrawColor( 255, 255, 0, (math.sin(time)/2+0.5)*255 )
			end
		elseif self.Status == -1 then
			surface.SetDrawColor( 255, 0, 0, (math.sin(-SysTime()*2+i)/2+0.5)*255 )
		elseif self.Status == 1 then
			if self.WinningThing < 6 || self.WinningThing == 9 then
				surface.SetDrawColor( 0, 255, 0, (math.sin(-SysTime()*2+i)/2+0.5)*255 )
			elseif self.WinningThing == 6 then
				surface.SetDrawColor( 0, 255, 0, (math.sin(-SysTime()*4+i)/2+0.5)*255 )
			elseif self.WinningThing == 7 then
				surface.SetDrawColor( 0, 255, 0, (math.sin(-SysTime()*8+i)/2+0.5)*255 )
			else
				surface.SetDrawColor((math.sin(-SysTime()*4+(2*math.pi/3)+i)/2+0.5)*255,(math.sin(-SysTime()*4+(4*math.pi/3)+i)/2+0.5)*255,(math.sin(-SysTime()*4+i)/2+0.5)*255,255)
			end
		end
		surface.DrawRect(5, 2+(i*14), 12, 12 )
		surface.DrawRect(20, 2+(i*14), 12, 12 )
		
		surface.DrawRect(self.SlotXRes-5-12, 2+(i*14), 12, 12 )
		surface.DrawRect(self.SlotXRes-20-12, 2+(i*14), 12, 12 )
		
		
		surface.SetDrawColor(255,255,255,180)
		surface.DrawOutlinedRect(5, 2+(i*14), 12, 12 )
		surface.DrawOutlinedRect(20, 2+(i*14), 12, 12 )
		
		surface.DrawOutlinedRect(self.SlotXRes-5-12, 2+(i*14), 12, 12 )
		surface.DrawOutlinedRect(self.SlotXRes-20-12, 2+(i*14), 12, 12 )
		
	end
	
	
	--[[
	BottomScreenText
	
	ENT.ScrollPos = -22 --len is 23
	ENT.ScrollTime = 0
	]]
	draw.SimpleText( "_______________________" , "ARCSlotMachineBack", self.CenterX,16, Color(100,0,0,100), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER   )
	
	draw.SimpleText( "_______________________" , "ARCSlotMachineBack",self.CenterX,self.SlotYRes-16, Color(100,0,0,100), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER   )
	if self.Idle && self.IdleTime <= SysTime() then
		draw.SimpleText( ARCLib.ScrollChars(ARCSlots.Settings["slots_idle_text"],self.ScrollPos,23) , "ARCSlotMachine",self.CenterX-115,16, Color(255,0,0,100), TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER   )
		self:ScrollStuffs(ARCSlots.Settings["slots_idle_text"])
	else
		draw.SimpleText( winiconstext[self.Winnings[1]] , "ARCSlotMachine",self.CenterX-80,16, Color(255,0,0,100), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER   )
		draw.SimpleText( winiconstext[self.Winnings[2]] , "ARCSlotMachine",self.CenterX,16, Color(255,0,0,100), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER   )
		if self.ExtraCodeForDetail then
			draw.SimpleText( winiconstext[-1] , "ARCSlotMachine",self.CenterX+80,16, Color(255,0,0,100), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER   )
		else
			draw.SimpleText( winiconstext[self.Winnings[3]] , "ARCSlotMachine",self.CenterX+80,16, Color(255,0,0,100), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER   )
		end
		if #self.BottomScreenText > 0 then
			if utf8.len(self.BottomScreenText) > 23 then
				draw.SimpleText( ARCLib.ScrollChars(self.BottomScreenText,self.ScrollPos,23) , "ARCSlotMachine",self.CenterX-115,self.SlotYRes-16, Color(255,0,0,100), TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER   )
				self:ScrollStuffs(self.BottomScreenText)
			else
				draw.SimpleText( self.BottomScreenText , "ARCSlotMachine",self.CenterX-115,self.SlotYRes-16, Color(255,0,0,100), TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER   )
			end
		end
	end

end

function ENT:ScrollStuffs(str)
	if !isstring(str) || #str == 0 then return end
	if self.ScrollTime <= SysTime() then
		self.ScrollPos = self.ScrollPos + 1 
		if self.ScrollPos > utf8.len(str) then
			self.ScrollPos = -22
		end
		self.ScrollTime = SysTime() + 0.1
	end
end
ENT.prizecolours = {}
ENT.prizecolours[1] = {Color(255,64,64,255),Color(80,80,80,255),Color(255,64,64,255),Color(80,80,80,255)}
ENT.prizecolours[2] = Color(80,80,80,255)
ENT.prizecolours[3] = Color(255,64,64,255)
ENT.prizecolours[4] = Color(80,80,80,255)
ENT.prizecolours[5] = Color(255,64,64,255)
ENT.prizecolours[6] = Color(80,80,80,255)
ENT.prizecolours[7] = Color(10,200,10,255)
ENT.prizecolours[8] = Color(255,40,10,255)
ENT.prizecolours[9] = Color(180,0,0,255)

local cardssym = {"♥","♣","♦","♠"}
ENT.prizesymbols = {}
ENT.prizesymbols[1] = {"♥ ♥","♣ ♣","♦ ♦","♠ ♠"}
ENT.prizesymbols[2] = "♥ ♣ ♦"
ENT.prizesymbols[3] = "♥ ♥ ♥"
ENT.prizesymbols[4] = "♣ ♣ ♣"
ENT.prizesymbols[5] = "♦ ♦ ♦"
ENT.prizesymbols[6] = "♠ ♠ ♠"
ENT.prizesymbols[7] = "$ $ $"
ENT.prizesymbols[8] = "7 7 7"
ENT.prizesymbols[9] = "? ? ?"
ENT.LastWildChange = SysTime()
ENT.LastCardChange = SysTime()
ENT.WildChangeColor = 1
local colorvars = {"r","g","b","r"}



function ENT:DrawPrizeScreen()
	if !ARCSlots.Settings["money_symbol"] then return end
	surface.SetDrawColor(0,0,0,255)
	surface.DrawRect(0,0,336,258)
	draw.SimpleText( ARCSlots.Msgs.SlotMsgs.BadLuck , "DermaDefault", 336/2,10, Color(128,128,128,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	
	
	draw.SimpleText( "[♪ ♪]"  , "DermaDefault", 10,25, Color(0,0,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	draw.SimpleText( ARCLib.PlaceholderReplace(ARCSlots.Msgs.SlotMsgs.FreeSpins,{AMOUNT=tostring(ARCSlots.SlotPrizes[1])}) , "DermaDefault", 66,25, Color(0,0,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	
	draw.SimpleText( "[♪ ♪ ♪]"  , "DermaDefault", 10,40, Color(0,0,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	draw.SimpleText( ARCLib.PlaceholderReplace(ARCSlots.Msgs.SlotMsgs.FreeSpins,{AMOUNT=tostring(ARCSlots.SlotPrizes[2])}) , "DermaDefault", 66,40, Color(0,0,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	--draw.SimpleText( ARCLib.PlaceholderReplace(ARCSlots.Msgs.SlotMsgs.MaxPrize,{AMOUNT=ARCSlots.Settings["money_symbol"]..tostring(ARCSlots.SlotPrizes[1]*ARCSlots.Settings["slots_max_bet"])}) , "DermaDefault", 130,20 + i * 15, self.prizecolours[i], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	for i=1,4 do
		draw.SimpleText( "["..self.prizesymbols[1][i].."]"  , "DermaDefault", 10,40 + i * 15, self.prizecolours[1][i], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText( ARCSlots.Msgs.SlotMsgs.Bet.." * "..ARCSlots.SlotPrizes[1] , "DermaDefault", 66,40 + i * 15, self.prizecolours[1][i], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText( ARCLib.PlaceholderReplace(ARCSlots.Msgs.SlotMsgs.MaxPrize,{AMOUNT=ARCSlots.Settings["money_symbol"]..tostring(ARCSlots.SlotPrizes[1]*ARCSlots.Settings["slots_max_bet"])}) , "DermaDefault", 170,40 + i * 15, self.prizecolours[1][i], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end
	for i=2,9 do
		draw.SimpleText( "["..self.prizesymbols[i].."]"  , "DermaDefault", 10,85 + i * 15, self.prizecolours[i], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText( ARCSlots.Msgs.SlotMsgs.Bet.." * "..ARCSlots.SlotPrizes[i] , "DermaDefault", 66,85 + i * 15, self.prizecolours[i], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText( ARCLib.PlaceholderReplace(ARCSlots.Msgs.SlotMsgs.MaxPrize,{AMOUNT=ARCSlots.Settings["money_symbol"]..tostring(ARCSlots.SlotPrizes[i]*ARCSlots.Settings["slots_max_bet"])}) , "DermaDefault", 170,85 + i * 15, self.prizecolours[i], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end
	
	draw.SimpleText( ARCSlots.Msgs.SlotMsgs.Wild , "DermaDefault", 336/2,240, self.prizecolours[9], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	
	if SysTime() - self.LastWildChange > 10 then
		self.LastWildChange = SysTime()
	end
	if self.LastWildChange <= SysTime() then
		if self.prizecolours[9][colorvars[self.WildChangeColor]] == 180 then
			if self.prizecolours[9][colorvars[self.WildChangeColor+1]] == 180 then
				self.prizecolours[9][colorvars[self.WildChangeColor]] = 0
				self.WildChangeColor = self.WildChangeColor + 1
				if self.WildChangeColor > 3 then
					self.WildChangeColor = 1
				end
			else
				self.prizecolours[9][colorvars[self.WildChangeColor+1]] = 180
			end
		end

		self.LastWildChange = SysTime() + 0.2
	end
	if self.LastCardChange <= SysTime() then
		self.prizecolours[2] = table.Random(self.prizecolours[1])
		self.prizesymbols[2] = table.Random(cardssym).." "..table.Random(cardssym).." "..table.Random(cardssym)
		self.LastCardChange = SysTime() + 1.5
	end
end

local lastbet = 0
local icons = {}

icons[1] = {}
icons[1].col = {255,255,255,128}
icons[1].x = 0
icons[1].y = 0
icons[1].w = 33
icons[1].h = 33
icons[2] = {}
icons[2].col = {255,255,255,128}
icons[2].x = 38
icons[2].y = 0
icons[2].w = 33
icons[2].h = 33
icons[3] = {}
icons[3].col = {255,255,255,128}
icons[3].x = 76
icons[3].y = 0
icons[3].w = 33
icons[3].h = 33
icons[4] = {}
icons[4].col = {255,255,255,128}
icons[4].x = 0
icons[4].y = 58
icons[4].w = 33
icons[4].h = 33
icons[5] = {}
icons[5].col = {255,255,255,128}
icons[5].x = 38
icons[5].y = 58
icons[5].w = 33
icons[5].h = 33
icons[6] = {}
icons[6].col = {255,255,255,128}
icons[6].x = 77
icons[6].y = 58
icons[6].w = 33
icons[6].h = 33

icons[7] = {}
icons[7].col = {255,255,255,128}
icons[7].x = 183
icons[7].y = 8
icons[7].w = 73
icons[7].h = 73

local selscreen = Vector(17.12,19.3,47.16)
local selscreenAng = Angle(0,180,0)
local usetime = 0
local lightTexture = surface.GetTextureID("sprites/physg_glow1")
function ENT:DrawSelectionScreen()
	local ply = LocalPlayer()
	--surface.SetDrawColor(0,0,0,255)
	--surface.DrawRect(0,0,100,100)
	if LocalPlayer():GetPos():DistToSqr(self:GetPos()) > 5000 then return end
	draw.SimpleText( "||||||||||" , "ARCSlotMachineBack", 105,44, Color(100,0,0,100), TEXT_ALIGN_RIGHT , TEXT_ALIGN_CENTER   )
	draw.SimpleText( ARCSlots.Settings["money_symbol"]..lastbet , "ARCSlotMachine", 105,44, Color(255,0,0,100), TEXT_ALIGN_RIGHT , TEXT_ALIGN_CENTER   )

	if ARCSlots.Settings["legacy_bet_interface"] then return end
	--Ply:KeyReleased(IN_USE)||Ply:KeyDownLast(IN_USE)
	local pos = util.IntersectRayWithPlane( ply:GetShootPos(), ply:GetAimVector(), self:LocalToWorld(selscreen), self:LocalToWorldAngles(selscreenAng):Up() ) 
	if pos then
		--local adjhit = self:WorldToLocal(hit)-self.ATMType.Screen
		pos = WorldToLocal( pos, self:LocalToWorldAngles(selscreenAng), self:LocalToWorld(selscreen), self:LocalToWorldAngles(selscreenAng) ) 
		self.TouchScreenX =  pos.x/0.08
		self.TouchScreenY = pos.y/-0.08
		for i=1,#icons do
			if ARCLib.InBetween(icons[i].x,self.TouchScreenX,icons[i].x+icons[i].w) && ARCLib.InBetween(icons[i].y,self.TouchScreenY,icons[i].y+icons[i].h) then
				surface.SetDrawColor(unpack(icons[i].col))
				surface.DrawRect(icons[i].x,icons[i].y,icons[i].w,icons[i].h)
				if (ply:KeyReleased(IN_USE)||ply:KeyDownLast(IN_USE)) && usetime <= SysTime() then
					self:PressButton(i)
					usetime = SysTime() + 0.2
				end
				break
			end
		end
		if self.Idle && math.sin((CurTime()+(self:EntIndex()/50))*math.pi*2) > 0 then
			surface.SetDrawColor(200,0,0,255)
			surface.SetTexture(lightTexture)
			surface.DrawTexturedRect(402-50,47-26,44+100,28+60)
		end
	end
end

function ENT:PressButton(id)
	if id < 7 then
		self:EmitSound("buttons/lightswitch2.wav")
	end
	if id == 1 then
		lastbet = math.Round(lastbet + ARCSlots.Settings.slots_incr)
	elseif id == 2 then
		lastbet = math.Round(lastbet + ARCSlots.Settings.slots_incr_big)
	elseif id == 3 then
		lastbet = math.huge
	elseif id == 4 then
		lastbet = math.Round(lastbet - ARCSlots.Settings.slots_incr)
	elseif id == 5 then
		lastbet = math.Round(lastbet - ARCSlots.Settings.slots_incr_big)
	elseif id == 6  then
		lastbet = -math.huge
	elseif id == 7 then
		lastbet = math.Clamp(lastbet,ARCSlots.Settings.slots_min_bet,ARCSlots.Settings.slots_max_bet)
		net.Start("ARCSlots_Update")
		net.WriteEntity(self.Entity)
		net.WriteInt(lastbet - (2^31),32)
		net.WriteBit(UseARCBank)
		net.SendToServer()
	end
	lastbet = math.Clamp(lastbet,ARCSlots.Settings.slots_min_bet,ARCSlots.Settings.slots_max_bet)
end

local cardLightTexture = surface.GetTextureID("effects/brightglow_y")
function ENT:Draw()
	self:DrawModel()
	local dist = LocalPlayer():GetPos():DistToSqr(self:GetPos())
	if ARCSlots.Settings["slots_handle"] then
		local x = SysTime() - self.SpinAnimStartTime
		local add = 1 / ((2*(x-0.5))^2+0.05)

		self.SpinnerPos.pos = self:LocalToWorld(Vector(-21,-8,30))
		self.SpinnerPos.angle = self:LocalToWorldAngles(Angle(0,0,-add*3))
		render.Model( self.SpinnerPos ) 
	end
	if dist > 1000000 then return end
	self:DrawShadow( true )
	cam.Start3D2D(self:LocalToWorld(Vector(18.6,8.75,69.2)), self:LocalToWorldAngles(Angle(180,-0.4,-107.6)), 0.1246)
		self:DrawMainScreen()
	cam.End3D2D()
	
	cam.Start3D2D(self:LocalToWorld(Vector(19.8,17.8,101.6)), self:LocalToWorldAngles(Angle(0,180,111)), 0.12)
		self:DrawPrizeScreen()
	cam.End3D2D()
	
	cam.Start3D2D(self:LocalToWorld(selscreen), self:LocalToWorldAngles(selscreenAng), 0.08)
		self:DrawSelectionScreen()
	cam.End3D2D()
	
	render.SetMaterial(self.spriteMaterial)
	if self.GreenCardLight > SysTime() then
		render.DrawSprite(self:LocalToWorld(Vector(-17.75,20.3,48.2)), 2, 2, Color(25,255,25))
	elseif self.RedCardLight > SysTime() then
		render.DrawSprite(self:LocalToWorld(Vector(-18.3,20.3,48.2)), 2, 2, Color(255,25,25))
	elseif dist < 10000 && self.Idle && math.sin((CurTime()+(self:EntIndex()/50)-0.1)*math.pi*2) > 0 then
		if istable(ARCBank) then
			render.DrawSprite(self:LocalToWorld(Vector(-17.2,20.3,48.2)), 2, 2, Color(25,50,255))
		else
			render.DrawSprite(self:LocalToWorld(Vector(-18.3,20.3,48.2)), 2, 2, Color(255,25,25))
		end
	end

	--
	
	--
	
	if self.Status == 1 then
		--if math.sin(CurTime() * 24) > 0 then
			--(math.sin(CurTime()+(2*math.pi/3))/2+0.5)*255
			if self.Winnings[1] == 8 && self.Winnings[2] == 8 && self.Winnings[3] == 8 then
			--(math.sin(CurTime()*4)*32)+48
				render.DrawSprite(self:LocalToWorld(Vector(0,-5,111)), 32, 32, Color((math.sin(CurTime()*6+(2*math.pi/3))/2+0.5)*255,(math.sin(CurTime()*6+(4*math.pi/3))/2+0.5)*255,(math.sin(CurTime()*6)/2+0.5)*255,255))
			else
				render.DrawSprite(self:LocalToWorld(Vector(0,-5,111)), 32, 32, Color(255,32,0,(math.sin(CurTime()*10)/2+0.5)*255))
			end
		--end
	end
end
--ARCLib.Derma_NumberRequest( strTitle, strText, numMin, numMax, numDefault, fnEnter)
function ENT:ReqSpin(UseARCBank)
	--error("Note to self: Remove this")
	if ARCSlots.Settings["legacy_bet_interface"] then
		ARCLib.Derma_NumberRequest( ARCSlots.Settings["name_long"], ARCSlots.Msgs.SlotMsgs.BetMsg, ARCSlots.Settings.slots_min_bet, ARCSlots.Settings.slots_max_bet, math.Clamp(lastbet,ARCSlots.Settings.slots_min_bet,ARCSlots.Settings.slots_max_bet), function(val)
			if !IsValid(self) then return end
			net.Start("ARCSlots_Update")
			net.WriteEntity(self.Entity)
			net.WriteInt(val - (2^31),32)
			net.WriteBit(UseARCBank)
			net.SendToServer()
			lastbet = val
		end)
	else
		if lastbet == 0 then
			lastbet = math.Round((ARCSlots.Settings.slots_min_bet+ARCSlots.Settings.slots_max_bet)/2)
		end
		net.Start("ARCSlots_Update")
		net.WriteEntity(self.Entity)
		net.WriteInt(lastbet - (2^31),32)
		net.WriteBit(UseARCBank)
		net.SendToServer()
	end
end