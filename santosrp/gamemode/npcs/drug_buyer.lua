--[[

	Name: drug_buyer.lua

	For: TalosLife

	By: TalosLife

]]
--
local NPCMeta = {}
NPCMeta.Name = "Drug Dealer"
NPCMeta.UID = "drug_buyer"
NPCMeta.SubText = "Buy and sell drugs here Pussy"
NPCMeta.Model = "models/Humans/Group02/Male_04.mdl"
NPCMeta.RandomSpots = GM.Config.DrugNPCPositions
NPCMeta.MinMoveTime = GM.Config.DrugNPCMoveTime_Min
NPCMeta.MaxMoveTime = GM.Config.DrugNPCMoveTime_Max
NPCMeta.NoSalesTax = true

NPCMeta.Sounds = {
    StartDialog = {"vo/npc/male01/question05.wav", "vo/npc/male01/question07.wav", "vo/npc/male01/question17.wav", "vo/npc/male01/question30.wav"},
    EndDialog = {"vo/npc/male01/littlecorner01.wav", "vo/npc/male01/question02.wav", "vo/npc/male01/question28.wav"}
}

--[itemID] = priceToBuy,
NPCMeta.ItemsForSale = {
    ["Cannabis Seeds (Low Quality)"] = 20,
    ["Cannabis Seeds (Medium Quality)"] = 40,
    ["Cannabis Seeds (High Quality)"] = 80,
    ["Cannabis (Low Quality)"] = 100,
    ["Phenylacetic Acid"] = 35,
    ["Methamphetamine (Low Quality)"] = 190
    ["Cocaine Leaves"] = 200,
}

--[itemID] = priceToSell,
NPCMeta.ItemsCanBuy = {
    ["Cannabis (Low Quality)"] = 100,
    ["Cannabis (Medium Quality)"] = 175,
    ["Cannabis (High Quality)"] = 210,
    ["Moonshine"] = 50,
    ["Methamphetamine (Low Quality)"] = 125,
    ["Methamphetamine (Medium Quality)"] = 325,
    ["Methamphetamine (High Quality)"] = 500
    ["Cocaine (Low Quality)"] = 450,
    ["Cocaine (Medium Quality)"] = 980,
    ["Cocaine (High Quality)"] = 1600,
}

function NPCMeta:OnPlayerTalk(entNPC, pPlayer)
    GAMEMODE.Net:ShowNPCDialog(pPlayer, "drug_buyer")

    if (entNPC.m_intLastSoundTime or 0) < CurTime() then
        local snd, _ = table.Random(self.Sounds.StartDialog)
        entNPC:EmitSound(snd, 54)
        entNPC.m_intLastSoundTime = CurTime() + 2
    end
end

function NPCMeta:OnPlayerEndDialog(pPlayer)
    if not pPlayer:WithinTalkingRange() then return end
    if pPlayer:GetTalkingNPC().UID ~= self.UID then return end

    if (pPlayer.m_entTalkingNPC.m_intLastSoundTime or 0) < CurTime() then
        local snd, _ = table.Random(self.Sounds.EndDialog)
        pPlayer.m_entTalkingNPC:EmitSound(snd, 54)
        pPlayer.m_entTalkingNPC.m_intLastSoundTime = CurTime() + 2
    end

    pPlayer.m_entTalkingNPC = nil
end

if SERVER then
    --RegisterDialogEvents is called when the npc is registered! This is before the gamemode loads so GAMEMODE is not valid yet.
    function NPCMeta:RegisterDialogEvents()
    end

    function NPCMeta:OnSpawn(entNPC)
        local moveNPC

        moveNPC = function()
            timer.Simple(math.random(self.MinMoveTime, self.MaxMoveTime), function()
                if not IsValid(entNPC) then return end
                local pos = table.Random(self.RandomSpots)
                entNPC:SetPos(pos[1])
                entNPC:SetAngles(pos[2])
                moveNPC()
            end)
        end

        moveNPC()
    end
elseif CLIENT then
    NPCMeta.RandomGreetings = {"I've got the best stuff around! Speak to Jacob Santos for Guns", "You selling? I'm looking to re-up.", "Always need to keep moving. The police never let up."}

    function NPCMeta:RegisterDialogEvents()
        GM.Dialog:RegisterDialog("drug_buyer", self.StartDialog, self)
    end

    function NPCMeta:StartDialog()
        GAMEMODE.Dialog:ShowDialog()
        GAMEMODE.Dialog:SetModel(self.Model)
        GAMEMODE.Dialog:SetTitle(self.Name)
        GAMEMODE.Dialog:SetPrompt(table.Random(self.RandomGreetings))

        GAMEMODE.Dialog:AddOption("Show me what you have for sale.", function()
            GAMEMODE.Gui:ShowNPCShopMenu(self.UID)
            GAMEMODE.Dialog:HideDialog()
        end)

        GAMEMODE.Dialog:AddOption("I've got drugs I'd like to sell.", function()
            GAMEMODE.Gui:ShowNPCSellMenu(self.UID)
            GAMEMODE.Dialog:HideDialog()
        end)

        GAMEMODE.Dialog:AddOption("Never mind, I have to go.", function()
            GAMEMODE.Net:SendNPCDialogEvent(self.UID .. "_end_dialog")
            GAMEMODE.Dialog:HideDialog()
        end)
    end
end

GM.NPC:Register(NPCMeta)
