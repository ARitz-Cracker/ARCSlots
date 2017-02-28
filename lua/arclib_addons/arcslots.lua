-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016-2017 Aritz Beobide-Cardinal All rights reserved.

ARCSlots = ARCSlots or {}
function ARCSlots.Msg(msg)
	Msg("ARCSlots: "..tostring(msg).."\n")
	if !ARCSlots then return end
	if ARCSlots.LogFileWritten then
		file.Append(ARCSlots.LogFile, os.date("%d-%m-%Y %H:%M:%S").." > "..tostring(msg).."\r\n")
	end
end
ARCSlots.Msg("Running...\n ____ ____ _ ___ ___     ____ ____ ____ ____ _  _ ____ ____    ____ _    ____ ___ ____ \n |__| |__/ |  |    /     |    |__/ |__| |    |_/  |___ |__/    [__  |    |  |  |  [__  \n |  | |  \\ |  |   /__    |___ |  \\ |  | |___ | \\_ |___ |  \\    ___] |___ |__|  |  ___]\n")
ARCSlots.Msg(table.Random({"tbh script enforcer is kinda shit.","I actually won $$$ legit on default settings once, I felt awesome.","Finally, a god damn update for this...","\"The neglected one\"","LOOSE ALL YOUR MONEY","Oh boy, he's going to cash in on DLC, isn't he?","$$$$$"}))
ARCSlots.Msg("© Copyright 2016-2017 Aritz Beobide-Cardinal (ARitz Cracker) All rights reserved.")


ARCSlots.Update = "February 28th 2017"
ARCSlots.Version = "1.1.1f"

ARCSlots.About = [[      
          *** ARitz Cracker Gambling ***
    © Copyright Aritz Beobide-Cardinal 2015-2016
                All rights reserved.
				
				
If you're having any trouble, please visit:
www.aritzcracker.ca
	
Coding, Models, and Custom textures by:
 *    Aritz Beobide-Cardinal (ARitz Cracker) (STEAM_0:0:18610144)
	
Model Concept/Design
 *    LOT (STEAM_0:1:83890442)

]]

NULLFUNC = function(...) end

ARCSLOTS_NO_ERROR = 0
ARCSLOTS_ERROR_NONE = 0

ARCSlots.Msg("Version: "..ARCSlots.Version)
ARCSlots.Msg("Updated on: "..ARCSlots.Update)
if SERVER then
	resource.AddWorkshop( "251070018" )
	resource.AddFile("resource/fonts/trana___.ttf")
	resource.AddFile("resource/fonts/tranga__.ttf")
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
end

return "ARCSlots","ARCSlots",{"arclib"}
