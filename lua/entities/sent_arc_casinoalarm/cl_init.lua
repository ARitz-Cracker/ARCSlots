-- This file is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

-- WARNING! SPEGETTI CODE THAT I CAN READ PERFECTLY!

include('shared.lua')

local selectsprite = { sprite = "sprites/animglow02", nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = true}
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
local spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)

local doAlarm = false
local lightOn = false
local starttime = SysTime()
local alarmSounds = {}

local function ResetSounds()
	for k,v in pairs(alarmSounds) do
		--v:FadeOut(0.1) 
		v:Stop()
		if !IsValid(Entity(k)) then
			alarmSounds[k] = nil
		end
	end
	if !doAlarm then return end
	timer.Simple(0.01,function()
		for k,v in pairs(alarmSounds) do
			v:Play()
		end
		starttime = SysTime()
		lightOn = true
	end)
end

function ENT:Initialize()
	self:SetRenderBounds( self:OBBMins() * 2, self:OBBMaxs() * 2)
	self.LightModel = {model="models/props/de_nuke/light_red1.mdl",pos=vector_origin,angle=angle_zero}
	self.LightModel.pos = self:LocalToWorld(Vector(0,0,1))
	self.LightModel.angle = self:LocalToWorldAngles(Angle(0,0,1))
	self.PixVis = util.GetPixelVisibleHandle()
	local entin = self:EntIndex()
	if !alarmSounds[entin] then
		alarmSounds[entin] = CreateSound( self, "ambient/alarms/alarm_citizen_loop1.wav", entin ) 
	end
	ResetSounds()
end

net.Receive("arcslots_alarm",function(len)
	doAlarm = tobool(net.ReadBit())
	local len = net.ReadUInt(32)
	local soundreset = false
	for i=1,len do
		local entin = net.ReadUInt(32)
		local ent = Entity(entin)
		if IsValid(ent) then
			alarmSounds[entin] = CreateSound( ent, "ambient/alarms/alarm_citizen_loop1.wav", entin ) 
		end
	end
	ResetSounds()
	if !doAlarm then
		lightOn = false
	end
end)

function ENT:Think()
	if doAlarm then
		if SysTime() - starttime >= 0.75 then
			lightOn = !lightOn
			starttime = starttime + 0.75
		end
	end

	
	
	--if !self:GetPhysicsObject():IsAsleep() then
		self.LightPos = self:LocalToWorld(Vector(-5,-0.9,-21.5))
	
		self.LightModel.pos = self:LocalToWorld(Vector(--[[-14]]-28,-0.9,-10))
		self.LightModel.angle = self:LocalToWorldAngles(Angle(0,-90,0))
	--end
	if !self.PixVis  then
		self.PixVis = util.GetPixelVisibleHandle()
	end	
	if lightOn then
		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			dlight.pos = self.LightPos
			dlight.r = 255
			dlight.g = 25
			dlight.b = 25
			dlight.brightness = 2
			dlight.Decay = 4096
			dlight.Size = 256
			dlight.DieTime = CurTime() + 1
		end
	end
end

function ENT:DrawTranslucent()
	local Visibile	= util.PixelVisible( self.LightPos, 4, self.PixVis )	

	if ( !Visibile || Visibile < 0.1 ) then return end
	
	if lightOn then
		render.SetMaterial( spriteMaterial ) -- Tell render what material we want, in this case the flash from the gravgun
		
		render.DrawSprite( self.LightPos, 32, 32,  Color( 255, 25, 25, 255*Visibile ) ) -- Draw the sprite in the middle of the map, at 16x16 in it's original colour with full alpha.
		render.DrawSprite( self.LightPos, 16, 16,  Color( 255, 96, 96, 255*Visibile ) ) -- Draw the sprite in the middle of the map, at 16x16 in it's original colour with full alpha.
	end
end
function ENT:Draw()

	render.Model( self.LightModel ) 
	


	self:DrawModel()

	

end
