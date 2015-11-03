
--[[
ARitz Cracker: ??? = 100,000 * bet
ARitz Cracker: 777 = 10,000 * bet
ARitz Cracker: $$$ = 1,000 * bet
ARitz Cracker: 3 Spades = 300 * bet
ARitz Cracker: 3 Diamonds = 150 * bet
ARitz Cracker: 3 Clubs = 100 * bet
ARitz Cracker: 3 Hearts = 50 * bet
ARitz Cracker: All cards = 5 * bet (50% free spins)
ARitz Cracker: 2 cards = 2* bet (50% free spins)

]]
ARCSlots.SpecialSettings.Slot = {}
ARCSlots.SpecialSettings.Slot.Profit = 1.5

ARCSlots.SpecialSettings.Slot.Prizes = {}
ARCSlots.SpecialSettings.Slot.Prizes[0] = 0
ARCSlots.SpecialSettings.Slot.Prizes[1] = 2
ARCSlots.SpecialSettings.Slot.Prizes[2] = 5
ARCSlots.SpecialSettings.Slot.Prizes[3] = 25
ARCSlots.SpecialSettings.Slot.Prizes[4] = 50
ARCSlots.SpecialSettings.Slot.Prizes[5] = 75
ARCSlots.SpecialSettings.Slot.Prizes[6] = 100
ARCSlots.SpecialSettings.Slot.Prizes[7] = 200
ARCSlots.SpecialSettings.Slot.Prizes[8] = 500
ARCSlots.SpecialSettings.Slot.Prizes[9] = 1000

ARCSlots.SpecialSettings.Slot.Chances = {}
--ARCSlots.SpecialSettings.Slot.Chances[0] = 0
ARCSlots.SpecialSettings.Slot.Chances[1] = 100000
ARCSlots.SpecialSettings.Slot.Chances[2] = 5000
ARCSlots.SpecialSettings.Slot.Chances[3] = 2000
ARCSlots.SpecialSettings.Slot.Chances[4] = 1500
ARCSlots.SpecialSettings.Slot.Chances[5] = 1000
ARCSlots.SpecialSettings.Slot.Chances[6] = 500
ARCSlots.SpecialSettings.Slot.Chances[7] = 100
ARCSlots.SpecialSettings.Slot.Chances[8] = 50
ARCSlots.SpecialSettings.Slot.Chances[9] = 5

--[[
local total = 0
local profit = 0
for i=1,9 do
	total = total + ARCSlots.SpecialSettings.Slot.Chances[i]
	profit = profit + ARCSlots.SpecialSettings.Slot.Chances[i]*ARCSlots.SpecialSettings.Slot.Prizes[i]
end
ARCSlots.SpecialSettings.Slot.Chances[0] = profit * 1.5
total = total + ARCSlots.SpecialSettings.Slot.Chances[0]

for i=0,9 do
	MsgN("Prize "..i.."("..ARCSlots.SpecialSettings.Slot.Prizes[i]..")")
	local prob = ARCSlots.SpecialSettings.Slot.Chances[i]/total
	MsgN("%"..(prob * 100))
	MsgN("1 in "..(1/prob))
end
]]

local OVERRIDE = false

function ARCSlots.SlotPrizeselector()
	if OVERRIDE then
		return 7
	end
	local total = 0
	for i=0,9 do
		total = total + ARCSlots.SpecialSettings.Slot.Chances[i]
	end
	local prize = 0
	local rnd = math.random(1,total)
	for i=0,9 do
		prize = prize + ARCSlots.SpecialSettings.Slot.Chances[i]
		if rnd <= prize then
			return i
		end
	end
end

-- 2 of a kind: <= 5

--Cards: 2,3,4,5

function ARCSlots.SlotLooseIcon()
	local icon1 = math.random(0,8)
	if icon1 == 0 then
		return icon1,math.random(0,8),math.random(0,8)
	end
	local icon2 = math.random(0,8)
	if icon2 == 0 then
		return icon1,icon2,math.random(0,8)
	elseif ((icon2 == icon1 && (icon2 <= 5 || icon2==8)) || ((icon1==8||icon2==8) && (icon1<=5||icon2<=5))) then
		return icon1,icon2,0 -- 2 of a kind, this can result in a prize, WHICH WE DO NOT WANT!
	elseif (icon1 <= 5 || icon1 == 8) || (icon2 <= 5 || icon2 == 8) then --Eliminates possibility of getting 2 of a kind on the last icon
		if math.random(1,4) == 1 then
			return icon1,icon2,0
		else
			if icon1 > 5 && icon2 > 5 then
				return icon1,icon2,ARCLib.RandomExclude(6,7,icon1,icon2)
			else
				return icon1,icon2,math.random(6,7)
			end
		end
	elseif icon1 == icon2 then
		return icon1,icon2,ARCLib.RandomExclude(0,7,icon1)
	end
	return icon1,icon2,math.random(0,8)
end
local noncardicons = {1,6,7}
function ARCSlots.Slot2OfKindIcon(icon)
	assert(isnumber(icon))
	local icon2
	local icon1
	local rnd = math.random(1,6)
	local iconrand
	if rnd == 1 then
		icon2 = 8
		icon1 = icon
		iconrand = math.random(6,7)
	elseif rnd == 2 then
		icon2 = icon
		icon1 = 8
		iconrand = math.random(6,7)
	else
		icon1 = icon
		icon2 = icon
		if ARCLib.InBetween(2,icon,5) then
			iconrand = noncardicons[math.random(1,3)]
		else
			iconrand = math.random(2,7)
		end
	end
	
	rnd = math.random(1,3)
	if rnd == 1 then
		return icon1,icon2,iconrand
	elseif rnd == 2 then
		return icon1,iconrand,icon2
	elseif rnd == 3 then
		return iconrand,icon1,icon2
	end
end

function ARCSlots.AllCardsIcon()
	local tab = {math.random(2,5),math.random(2,5),math.random(2,5)}
	if tab[1] != tab[2] && tab[3] != tab[2] && math.random(1,6) == 1 then
		tab[math.random(1,3)] = 8
	end
	return unpack(tab)
end

function ARCSlots.Slot3OfKindIcon(icon)
	if icon == 8 then return 8,8,8 end
	local tab = {icon,icon,icon}
	if math.random(1,6) == 1 then
		tab[math.random(1,3)] = 8
		if math.random(1,2) == 1 then
			tab[math.random(1,3)] = 8
		end
	end
	return unpack(tab)
end

function ARCSlots.SlotPrizePayout()
	local prize = ARCSlots.SlotPrizeselector()
	local tab = {"SOMETING WENT HORRIBLY WRONG"}
	if prize == 0 then
		tab = {ARCSlots.SlotLooseIcon()}
		tab[4] = 0
		tab[5] = 0
	elseif prize == 1 then
		if tobool(math.Round(math.random())) then
			tab = {ARCSlots.Slot2OfKindIcon(1)}
			tab[4] = ARCSlots.SpecialSettings.Slot.Prizes[prize]*-1
			tab[5] = 1
			
		else
			local winicon = math.random(2,5)
			tab = {ARCSlots.Slot2OfKindIcon(winicon)}
			tab[4] = ARCSlots.SpecialSettings.Slot.Prizes[prize]
			tab[5] = winicon
			
		end
	elseif prize == 2 then
		if tobool(math.Round(math.random())) then
			tab = {ARCSlots.Slot3OfKindIcon(1)}
			tab[4] = ARCSlots.SpecialSettings.Slot.Prizes[prize]*-1
			tab[5] = 1
			
		else
			tab = {ARCSlots.AllCardsIcon()}
			tab[4] = ARCSlots.SpecialSettings.Slot.Prizes[prize]
			tab[5] = 9
			
		end
	else
		tab = {ARCSlots.Slot3OfKindIcon(prize-1)}
		tab[4] = ARCSlots.SpecialSettings.Slot.Prizes[prize]
		tab[5] = prize-1
	end
	--PrintTable(tab)
	return unpack(tab)
end