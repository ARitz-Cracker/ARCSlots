-- aacore.lua - Main stuffs

-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2015 Aritz Beobide-Cardinal All rights reserved.

ARCSlots.LogFileWritten = false
ARCSlots.LogFile = ""
ARCSlots.Loaded = false
ARCSlots.Busy = true
ARCSlots.Dir = "_arcslots"

ARCSlots.SpecialSettings = {}

ARCSlots.Disk = {}
ARCSlots.Disk.ProperShutdown = false
ARCSlots.Disk.CasinoFunds = 0
ARCSlots.Disk.VaultFunds = 0
	
function ARCSlots.FuckIdiotPlayer(ply,reason)
	ARCSlots.Msg("ARCSLOTS ANTI-CHEAT WARNING: Some stupid shit by the name of "..ply:Nick().." ("..ply:SteamID()..") tried to use an exploit: ["..tostring(reason).."]")
	if ply.ARCSlots_AFuckingIdiot then
		ply:Ban(ARCSlots.Settings["autoban_time"])
		ply:SendLua("Derma_Message( \"You will be autobanned for "..ARCLib.TimeString( ARCSlots.Settings["autoban_time"]*60 )..".\", \"You're a failure at hacking\", \"Shit, Looks like I'm an idiot.\" )")
		timer.Simple(10,function()
			if IsValid(ply) && ply:IsPlayer() then 
				ply:Kick("ARCSlots Autobanned for "..ARCLib.TimeString( ARCSlots.Settings["autoban_time"]*60 ).." - Tried to be a L33T H4X0R ["..tostring(reason).."]") 
			end
		end)
	else
		ARCSlots.MsgCL(ply,table.Random({"I fucking swear, you better not try that again.","It's people like you that make my life harder.","I'LL BAN YO' FUCKIN' ASS IF YOU TRY THAT MUTHAFUKIN SHIT AGAIN!","Seriously? Do you really think you can get away with that?"}))
		ply.ARCSlots_AFuckingIdiot = true
	end
end

function ARCSlots.SaveDisk()
	ARCSlots.Disk.ProperShutdown = true
	file.Write(ARCSlots.Dir.."/__data.txt", util.TableToJSON(ARCSlots.Disk) )
end

function ARCSlots.RawARCBankAddMoney(ply,amount,groupaccount,reason,callback)
	ARCBank.AddMoney(ply,amount,groupaccount,reason,function(err)
		if err == 0 then
			callback(true)
		else
			ARCLib.NotifyPlayer(ply,"ARCBank: "..ARCBANK_ERRORSTRINGS[err],NOTIFY_ERROR,6,true)
			callback(false)
		end
	end)
end

function ARCSlots.ChangeFunds(amount)
	ARCSlots.Disk.CasinoFunds = math.Round(ARCSlots.Disk.CasinoFunds - amount)
	ARCSlots.Disk.VaultFunds = math.floor(ARCSlots.Disk.VaultFunds - amount*0.25)
end

function ARCSlots.ARCBankAddMoney(ply,amount,groupaccount,reason,callback)
	ARCSlots.RawARCBankAddMoney(ply,amount,groupaccount,reason,function(worked)
		if worked then
			ARCSlots.ChangeFunds(-amount)
			net.Start("arcslots_worth")
			net.WriteDouble(ARCSlots.Disk.CasinoFunds)
			net.WriteDouble(ARCSlots.Disk.VaultFunds)
			net.Broadcast()
		end
		callback(worked)
	end)
end

function ARCSlots.PlayerAddMoney(ply,amount)
	ARCSlots.RawPlayerAddMoney(ply,amount)
	ARCSlots.ChangeFunds(-amount)
	net.Start("arcslots_worth")
	net.WriteDouble(ARCSlots.Disk.CasinoFunds)
	net.WriteDouble(ARCSlots.Disk.VaultFunds)
	net.Broadcast()
end
	
function ARCSlots.PlayerCanAfford(ply,amount)
	if ARCBank then
		return ARCBank.PlayerCanAfford(ply,amount)
	end
	if string.lower(GAMEMODE.Name) == "gmod day-z" then
		return ply:HasItemAmount("item_money", amount)
	elseif string.lower(GAMEMODE.Name) == "underdone - rpg" then
		return ply:HasItem("money", amount)
	elseif ply.canAfford then -- DarkRP 2.5+
		return ply:canAfford(amount)
	elseif ply.CanAfford then -- DarkRP 2.4
		return ply:CanAfford(amount)
	else
		return true
	end
end
function ARCSlots.CustomSlotPrize(ply,bet,prize)
	return true
end

function ARCSlots.Load()
	ARCSlots.Loaded = false
	if #player.GetAll() == 0 then
		ARCSlots.Msg("A player must be online before continuing...")
	end
	timer.Simple(1,function()

		ARCSlots.Msg("Post-loading ARCSlots...")
		if game.SinglePlayer() then
			ARCSlots.Msg("CRITICAL ERROR! THIS IS A SINGLE PLAYER GAME!")
			ARCSlots.Msg("LOADING FALIURE!")
			return
		end
		if !file.IsDir( ARCSlots.Dir,"DATA" ) then
			ARCSlots.Msg("Created Folder: "..ARCSlots.Dir)
			file.CreateDir(ARCSlots.Dir)
		end
		
		if !file.IsDir( ARCSlots.Dir,"DATA" ) then
			ARCSlots.Msg("CRITICAL ERROR! FAILED TO CREATE ROOT FOLDER!")
			ARCSlots.Msg("LOADING FALIURE!")
			return
		end
		if !file.IsDir( ARCSlots.Dir.."/saved_atms","DATA" ) then
			ARCSlots.Msg("Created Folder: "..ARCSlots.Dir.."/saved_atms")
			file.CreateDir(ARCSlots.Dir.."/saved_atms")
		end
		if !file.IsDir( ARCSlots.Dir.."/saved_vault","DATA" ) then
			ARCSlots.Msg("Created Folder: "..ARCSlots.Dir.."/saved_vault")
			file.CreateDir(ARCSlots.Dir.."/saved_vault")
		end
		if file.Exists(ARCSlots.Dir.."/__data.txt","DATA") then
			ARCSlots.Disk = util.JSONToTable(file.Read( ARCSlots.Dir.."/__data.txt","DATA" ))
			if (!ARCSlots.Disk) then
				ARCSlots.Msg("__data.txt is corrupt.")
				ARCSlots.Disk = {}
				ARCSlots.Disk.ProperShutdown = false
				ARCSlots.Disk.CasinoFunds = 0
				ARCSlots.Disk.VaultFunds = 0
			end
		end
		if ARCSlots.Disk.ProperShutdown then
			ARCSlots.Disk.ProperShutdown = false
		else
			ARCSlots.Msg("WARNING! THE SYSTEM DIDN'T SHUT DOWN PROPERLY!")
		end
		ARCLib.LoadDefaultLanguages("ARCSlots","https://raw.githubusercontent.com/ARitz-Cracker/aritzcracker-addon-translations/master/default_arcslots_languages.json",function(langChoices)
			ARCLib.AddonAddSettingMultichoice("ARCSlots","language",langChoices)
			ARCLib.AddonLoadSettings("ARCSlots")
			ARCLib.AddonLoadSpecialSettings("ARCSlots")
			ARCLib.SetAddonLanguage("ARCSlots")
			
			ARCSlots.SpecialSettings.Slot.Prizes[0] = 0
			local profit = 0
			for i=1,9 do
				profit = profit + ARCSlots.SpecialSettings.Slot.Chances[i]*ARCSlots.SpecialSettings.Slot.Prizes[i]
			end
			ARCSlots.SpecialSettings.Slot.Chances[0] = profit * ARCSlots.SpecialSettings.Slot.Profit
			
			ARCSlots.LogFile = os.date(ARCSlots.Dir.."/systemlog - %d %b %Y - "..tostring(os.date("%H")*60+os.date("%M"))..".log.txt")
			file.Write(ARCSlots.LogFile,"***ARCSlots System Log***\r\n"..table.Random({"Oh my god. You're reading this!","WINDOWS LOVES TYPEWRITER COMMANTS IN TXT FILES","What you're refeering to as 'Linux' is in fact GNU/Linux.","... did you mess something up this time?"}).."\r\nDates are in DD-MM-YYYY\r\n")
			ARCSlots.LogFileWritten = true
			ARCSlots.Msg("Log File Created at "..ARCSlots.LogFile)
			timer.Create( "ARCSLOTS_SAVEDISK", 300, 0, function() 
				
				file.Write(ARCSlots.Dir.."/__data.txt", util.TableToJSON(ARCSlots.Disk) )
			end )
			timer.Start( "ARCSLOTS_SAVEDISK" ) 
			ARCSlots.SpawnSlotMachines()
			ARCSlots.SpawnVault()
			
			
			ARCSlots.Msg("ARCSlots is ready!")
			ARCSlots.Loaded = true
			ARCSlots.Busy = false
		end)
	end)
end


