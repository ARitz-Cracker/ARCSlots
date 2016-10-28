-- This file is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.


include('shared.lua')
--[[
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
]]
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
	self.UseDelay = CurTime()
	self.buttonpos = {}
	
	--Special thanks to swep construction kit
	local selectsprite = { sprite = "sprites/blueflare1", nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = true}
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

function ENT:Screen_Text()
	local halfres = math.Round(self.ATMType.Resolutionx*0.5)
	for i=1,26 do
		if self.Texts[i] && self.Texts[i] != "" then
			draw.SimpleText( self.Texts[i], "ARCBankATMConsole",-halfres, -154 + i*12, Color(255,255,255,255), TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM  )
		end
	end
end
function ENT:DrawIdle()
	local logintext = "vault login: "
	
	local textend = 2
	if self.Fakehack <= CurTime() && !self.Hacked then
		self.Texts[1] = "RockOS 0.0.2 vault.arcslots.gmod tty1"
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
	self:Screen_Text()
end

function ENT:DrawHack()
	if (self.SparkTime > SysTime()) then
		self:Screen_Text()
	else
		draw.SimpleText( "Unlocking vault...", "ARCBankATMConsole",0,-10, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
		draw.SimpleText( "|"..string.rep( "#", math.floor(self.Percent*24) )..string.rep( "-", 24 - math.floor(self.Percent*24) ).."|", "ARCBankATMConsole",0,14, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
	end
end
function ENT:Screen_Loading()
	draw.SimpleText( "Loading... Please wait", "ARCBankATMConsole",0,-10, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
	local str = string.rep( "-", 24 )
	local xpox = math.Round((math.tan(CurTime()*1.25)*4.5)+12)
	if xpox > 0 && xpox < 25 then
		str = string.SetChar(str,xpox,"#")
	end
	draw.SimpleText( "|"..str.."|", "ARCBankATMConsole",0,14, Color(255,255,255,255), TEXT_ALIGN_CENTER , TEXT_ALIGN_BOTTOM  )
end

ENT.Page = 0
function ENT:Screen_Options()
	local halfres = math.Round(self.ATMType.Resolutionx*0.5)
	for i = 1,8 do
		if self.ScreenOptions[i+(self.Page*8)] then
			local xpos = 0
			if i%2 == 0 then
				xpos = -halfres
			else
				xpos = halfres-1
			end
			local ypos = -82+((math.floor((i-1)/2))*61)
			local fitstr = ARCLib.FitText(self.ScreenOptions[i+(self.Page*8)].text,"ARCBankATMConsole",halfres-20)
			for ii = 1,#fitstr do
				draw.SimpleText( fitstr[ii], "ARCBankATMConsole",xpos, ypos+(ii*12), Color(255,255,255,255), (i%2)*2 , TEXT_ALIGN_TOP  )
			end
		end
	end
	--[[
	surface.SetDrawColor( 0, 0, 0, 255 )
	for i = 0,7 do
		surface.DrawOutlinedRect( -137+(ARCLib.BoolToNumber(i>3)*140), -80+((i%4)*61), 134, 40)
	end
	]]
end
function ENT:PushCancel()
	if self.InputtingNumber then
		self.InputtingNumber = false
		return
	end
	self.Status = 0
	net.Start("arcslots_vault_signin")
	net.WriteEntity(self)
	net.WriteBool(false)
	net.SendToServer()
end
function ENT:PushScreen(butt)
	if self.InputtingNumber then
		self:EmitSoundTable(self.ATMType.PressNoSound,65)
		return
	end
	if self.ScreenOptions[butt+(self.Page*8)] && type(self.ScreenOptions[butt+(self.Page*8)].func) == "function" then
		self.ScreenOptions[butt+(self.Page*8)].func()
		self:EmitSoundTable(self.ATMType.ClientPressSound)
		ARCLib.PlaySoundOnOtherPlayers(table.Random(self.ATMType.PressSound),self,65)
	else
		self:EmitSoundTable(self.ATMType.PressNoSound,65)
	end
end

function ENT:UpdateList()
	self.Page = 0
	if table.maxn(self.ScreenOptions) < 8 then
		self.ScreenOptions[8] = {}
		self.ScreenOptions[8].text = ARCSlots.Msgs.VaultMsgs.Exit
		
		self.ScreenOptions[8].func = function()
			if !IsValid(self) then return end
			self:PushCancel()
		end
	else
		local i = 1
		
		local doublebackcmd = {}
		doublebackcmd.text = ARCSlots.Msgs.VaultMsgs.Exit
		doublebackcmd.func = function()
			if !IsValid(self) then return end
			self:PushCancel()
		end
		
		local nextcmd = {}
		nextcmd.text = ARCBank.Msgs.ATMMsgs.More --eh why not. The vault needs ARCBank to work anyway
		nextcmd.func = function() 
			self.Page = self.Page + 1
		end
		local backcmd = {}
		backcmd.text = ARCBank.Msgs.ATMMsgs.Back
		backcmd.func = function() 
			self.Page = self.Page - 1
		end
		table.insert(self.ScreenOptions, 7, nextcmd ) 
		table.insert(self.ScreenOptions, 8, doublebackcmd ) 
		while i <= (math.ceil(#self.ScreenOptions/8)-1) do -- Eh, for some reason I just feel safer doing this in a while loop
			if self.ScreenOptions[8+(i*8)] then
				table.insert(self.ScreenOptions, 7+(i*8), nextcmd ) 
			end
			table.insert(self.ScreenOptions, 8+(i*8), backcmd ) 
			i = i + 1
		end
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
	
	if self.BEEP && self.ATMType.UseMoneylight then
		cam.Start3D2D(self:LocalToWorld(self.ATMType.Moneylight), self:LocalToWorldAngles(self.ATMType.MoneylightAng), self.ATMType.MoneylightSize)
			surface.SetDrawColor(ARCLib.ConvertColor(self.ATMType.MoneylightColour))
			if self.ATMType.MoneylightFill then
				surface.DrawRect(0,0,self.ATMType.MoneylightHeight,self.ATMType.MoneylightWidth)
			else
				surface.DrawOutlinedRect(0,0,self.ATMType.MoneylightHeight,self.ATMType.MoneylightWidth)
			end
		cam.End3D2D()
	end
	local ply = LocalPlayer()
	cam.Start3D2D(self.DisplayPos, self.displayangle1, 0.043)
		if self:GetNWEntity("UsePlayer") == ply then
			if self.Status == 0 then
				self:Screen_Loading()
			else
				if self.Status == -1 then
					self.Texts[1] = "RockOS 0.0.2 vault.arcslots.gmod tty1"
					self.Texts[2] = "vault login: "
					self.Texts[3] = "Authenticating with ATM Card..."
					for i=4,26 do
						self.Texts[i] = ""
					end
				elseif self.Status == 1 then
					local entitlement
					if (self.EndTime > CurTime()) then
						entitlement = ARCLib.PlaceholderReplace(ARCSlots.Msgs.VaultMsgs.GettingCash,{TIME=ARCLib.TimeString(self.EndTime-CurTime(),ARCSlots.Msgs.Time)})
					else
						entitlement = ARCSlots.Msgs.VaultMsgs.NotGettingCash.."\n\n"..ARCSlots.Msgs.VaultMsgs.PleaseCheckIn
					end
					self.Texts = table.Copy(ARCLib.FitText("** ARitz Cracker Gambling Vault 1.1 **\n"..entitlement.."\n\n"..ARCLib.PlaceholderReplace(ARCSlots.Msgs.VaultMsgs.WithdrawAmount,{AMOUNT=ARCSlots.Settings["money_symbol"]..string.Comma(self.Entitlement)}),"ARCBankATMConsole",self.ATMType.Resolutionx)) --aaah I don't like this
				end
				self:Screen_Text()
				if self.Status > 0 then
					self:Screen_Options()
				end
			end
		elseif self.Hacked then
			self:DrawHack()
		else
			self:DrawIdle()
		end
	cam.End3D2D()
	
	self.buttonpos[1] = self:LocalToWorld(self.ATMType.buttons[1])
	self.buttonpos[2] = self:LocalToWorld(self.ATMType.buttons[2])
	self.buttonpos[3] = self:LocalToWorld(self.ATMType.buttons[3])
	self.buttonpos[12] = self:LocalToWorld(self.ATMType.buttons[12])
	self.buttonpos[4] = self:LocalToWorld(self.ATMType.buttons[4])
	self.buttonpos[5] = self:LocalToWorld(self.ATMType.buttons[5])
	self.buttonpos[6] = self:LocalToWorld(self.ATMType.buttons[6])
	self.buttonpos[11] = self:LocalToWorld(self.ATMType.buttons[11])
	self.buttonpos[7] = self:LocalToWorld(self.ATMType.buttons[7])
	self.buttonpos[8] = self:LocalToWorld(self.ATMType.buttons[8])
	self.buttonpos[9] = self:LocalToWorld(self.ATMType.buttons[9])
	self.buttonpos[23] = self:LocalToWorld(self.ATMType.buttons[23])
	
	self.buttonpos[21] = self:LocalToWorld(self.ATMType.buttons[21])
	self.buttonpos[0] = self:LocalToWorld(self.ATMType.buttons[0])
	self.buttonpos[22] = self:LocalToWorld(self.ATMType.buttons[22])
	self.buttonpos[10] = self:LocalToWorld(self.ATMType.buttons[10])
	
	self.buttonpos[13] = self:LocalToWorld(self.ATMType.buttons[13])
	self.buttonpos[14] = self:LocalToWorld(self.ATMType.buttons[14])
	self.buttonpos[15] = self:LocalToWorld(self.ATMType.buttons[15])
	self.buttonpos[16] = self:LocalToWorld(self.ATMType.buttons[16])
	self.buttonpos[17] = self:LocalToWorld(self.ATMType.buttons[17])
	self.buttonpos[18] = self:LocalToWorld(self.ATMType.buttons[18])
	self.buttonpos[19] = self:LocalToWorld(self.ATMType.buttons[19])
	self.buttonpos[20] = self:LocalToWorld(self.ATMType.buttons[20])
	
	if ply != self:GetNWEntity("UsePlayer") then return end
	render.SetMaterial(self.spriteMaterial)
	self.Dist = math.huge
	self.Highlightbutton = -1
	self.CurPos = ply:GetEyeTrace().HitPos
	for i=0,23 do
		if self.buttonpos[i] then
			--[[
			if LocalPlayer().ARCBank_FullScreen then
				local butscrpos = self.buttonpos[i]:ToScreen()
				if Vector(butscrpos.x,butscrpos.y,0):IsEqualTol( Vector(gui.MouseX(),gui.MouseY(),0), surface.ScreenHeight()/20  ) then
					if Vector(butscrpos.x,butscrpos.y,0):DistToSqr(Vector(gui.MouseX(),gui.MouseY(),0)) < self.Dist then
						self.Dist = Vector(butscrpos.x,butscrpos.y,0):DistToSqr(Vector(gui.MouseX(),gui.MouseY(),0))
						self.Highlightbutton = i
					end
				end
			else
			]]
				if self.buttonpos[i]:IsEqualTol(self.CurPos,1.6) then
					if self.buttonpos[i]:DistToSqr(self.CurPos) < self.Dist then
						self.Dist = self.buttonpos[i]:DistToSqr(self.CurPos)
						self.Highlightbutton = i
					end
				end
			--end
		end
	end
	if self.Highlightbutton >= 0 && ply:GetShootPos():Distance(self.CurPos) < 70 then
		if !self.ATMType.UseTouchScreen then
			render.DrawSprite(self.buttonpos[self.Highlightbutton], 6.5, 6.5, Color(255,255,255,255))
		end
		local pushedbutton
		--if ply.ARCBank_FullScreen then
			--pushedbutton = input.IsMouseDown(MOUSE_LEFT)
		--else
			pushedbutton = --[[ply:KeyDown(IN_USE)||]]ply:KeyReleased(IN_USE)||ply:KeyDownLast(IN_USE)
		--end
		if self.UseDelay <= CurTime() && self.Status > 0 then
			if pushedbutton then
				--ARCBank.MsgToServer("PLAYER USED ATM - "..tostring(self.Highlightbutton))
				self.UseDelay = CurTime() + 0.3
				if self.Highlightbutton <= 9 then
					self:PushNumber(self.Highlightbutton)
				elseif self.Highlightbutton == 10 then
					self:EmitSoundTable(self.ATMType.ClientPressSound)
					ARCLib.PlaySoundOnOtherPlayers(table.Random(self.ATMType.PressSound),self,65)
					self:PushEnter()
				elseif self.Highlightbutton == 11 then
					self:PushClear()
				elseif self.Highlightbutton == 12 then
					self:EmitSoundTable(self.ATMType.ClientPressSound)
					ARCLib.PlaySoundOnOtherPlayers(table.Random(self.ATMType.PressSound),self,65)
					self:PushCancel()
				elseif self.Highlightbutton <= 20 then
					self:PushScreen(self.Highlightbutton-12)
				else
					self:PushDev(self.Highlightbutton-20)
				end
			end
		end
	end
end

function ENT:PushEnter()

end
function ENT:PushClear()
	self:EmitSoundTable(self.ATMType.PressNoSound,65)
end
function ENT:PushNumber(num)
	self:EmitSoundTable(self.ATMType.PressNoSound,65)
end
function ENT:PushDev(num)
	self:EmitSoundTable(self.ATMType.PressNoSound,65)
end
net.Receive("arcslots_vault_signin",function(msglen)
	local ent = net.ReadEntity()
	ent.Entitlement = net.ReadUInt(32) 
	ent.EndTime = net.ReadDouble()
	ent.ScreenOptions = {}
	ent.ScreenOptions[3] = {text=ARCSlots.Msgs.VaultMsgs.WithdrawCash,func=function()
		ent.Status = 0
		net.Start("arcslots_vaultwithdraw")
		net.WriteEntity(ent)
		net.WriteBool(false)
		net.WriteUInt(ent.Entitlement,32)
		net.SendToServer()
	end}
	ent.ScreenOptions[4] = {text=ARCSlots.Msgs.VaultMsgs.WithdrawBank,func=function()
		ent.Status = 0
		ARCBank.GroupList(ARCBank.GetPlayerID(LocalPlayer()),ent,function(data,progress,ent)
			if !IsValid(ent) then return end
			if isnumber(data) then
				if data > 0 then
					notification.AddLegacy( "ARCBank: "..ARCBANK_ERRORSTRINGS[data], NOTIFY_ERROR, 6 ) 
					ent:PushCancel()
				end
			else
				ent.Texts = table.Copy(ARCLib.FitText("** ARitz Cracker Gambling Vault 1.1 **\n"..ARCSlots.Msgs.VaultMsgs.WhichAccount,"ARCBankATMConsole",ent.ATMType.Resolutionx))
				ent.ScreenOptions = {}
				ent.ScreenOptions[1] = {}
				ent.ScreenOptions[1].text = ARCBank.Msgs.ATMMsgs.PersonalAccount
				ent.ScreenOptions[1].func = function()
					ent.Status = 0
					net.Start("arcslots_vaultwithdraw")
					net.WriteEntity(ent)
					net.WriteBool(true)
					net.WriteUInt(ent.Entitlement,32)
					net.WriteString("")
					net.SendToServer()
				end
				for ii = 1,#data do
					ent.ScreenOptions[ii+1] = {}
					ent.ScreenOptions[ii+1].text = data[ii]
					ent.ScreenOptions[ii+1].func = function()
						ent.Status = 0
						net.Start("arcslots_vaultwithdraw")
						net.WriteEntity(ent)
						net.WriteBool(true)
						net.WriteUInt(ent.Entitlement,32)
						net.WriteString(data[ii])
						net.SendToServer()
					end
				end
				ent:UpdateList()
				ent.Status = 2
			end
		end)
	end}
	ent.ScreenOptions[7] = {text=ARCSlots.Msgs.VaultMsgs.CheckIn,func=function()
		if !IsValid(ent) then return end
		--ent.Status = 0
		net.Start("arcslots_vault_signin")
		net.WriteEntity(ent)
		net.WriteBool(true)
		net.SendToServer()
	end}
	ent:UpdateList()
	timer.Simple(1.5,function()
		if !IsValid(ent) then return end
		ent.Status = 0
	end)
	timer.Simple(5,function()
		if !IsValid(ent) then return end
		ent.Status = 1
	end)
	ent.Status = -1
end)
