-- This shit is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

-- WARNING! SPEGETTI CODE THAT I CAN READ PERFECTLY!

include('shared.lua')
net.Receive("arcslots_casino_vault_anim",function(len)
	local ent = net.ReadEntity()
	local open = tobool(net.ReadBit())
	local time = net.ReadDouble()
	local oldtime = ent.AnimEndTime - CurTime()
	if oldtime < 0 then oldtime = 0 end
	ent.Open = open
	ent.AnimStartTime = CurTime() - oldtime
	ent.AnimEndTime = CurTime() + time 
end)

function ENT:Initialize()
	self.Planes = {}
	self.Planes[1] = {{normal=Vector(1,0,0),dist = 13.25}}
	self.Planes[2] = {{normal=Vector(-1,0,0),dist = -13.25},{normal=Vector(0,0,-1),dist = -96}}
	self.Planes[3] = {{normal=Vector(-1,0,0),dist = -13.25},{normal=Vector(0,0,1),dist = 30}}
	self.Planes[4] = {{normal=Vector(-1,0,0),dist = -13.25},{normal=Vector(0,0,1),dist = 96},{normal=Vector(0,0,-1),dist = -30},{normal=Vector(0,1,0),dist = 0}}
	self.MoneyPos = {}
	self.MoneyTabs = {}
	for i=1,105 do
		self.MoneyPos[i] = Vector(9,(i-1)%11*4 +3,32 + math.floor((i-1)/11))
		self.MoneyTabs[i] = {model="models/props/cs_assault/money.mdl",angle=self:GetAngles(),pos=self:LocalToWorld(self.MoneyPos[i])}
	end
	
	self.DoorModel = {model=self:GetModel(),angle=self:GetAngles(),pos=self:GetPos()}
	self.Doorplanes = {{normal=Vector(-1,0,0),dist = -13.25},{normal=Vector(0,0,1),dist = 96},{normal=Vector(0,0,-1),dist = -30},{normal=Vector(0,-1,0),dist = 0}}
	self.RotateAng = 0
	self.AnimStartTime =0
	self.Open = false
	self.AnimEndTime = 1
end

function ENT:Think()
	if self.Open then
		
		self.RotateAng = ARCLib.BetweenNumberScale(self.AnimStartTime,CurTime(),self.AnimEndTime)*95
	else
		self.RotateAng = 95 - ARCLib.BetweenNumberScale(self.AnimStartTime,CurTime(),self.AnimEndTime)*95
	end
end

function ENT:OnRestore()

end

function ENT:DrawMask()
	local sizex = 44.45
	local sizey = 32.2
	self.BasePos = self:LocalToWorld(Vector(13.05,23.25,63.75));
	
	local up = self:GetUp();
	local right = self:GetRight();

	local segments = 4;

	render.SetColorMaterial();

	mesh.Begin( MATERIAL_POLYGON, segments );

	--[[]]
	for i = 0, segments-1 do
		--[
		local rot = math.pi * 2 * ( i / segments ) + math.pi/4;
		local sin = math.sin( rot ) * sizex;
		local cos = math.cos( rot ) * sizey;
		--]]
		--local sin = i%2 * size;
		--local cos = (i+1)%2 * size;
		mesh.Position( self.BasePos + ( up * sin ) + ( right * cos ) );
		--MsgN(self:WorldToLocal(self.BasePos + ( up * sin ) + ( right * cos ) ))
		mesh.AdvanceVertex();

	end

	mesh.End();

end


function ENT:DrawInterior()
	for i=1,math.Clamp(math.floor(ARCSlots.VaultFunds/50),0,105) do
		self.MoneyTabs[i].pos = self:LocalToWorld(self.MoneyPos[i])
		self.MoneyTabs[i].angle = self:GetAngles()
		render.Model( self.MoneyTabs[i] ) 
	end
end
	

function ENT:DrawOverlay()
	--render.Model( {model="models/props/cs_assault/money.mdl",ang=self:GetAngles(),pos=self.MoneyPos} ) 
end

function ENT:DrawBaseModel()
	for i=1,4 do
		self:DrawClip(self.Planes[i])
	end
end

function ENT:DrawClip(planes)
	if ( !planes ) then
		return
	end
	
	render.EnableClipping( true )
	
	for _, plane in pairs( planes ) do
		local normal	= self:LocalToWorldAngles( plane.normal:Angle() ):Forward()
		local point		= self:GetPos() + normal * plane.dist
		
		render.PushCustomClipPlane( -normal, -point:Dot(normal) )
	end
	
	-- Render the model 'inside out'
	--render.CullMode(MATERIAL_CULLMODE_CW)
	--	self:DrawModel()	
	--render.CullMode(MATERIAL_CULLMODE_CCW)
	
	self:DrawModel()
	
	for index = 1, #planes do
		render.PopCustomClipPlane()
	end
	
	render.EnableClipping( false )
end


function ENT:DrawDoor()
	
	local planes = self.Doorplanes
	local model = self.DoorModel
	local mul = math.sin(CurTime())*0.5 + 0.5

	local rotatepos = self:LocalToWorld(Vector(13,46,0))
	local rotateang = self:LocalToWorldAngles(Angle(0,self.RotateAng,0))

	
	local pos,ang = LocalToWorld( Vector(-13.000000, -46.000000, 0.000000), angle_zero, rotatepos, rotateang ) 
	
	model.pos = pos
	model.angle = ang
	render.EnableClipping( true )
	
	for _, plane in pairs( planes ) do
		local wpos,wang = LocalToWorld( vector_origin, plane.normal:Angle(), model.pos, model.angle )
		local normal	= wang:Forward()
		local point		= model.pos + normal * plane.dist
		
		render.PushCustomClipPlane( -normal, -point:Dot(normal) )
	end
	
	-- Render the model 'inside out'
	render.CullMode(MATERIAL_CULLMODE_CW)
		render.Model( model )

	render.CullMode(MATERIAL_CULLMODE_CCW)
	
	render.Model( model )
	
	for index = 1, #planes do
		render.PopCustomClipPlane()
	end
	
	render.EnableClipping( false )
	

end

function ENT:Draw()

	if self.RotateAng <= 0 then
		self:DrawModel()
	else
		self:DrawBaseModel()
		self:DrawDoor()
		--self:DrawBottomModel()
		render.SetStencilWriteMask( 255 )
		render.SetStencilTestMask( 255 )
		render.ClearStencil();

		render.SetStencilEnable( true );

		
		render.SetStencilCompareFunction( STENCIL_ALWAYS );
		render.SetStencilPassOperation( STENCIL_REPLACE );
		render.SetStencilFailOperation( STENCIL_KEEP );
		render.SetStencilZFailOperation( STENCIL_KEEP );
		render.SetStencilWriteMask( 1 );
		render.SetStencilTestMask( 1 );
		render.SetStencilReferenceValue( 1 );

		self:DrawMask();

		render.SetStencilCompareFunction( STENCIL_EQUAL );

		-- clear the inside of our mask so we have a nice clean slate to draw in.
		render.ClearBuffersObeyStencil( 0, 0, 0, 0, true );

		self:DrawInterior();

		render.SetStencilEnable( false );

		self:DrawOverlay();
	end
end