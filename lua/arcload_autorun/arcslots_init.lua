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


ARCSlots.Update = "%%UPDATE%%"
ARCSlots.Version = "%%VERSION%%"

NULLFUNC = function(...) end

ARCPHONE_NO_ERROR = 0
ARCPHONE_ERROR_NONE = 0

ARCSlots.Msg("Version: "..ARCSlots.Version)
ARCSlots.Msg("Updated on: "..ARCSlots.Update)
if SERVER then
	AddCSLuaFile() -----------------------------------------
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
else
	net.Receive( "ARCSlots_Msg", function(length)
		local msg = net.ReadString() 
		MsgC(Color(255,255,255,255),"ARCSlots Server: "..tostring(msg).."\n")
	end)
	function ARCSlots.MsgToServer(msg)
		net.Start( "ARCSlots_Msg" )
		net.WriteString( msg )
		net.SendToServer()
	end
end

