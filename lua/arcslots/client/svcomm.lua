--comm
ARCSlots.CasinoFunds = "-----"
ARCSlots.VaultFunds = "-----"
net.Receive("arcslots_worth",function(len)
	ARCSlots.CasinoFunds = net.ReadDouble()
	ARCSlots.VaultFunds = net.ReadDouble()

end)