-- hooks.lua - Player utilities

-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2015-2016 Aritz Beobide-Cardinal All rights reserved.

function ARCSlots.RawPlayerAddMoney(ply,amount)
	if ARCBank then
		ARCBank.PlayerAddMoney(ply,amount)
		return
	end
	if (nut) then
		if amount > 0 then
			ply:getChar():giveMoney(amount)
		else
			amount = amount * -1
			ply:getChar():takeMoney(amount)
		end
	elseif string.lower(GAMEMODE.Name) == "gmod day-z" then
		if amount > 0 then
			ply:GiveItem("item_money", amount)
		else
			amount = amount * -1
			ply:TakeItem("item_money", amount)
		end
	elseif string.lower(GAMEMODE.Name) == "underdone - rpg" then
		if amount > 0 then
			ply:AddItem("money", amount)
		else
			amount = amount * -1
			ply:RemoveItem("money", amount)
		end
	elseif ply.addMoney then -- DarkRP 2.5+
		ply:addMoney(amount)
	elseif ply.AddMoney then -- DarkRP 2.4
		ply:AddMoney(amount)
	else
		ply:SendLua("notification.AddLegacy( \"I'm going to pretend that your wallet is unlimited because this is an unsupported gamemode.\", 0, 5 )")
	end
end
