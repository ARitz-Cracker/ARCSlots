-- GUI for ARitz Cracker Bank (Clientside)
-- This shit is under a Creative Commons Attribution 4.0 International Licence
-- http://creativecommons.org/licenses/by/4.0/
-- You can mess around with it, mod it to your liking, and even redistribute it.
-- However, you must credit me.
if ARCSlots then
	local ARCSlotsGUI = ARCSlotsGUI or {}
	ARCSlotsGUI.SelectedAccountRank = 0
	ARCSlotsGUI.SelectedAccount = ""
	ARCSlotsGUI.Log = ""
	ARCSlotsGUI.LogDownloaded = false
	ARCSlotsGUI.AccountListTab = {}
	net.Receive( "ARCSlots_Admin_SendAccounts", function(length)

	end)
	net.Receive( "ARCSlots_Admin_Send", function(length)

	end)
	net.Receive( "ARCSlots_Admin_GUI", function(length)
		local thing = net.ReadString()
		local tab = net.ReadTable()
		MsgN(thing)
		if thing == "settings" then
			error("Tell aritz that this shouldn't happen, be sure to attach the FULL error reporst")
		elseif thing == "adv_Slot" then
			local MainPanel = vgui.Create( "DFrame" )
			MainPanel:SetSize( 480,400 )
			MainPanel:Center()
			MainPanel:SetTitle( "Slot machine config" )
			MainPanel:SetVisible( true )
			MainPanel:SetDraggable( true )
			MainPanel:ShowCloseButton( true )
			MainPanel:MakePopup()
			PrintTable(tab)
			local chanceinput = {}
			local payoutinput = {}
			local text = {}
			text[0] = "No prize"
			text[1] = "2 of a kind (♥♣♦♠)"
			text[2] = "3 cards (♥♣♦♠)"
			text[3] = "♥ ♥ ♥"
			text[4] = "♣ ♣ ♣"
			text[5] = "♦ ♦ ♦"
			text[6] = "♠ ♠ ♠"
			text[7] = "$ $ $"
			text[8] = "7 7 7"
			text[9] = "? ? ?"
			local percentlbl = {}
			local pflbl = vgui.Create( "DLabel",MainPanel) -- Creates our label
			pflbl:SetText("Income multiplier:")
			pflbl:SetPos( 5, 332)
			pflbl:SetSize(110,30)
			local profitinput = vgui.Create( "DNumberWang",MainPanel)
			profitinput:SetPos( 100, 340)
			profitinput:SetSize( 55, 20 )
			profitinput:SetMinMax( 1.1, 100 )
			profitinput:SetDecimals(2)
			profitinput:SetValue( tab.Profit )
			local SaveButton = vgui.Create( "DButton", MainPanel )
			SaveButton:SetText( "Update settings" )
			SaveButton:SetPos( 10, 370 )
			SaveButton:SetSize( 180, 20 )
			SaveButton.DoClick = function()	
				net.Start("ARCSlots_Admin_GUI")
				net.WriteString("Slot")
				net.WriteTable(tab)
				net.SendToServer()
			end
			local antiinfloop = false
			local function UpdateValues()
				if antiinfloop then return end
				antiinfloop = true
				tab.Profit = profitinput:GetValue()
				
				local total = 0
				local profit = 0
				for i=1,9 do
					tab.Chances[i] = chanceinput[i]:GetValue()
					tab.Prizes[i] = payoutinput[i]:GetValue()
					total = total + tab.Chances[i]
					profit = profit + tab.Chances[i]*tab.Prizes[i]
				end
				tab.Prizes[0] = 0
				payoutinput[0]:SetValue(0)
				
				tab.Chances[0] = profit * 1.5
				chanceinput[0]:SetValue(tab.Chances[0])
				total = total + tab.Chances[0]

				for i=0,9 do
					--MsgN("Prize "..i.."("..ARCSlots.SpecialSettings.Slot.Prizes[i]..")")
					percentlbl[i]:SetText("%"..tostring(tab.Chances[i]/total * 100))
				end
				antiinfloop = false
			end
			profitinput.OnValueChanged = UpdateValues
			for i=0,9 do
				local lbl = vgui.Create( "DLabel",MainPanel) -- Creates our label
				lbl:SetText(text[i])
				lbl:SetPos( 5, 22 + i*30)
				lbl:SetSize(100,30)
				
				local plbl = vgui.Create( "DLabel",MainPanel) -- Creates our label
				plbl:SetText("Prize:")
				plbl:SetPos( 120, 22 + i*30)
				plbl:SetSize(50,30)
				--lbl:Center()
				payoutinput[i] = vgui.Create( "DNumberWang",MainPanel)
				payoutinput[i]:SetPos( 160, 30 + i*30)
				payoutinput[i]:SetSize( 55, 20 )
				payoutinput[i]:SetMinMax( 0, 100000000 )
				payoutinput[i]:SetValue( tab.Prizes[i] )
				payoutinput[i].OnValueChanged = UpdateValues
				
				local clbl = vgui.Create( "DLabel",MainPanel) -- Creates our label
				clbl:SetText("Chances:")
				clbl:SetPos( 235, 22 + i*30)
				clbl:SetSize(50,30)
				--lbl:Center()
				chanceinput[i] = vgui.Create( "DNumberWang",MainPanel)
				chanceinput[i]:SetPos( 300, 30 + i*30)
				chanceinput[i]:SetSize( 55, 20 )
				chanceinput[i]:SetMinMax( 0, 100000000 )
				chanceinput[i]:SetValue( tab.Chances[i] )
				chanceinput[i].OnValueChanged = UpdateValues
				
				percentlbl[i] = vgui.Create( "DLabel",MainPanel) -- Creates our label
				percentlbl[i]:SetText("UPDATE VALUES")
				percentlbl[i]:SetPos( 365, 22 + i*30)
				percentlbl[i]:SetSize(110,30)
			
			end
			--UpdateValues()
		elseif thing == "logs" then
			local MainPanel = vgui.Create( "DFrame" )
			MainPanel:SetSize( 600,575 )
			MainPanel:Center()
			MainPanel:SetTitle( ARCSlots.Msgs.AdminMenu.ServerLogs )
			MainPanel:SetVisible( true )
			MainPanel:SetDraggable( true )
			MainPanel:ShowCloseButton( true )
			MainPanel:MakePopup()
			
			Text = vgui.Create("DTextEntry", MainPanel) // The info text.
			Text:SetPos( 5, 30 ) -- Set the position of the label
			Text:SetSize( 590, 515 )
			Text:SetText("") --  Set the text of the label
			Text:SetMultiline(true)
			Text:SetEnterAllowed(false)
			Text:SetVerticalScrollbarEnabled(true)
			
			LogList= vgui.Create( "DComboBox",MainPanel)
			LogList:SetPos(5,550)
			LogList:SetSize( 590, 20 )
			LogList:SetText( "UNAVAILABLE" )
			
			for i=1,#tab do 
				LogList:AddChoice(tab[i])
			end
			function LogList:OnSelect(index,value,data)
				ARCSlots.AdminLog(value,false,function(data,per)
					if isnumber(data) then
						if data == ARCBANK_ERROR_DOWNLOADING then
							Text:SetText(ARCSlots.Msgs.ATMMsgs.Loading.."(%"..math.Round(per*100)..")")
						else
							Text:SetText(ARCBANK_ERRORSTRINGS[data])
						end
					else
						Text:SetText(data)
					end
				end)
			end
			
		else
			local MainMenu = vgui.Create( "DFrame" )
			MainMenu:SetSize( 200, 150 )
			MainMenu:Center()
			MainMenu:SetTitle( ARCSlots.Settings.name_long )
			MainMenu:SetVisible( true )
			MainMenu:SetDraggable( true )
			MainMenu:ShowCloseButton( true )
			MainMenu:MakePopup()
			local LogButton = vgui.Create( "DButton", MainMenu )
			LogButton:SetText( "// DO NOTHING //" )
			LogButton:SetPos( 10, 30 )
			LogButton:SetSize( 180, 20 )
			LogButton.DoClick = function()
				--RunConsoleCommand( "ARCSlots","admin_gui","logs")
			end
			local SettingsButton = vgui.Create( "DButton", MainMenu )
			SettingsButton:SetText( "Settings" )
			SettingsButton:SetPos( 10, 60 )
			SettingsButton:SetSize( 180, 20 )
			SettingsButton.DoClick = function()	
				ARCLib.AddonConfigMenu("ARCSlots","arcslots")
			end
			local AccountsButton = vgui.Create( "DComboBox", MainMenu )
			AccountsButton:SetText( "Advanced Settings" )
			AccountsButton:SetPos( 10, 90 )
			AccountsButton:SetSize( 180, 20 )
			for i=1,#tab do 
				AccountsButton:AddChoice(tab[i])
			end
			function AccountsButton:OnSelect(index,value,data)
				RunConsoleCommand( "arcslots","admin_gui","adv",value)
				AccountsButton:SetText( "Advanced Settings" )
			end
			
			local CommandButton = vgui.Create( "DButton", MainMenu )
			CommandButton:SetText(ARCSlots.Msgs.AdminMenu.Commands)
			CommandButton:SetPos( 10, 120 )
			CommandButton:SetSize( 180, 20 )
			CommandButton.DoClick = function()		
				local cmdlist = {"slots_save","slots_unsave","slots_respawn","vault_save","vault_unsave"}
				local CommandFrame = vgui.Create( "DFrame" )
				CommandFrame:SetSize( 200*math.ceil(#cmdlist/8), 30+(30*math.Clamp(#cmdlist,0,8)) )
				CommandFrame:Center()
				CommandFrame:SetTitle(ARCSlots.Msgs.AdminMenu.Commands)
				CommandFrame:SetVisible( true )
				CommandFrame:SetDraggable( true )
				CommandFrame:ShowCloseButton( true )
				CommandFrame:MakePopup()
				for i = 0,(#cmdlist-1) do
				
					local LogButton = vgui.Create( "DButton", CommandFrame )
					LogButton:SetText(tostring(ARCSlots.Msgs.Commands[cmdlist[i+1]]))
					LogButton:SetPos( 10+(200*math.floor(i/8)), 30+(30*(i%8)) )
					LogButton:SetSize( 180, 20 )
					LogButton.DoClick = function()
						RunConsoleCommand( "arcslots",cmdlist[i+1])
					end
				end
			end
		
		end
	end)
end


