-- manager.lua - Vault manager stuffs
-- This file is under copyright, and is bound to the agreement stated in the ELUA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2016 Aritz Beobide-Cardinal All rights reserved.

ARCSlots.Manager = NULL -- Multiple managers will be supported in the future
ARCSlots.ManagerEarnedMoney = {}
ARCSlots.ManagerStartMoney = {}
ARCSlots.ManagerEndTime = 0

function ARCSlots.CanBeManager(ply)
	if !IsValid(ply) or !ply:IsPlayer() then return false end
	local result = false
	for k,v in pairs(ARCSlots.Settings["manager_auth_teams"]) do
		if ply:Team() == _G[v] then
			result = true
			break
		end
	end
	return result
end
function ARCSlots.IsManager(ply)
	return ARCSlots.Manager == ply
end
function ARCSlots.GetManagerEndTime(ply)
	if ARCSlots.Manager == ply then
		return ARCSlots.ManagerEndTime
	end
	return 0
end

function ARCSlots.SetManagerEndTime(ply,tim)
	if ARCSlots.Manager == ply then
		ARCSlots.ManagerEndTime = CurTime() + tim
	end
end

function ARCSlots.ManagerWithdrawFunds(ply,amount)
	ARCSlots.Disk.VaultFunds = ARCSlots.Disk.VaultFunds - amount
	net.Start("arcslots_worth")
	net.WriteDouble(ARCSlots.Disk.CasinoFunds)
	net.WriteDouble(ARCSlots.Disk.VaultFunds)
	net.Broadcast()
	if !ARCSlots.IsManager(ply) then
		ARCSlots.ManagerEarnedMoney[ply:EntIndex()] = ARCSlots.ManagerEarnedMoney[ply:EntIndex()] - amount
	end
end
function ARCSlots.EntitledAmount(ply)
	if !ARCSlots.CanBeManager(ply) then return 0 end
	local i = ply:EntIndex()
	local amount
	if ARCSlots.IsManager(ply) then
		if !ARCSlots.ManagerStartMoney[i] then return 0 end
		amount = ARCSlots.Disk.VaultFunds - ARCSlots.ManagerStartMoney[i]
	else
		amount = ARCSlots.ManagerEarnedMoney[i] or 0
	end
	if amount < 0 then return 0 end
	return amount
end

function ARCSlots.ManagerBegin(ply)
	if !IsValid(ply) then return end
	local i = ply:EntIndex()
	if ARCSlots.IsManager(ply) then
		if ARCSlots.Disk.VaultFunds < ARCSlots.ManagerStartMoney[i] then
			ARCLib.NotifyPlayer(ply,ARCSlots.Msgs.VaultMsgs.Robbed,NOTIFY_ERROR,15,true)
		else
			ARCSlots.SetManagerEndTime(ply,ARCSlots.Settings["manager_auth_time"]*60)
			ARCLib.NotifyPlayer(ply,ARCLib.PlaceholderReplace(ARCSlots.Msgs.VaultMsgs.GettingCash,{TIME=ARCLib.TimeString(ARCSlots.Settings["manager_auth_time"]*60,ARCSlots.Msgs.Time)}),NOTIFY_HINT,6,true)
		end
	else
		ARCSlots.Manager = ply
		if ARCSlots.ManagerEarnedMoney[i] then
			ARCSlots.ManagerStartMoney[i] = ARCSlots.Disk.VaultFunds - ARCSlots.ManagerEarnedMoney[i]
			ARCSlots.ManagerEarnedMoney[i] = nil
		else
			ARCSlots.ManagerStartMoney[i] = ARCSlots.Disk.VaultFunds
		end
		ARCSlots.SetManagerEndTime(ply,ARCSlots.Settings["manager_auth_time"]*60)
		ARCLib.NotifyPlayer(ply,ARCLib.PlaceholderReplace(ARCSlots.Msgs.VaultMsgs.GettingCash,{TIME=ARCLib.TimeString(ARCSlots.Settings["manager_auth_time"]*60,ARCSlots.Msgs.Time)}),NOTIFY_HINT,6,true)
	end
end

function ARCSlots.ManagerEnd(ply)
	ARCSlots.Manager = NULL
	local i = ply:EntIndex()
	if IsValid(ply) then
		if ARCSlots.ManagerStartMoney[i] then
			ARCSlots.ManagerEarnedMoney[i] = ARCSlots.Disk.VaultFunds - ARCSlots.ManagerStartMoney[i]
		end
		ARCSlots.ManagerStartMoney[i] = nil
		ARCLib.NotifyPlayer(ply,ARCSlots.Msgs.VaultMsgs.NotGettingCash,NOTIFY_HINT,6,true)
	end
end
