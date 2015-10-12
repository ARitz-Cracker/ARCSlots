--comm
ARCSlots.CasinoFunds = math.huge
ARCSlots.VaultFunds = math.huge
net.Receive("arcslots_worth",function(len)
	ARCSlots.CasinoFunds = net.ReadDouble()
	ARCSlots.VaultFunds = net.ReadDouble()

end)
ARCSlots.Settings = {}