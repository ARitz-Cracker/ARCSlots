-- This shit is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

DEFINE_BASECLASS( "base_anim" )
ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.PrintName		= "ARC Slot Machine"
ENT.Author			= "ARitz Cracker"
ENT.Category 		= "ARC Casino"
ENT.Contact    		= "aritz-rocks@hotmail.com"
ENT.Purpose 		= "Feelin' lucky today?"
ENT.Instructions 	= "Use it."

ENT.Spawnable = true;
ENT.AdminOnly = false
ENT.IsAFuckingATM = true
hook.Add( "PhysgunPickup", "ARCSlots NoPhys", function( ply, ent ) 
	if ent.ARCSlots_MapEntity then return false end 
end)
hook.Add( "CanTool", "ARCSlots NoTool", function( ply, tr, tool  ) 
	if tr.Entity.ARCSlots_MapEntity then return false end 
end)
