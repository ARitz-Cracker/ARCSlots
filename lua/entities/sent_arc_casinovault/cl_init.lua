-- This shit is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

-- WARNING! SPEGETTI CODE THAT I CAN READ PERFECTLY!

include('shared.lua')
net.Receive("arcslots_casino_vault_anim",function(len)
	local ent = net.ReadEntity()
	local open = tobool(net.ReadBit())
	local time = net.ReadDouble()
	if !IsValid(ent) then return end
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
	self.InsidePos = {}
	self.InsideAngs = {}
	self.InsideTabs = {}
	
	self.InsidePos[1] = Vector(-10.6,23.25,29)
	self.InsideAngs[1] = Angle(0,0,0)
	self.InsideTabs[1] = {model = "models/props_phx/construct/metal_plate1.mdl"}
	
	self.InsidePos[2] = Vector(-10.6,23.25,95)
	self.InsideAngs[2] = Angle(0,0,0)
	self.InsideTabs[2] = {model = "models/props_phx/construct/metal_plate1.mdl"}

	
	self.InsidePos[3] = Vector(-10.6,0.5,79.7)
	self.InsideAngs[3] = Angle(0,0,90)
	self.InsideTabs[3] = {model = "models/props_phx/construct/metal_plate1x2.mdl"}
	
	self.InsidePos[4] = Vector(-10.6,23.25,79.3)
	self.InsideAngs[4] = Angle(0,0,0)
	self.InsideTabs[4] = {model = "models/props_phx/construct/metal_plate1.mdl"}
	
	self.InsidePos[5] = Vector(-10.6,49.5,79.7)
	self.InsideAngs[5] = Angle(0,0,90)
	self.InsideTabs[5] = {model = "models/props_phx/construct/metal_plate1x2.mdl"}
	
	
	self.InsidePos[6] = Vector(-14,23.25,79.7)
	self.InsideAngs[6] = Angle(0,90,90)
	self.InsideTabs[6] = {model = "models/props_phx/construct/metal_plate1x2.mdl"}
	
	self.InsidePos[7] = Vector(-10,-0.47,43)
	self.InsideAngs[7] = Angle(0,0,0)
	self.InsideTabs[7] = {model = "models/PHXtended/bar1x.mdl"}
	self.InsidePos[8] = Vector(-4,-0.47,43)
	self.InsideAngs[8] = Angle(0,0,0)
	self.InsideTabs[8] = {model = "models/PHXtended/bar1x.mdl"}
	self.InsidePos[9] = Vector(2,-0.47,43)
	self.InsideAngs[9] = Angle(0,0,0)
	self.InsideTabs[9] = {model = "models/PHXtended/bar1x.mdl"}
	
	self.InsidePos[10] = Vector(-10,-0.47,59.6)
	self.InsideAngs[10] = Angle(0,0,0)
	self.InsideTabs[10] = {model = "models/PHXtended/bar1x.mdl"}
	self.InsidePos[11] = Vector(-4,-0.47,59.6)
	self.InsideAngs[11] = Angle(0,0,0)
	self.InsideTabs[11] = {model = "models/PHXtended/bar1x.mdl"}
	self.InsidePos[12] = Vector(2,-0.47,59.6)
	self.InsideAngs[12] = Angle(0,0,0)
	self.InsideTabs[12] = {model = "models/PHXtended/bar1x.mdl"}
	
	for i=1,396 do
		local j = i-1
		local perrow = (math.floor(j/6))
		local up1row = perrow %11
		local up1rowmove = (math.floor(perrow/11))
		local moveyup = math.floor(up1rowmove/2) * 16.7
		
		local xpos = up1row * 4
		self.MoneyPos[i] = Vector(-6 + up1rowmove%2 *10,3 + xpos,32.1 + (j%6)*0.8 + moveyup)
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
	for i=1,#self.InsideTabs do
		self.InsideTabs[i].pos = self:LocalToWorld(self.InsidePos[i])
		self.InsideTabs[i].angle = self:LocalToWorldAngles(self.InsideAngs[i])
		render.Model( self.InsideTabs[i] ) 
	end
	
	

	
	for i=1,math.Clamp(math.floor(ARCSlots.VaultFunds/ARCSlots.Settings["vault_steal_rate"]),0,396) do
		self.MoneyTabs[i].pos = self:LocalToWorld(self.MoneyPos[i])
		self.MoneyTabs[i].angle = self:GetAngles()
		render.Model( self.MoneyTabs[i] ) 
	end
	
	
end
	

function ENT:DrawOverlay()

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

		--self:DrawOverlay();
	end
end