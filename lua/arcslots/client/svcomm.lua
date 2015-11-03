--comm
ARCSlots.CasinoFunds = math.huge
ARCSlots.VaultFunds = math.huge
net.Receive("arcslots_worth",function(len)
	ARCSlots.CasinoFunds = net.ReadDouble()
	ARCSlots.VaultFunds = net.ReadDouble()
end)
ARCSlots.SlotPrizes = {}
for i=1,9 do
	ARCSlots.SlotPrizes[i] = 1
end
net.Receive("arcslots_prizes",function(len)
	for i=1,9 do
		ARCSlots.SlotPrizes[i] = net.ReadUInt(32)
	end
end)
ARCSlots.Settings = {}