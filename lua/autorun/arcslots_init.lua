-- This shit is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2014 Aritz Beobide-Cardinal All rights reserved.

--ENUMS FOR ARC BANKING SYSTEM!
--137164355
ARCSlots = ARCSlots or {}
function ARCSlots.Msg(msg)
	Msg("ARCSlots: "..tostring(msg).."\n")
	if !ARCSlots then return end
	if ARCSlots.LogFileWritten then
		file.Append(ARCSlots.LogFile, os.date("%d-%m-%Y %H:%M:%S").." > "..tostring(msg).."\r\n")
	end
end
ARCSlots.Msg("Running...\n ____ ____ _ ___ ___     ____ ____ ____ ____ _  _ ____ ____    ____ _    ____ ___ ____ \n |__| |__/ |  |    /     |    |__/ |__| |    |_/  |___ |__/    [__  |    |  |  |  [__  \n |  | |  \\ |  |   /__    |___ |  \\ |  | |___ | \\_ |___ |  \\    ___] |___ |__|  |  ___]\n")
ARCSlots.Msg(table.Random({"Finally, a god damn update for this...","\"The neglected one\"","LOOSE ALL YOUR MONEY","Oh boy, he's going to cash in on DLC, isn't he?","$$$$$"}))
ARCSlots.Msg("© Copyright 2015 Aritz Beobide-Cardinal (ARitz Cracker) All rights reserved.")


ARCSlots.Update = "September 21st 2015"
ARCSlots.Version = "0.1.0"

NULLFUNC = function(...) end

ARCPHONE_NO_ERROR = 0
ARCPHONE_ERROR_NONE = 0

ARCSlots.Msg("Version: "..ARCSlots.Version)
ARCSlots.Msg("Updated on: "..ARCSlots.Update)
if SERVER then
	AddCSLuaFile() -----------------------------------------
	ARCSlots.Msg("####    Loading ARCSlots Lua files..     ####")
	local sharedfiles, _ = file.Find( "arcslots/shared/*.lua", "LUA" )
	for i, v in ipairs( sharedfiles ) do
		ARCSlots.Msg("#### Loading: /arcslots/shared/"..v)
		AddCSLuaFile( "arcslots/shared/"..v )
		include( "arcslots/shared/"..v )
	end
	local serverfiles, _ = file.Find( "arcslots/server/*.lua", "LUA" )
	for i, v in ipairs( serverfiles ) do
		ARCSlots.Msg("#### Loading: /arcslots/server/"..v)
		include( "arcslots/server/"..v )
	end
	local clientfiles, _ = file.Find( "arcslots/client/*.lua", "LUA" )
	for i, v in ipairs( clientfiles ) do
		ARCSlots.Msg("#### Sending: /arcslots/client/"..v)
		AddCSLuaFile( "arcslots/client/"..v )
		--include( "arcslots/client/"..v )
	end
	ARCSlots.Msg("####     Loading ARCSlots Plugins...     ####")
	local sharedfiles, _ = file.Find( "arcslots_plugins/shared/*.lua", "LUA" )
	for i, v in ipairs( sharedfiles ) do
		ARCSlots.Msg("#### Loading: /arcslots_plugins/shared/"..v)
		AddCSLuaFile( "arcslots_plugins/shared/"..v )
		include( "arcslots/shared/"..v )
	end
	local serverfiles, _ = file.Find( "arcslots_plugins/server/*.lua", "LUA" )
	for i, v in ipairs( serverfiles ) do
		ARCSlots.Msg("#### Loading: /arcslots_plugins/server/"..v)
		include( "arcslots_plugins/server/"..v )
	end
	
	local clientfiles, _ = file.Find( "arcslots_plugins/client/*.lua", "LUA" )
	for i, v in ipairs( clientfiles ) do
		ARCSlots.Msg("#### Sending: /arcslots_plugins/client/"..v)
		AddCSLuaFile( "arcslots_plugins/client/"..v )
		--include( "arcslots/client/"..v )
	end
	
	util.AddNetworkString( "ARCSlots_Msg" )
	function ARCSlots.MsgCL(ply,msg)
		--net.Start( "ARCSlots_Msg" )
		--net.WriteString( msg )
		if !ply || !ply:IsPlayer() then
			ARCSlots.Msg(tostring(msg))
		else
			ply:PrintMessage( HUD_PRINTTALK, "ARCSlots: "..tostring(msg))
			--net.Send(ply)
		end
	end
	net.Receive( "ARCSlots_Msg", function(length,ply)
		local msg = net.ReadString() 
		MsgN("ARCSlots - "..ply:Nick().." ("..ply:SteamID().."): "..msg)
	end)
	ARCSlots.Msg("####  Serverside Lua Loading Complete.  ####")
else
	ARCSlots.Msg("####     Loading Clientside Files..     ####")
	local sharedfiles, _ = file.Find( "arcslots/shared/*.lua", "LUA" )
	for i, v in pairs( sharedfiles ) do
		ARCSlots.Msg("#### Loading: /arcslots/shared/"..v)
		include( "arcslots/shared/"..v )
	end
	local clientfiles, _ = file.Find( "arcslots/client/*.lua", "LUA" )
	for i, v in pairs( clientfiles ) do
		ARCSlots.Msg("#### Loading: /arcslots/client/"..v)
		include( "arcslots/client/"..v )
	end
	ARCSlots.Msg("####    Loading Clientside Plugins..    ####")
	local sharedfiles, _ = file.Find( "arcslots_plugins/shared/*.lua", "LUA" )
	for i, v in pairs( sharedfiles ) do
		ARCSlots.Msg("#### Loading: /arcslots_plugins/shared/"..v)
		include( "arcslots_plugins/shared/"..v )
	end
	local clientfiles, _ = file.Find( "arcslots_plugins/client/*.lua", "LUA" )
	for i, v in pairs( clientfiles ) do
		ARCSlots.Msg("#### Loading: /arcslots_plugins/client/"..v)
		include( "arcslots_plugins/client/"..v )
	end
	net.Receive( "ARCSlots_Msg", function(length)
		local msg = net.ReadString() 
		MsgC(Color(255,255,255,255),"ARCSlots Server: "..tostring(msg).."\n")
	end)
	function ARCSlots.MsgToServer(msg)
		net.Start( "ARCSlots_Msg" )
		net.WriteString( msg )
		net.SendToServer()
	end
	
	ARCSlots.Msg("####  Clientside Lua Loading Complete.  ####")
end

