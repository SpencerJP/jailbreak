-- ####################################################################################
-- ##                                                                                ##
-- ##                                                                                ##
-- ##     CASUAL BANANAS CONFIDENTIAL                                                ##
-- ##                                                                                ##
-- ##     __________________________                                                 ##
-- ##                                                                                ##
-- ##                                                                                ##
-- ##     Copyright 2014 (c) Casual Bananas                                          ##
-- ##     All Rights Reserved.                                                       ##
-- ##                                                                                ##
-- ##     NOTICE:  All information contained herein is, and remains                  ##
-- ##     the property of Casual Bananas. The intellectual and technical             ##
-- ##     concepts contained herein are proprietary to Casual Bananas and may be     ##
-- ##     covered by U.S. and Foreign Patents, patents in process, and are           ##
-- ##     protected by trade secret or copyright law.                                ##
-- ##     Dissemination of this information or reproduction of this material         ##
-- ##     is strictly forbidden unless prior written permission is obtained          ##
-- ##     from Casual Bananas                                                        ##
-- ##                                                                                ##
-- ##     _________________________                                                  ##
-- ##                                                                                ##
-- ##                                                                                ##
-- ##     Casual Bananas is registered with the "Kamer van Koophandel" (Dutch        ##
-- ##     chamber of commerce) in The Netherlands.                                   ##
-- ##                                                                                ##
-- ##     Company (KVK) number     : 59449837                                        ##
-- ##     Email                    : info@casualbananas.com                          ##
-- ##                                                                                ##
-- ##                                                                                ##
-- ####################################################################################
local function claimWarden(p, c, a)
    if not IsValid(p) or p:Team() ~= TEAM_GUARD or JB.State ~= STATE_SETUP or IsValid(JB:GetWarden()) then return end

    if p.wardenRounds and p.wardenRounds >= tonumber(JB.Config.maxWardenRounds) and (CurTime() - JB.RoundStartTime) < 20 then
        p:SendQuickNotification("You have to give others a chance to claim warden.")

        return
    end

    p:AddWardenStatus()

    if not p.wardenRounds then
        p.wardenRounds = 1
    else
        p.wardenRounds = p.wardenRounds + 1
    end

    for _, v in pairs(team.GetPlayers(TEAM_GUARD)) do
        if IsValid(v) and v ~= p and p.wardenRounds then
            p.wardenRounds = 0
        end
    end

    hook.Call("JailBreakClaimWarden", JB.Gamemode, p, p.wardenRounds)
end

JB.Util.addChatCommand("warden", claimWarden)
concommand.Add("jb_claim_warden", claimWarden)

concommand.Add("jb_warden_changecontrol", function(p, c, a)
    if not IsValid(p) or not p.GetWarden or not p:GetWarden() or not IsValid(JB.TRANSMITTER) then return end
    local opt = a[1]
    local val = a[2]

    if not opt or not val then
        --elseif opt == "PVP" then
        --JB.TRANSMITTER:SetJBWarden_PVPDamage(tobool(val));
        --JB:BroadcastNotification("Friendly fire is now "..(tobool(val) and "enabled" or "disabled"));
        return
    elseif opt == "Pickup" then
        JB.TRANSMITTER:SetJBWarden_ItemPickup(tobool(val))
        JB:BroadcastNotification("Item pickup is now " .. (tobool(val) and "enabled" or "disabled"))
    elseif opt == "Teams" then
        JB.TRANSMITTER:SetJBWarden_TeamsEnabled(tobool(val))
        local i = 1

        if tobool(val) then
            for k, v in pairs(team.GetPlayers(TEAM_PRISONER)) do
                if v:Alive() and v:IsValid() then
                    if i % 2 == 0 then
                        v:SetColor(Color(0, 191, 255, 150))
                    else
                        v:SetColor(Color(255, 0, 0, 255))
                    end

                    i = i + 1
                end
            end
        else
            for k, v in pairs(team.GetPlayers(TEAM_PRISONER)) do
                v:SetColor(Color(255, 255, 255))
            end
        end

        JB:BroadcastNotification("Team Colours are now " .. (tobool(val) and "enabled" or "disabled"))
    elseif opt == "ScaleMode" then
        JB.TRANSMITTER:SetJBWarden_ScaleMode(tobool(val))
        JB:BroadcastNotification("Scale mode " .. (tobool(val) and "enabled" or "disabled"))

        if tobool(val) then
            for k, v in pairs(team.GetPlayers(TEAM_PRISONER)) do
                if v:IsValid() then
                    local scale = 0.5
                    v:SetModelScale(0.5, 4)
                    v.OriginalWalkSpeed = v:GetWalkSpeed()
                    v.OriginalRunSpeed = v:GetRunSpeed()
                    v:SetWalkSpeed(v.OriginalWalkSpeed / 2)
                    v:SetRunSpeed(v.OriginalRunSpeed / 2)
                    v.MOREViewOffset = v.MOREViewOffset or v:GetViewOffset()
                    v.MOREViewOffsetDucked = v.MOREViewOffsetDucked or v:GetViewOffsetDucked()
                    v:SetViewOffset(v.MOREViewOffset * scale)
                    v:SetViewOffsetDucked(v.MOREViewOffsetDucked * scale)
                end
            end
        else
            for k, v in pairs(team.GetPlayers(TEAM_PRISONER)) do
                if v:IsValid() then
                    local scale = 1
                    v.MOREViewOffset = v.MOREViewOffset or v:GetViewOffset()
                    v.MOREViewOffsetDucked = v.MOREViewOffsetDucked or v:GetViewOffsetDucked()
                    v:SetViewOffset(v.MOREViewOffset * scale)
                    v:SetViewOffsetDucked(v.MOREViewOffsetDucked * scale)
                    v:SetModelScale(scale, 4)
                    v:SetWalkSpeed(260)
                    v:SetRunSpeed(320)
                end
            end
        end
    end

    hook.Call("JailBreakWardenControlChanged", JB.Gamemode, p, opt, val)
end)

local function spawnProp(p, typ, model)
    local spawned = 0

    for k, v in pairs(ents.GetAll()) do
        if v and IsValid(v) and v.wardenSpawned then
            spawned = spawned + 1
        end
    end

    if spawned > tonumber(JB.Config.maxWardenItems) then
        p:SendQuickNotification("You can not spawn over " .. tostring(JB.Config.maxWardenItems) .. " items.")

        return
    end

    local prop = ents.Create(typ)
    prop:SetAngles(p:GetAngles())
    prop:SetPos(p:EyePos() + p:GetAngles():Forward() * 60)

    if model then
        prop:SetModel(model)
    end

    prop:Spawn()
    prop:Activate()
    prop.wardenSpawned = true
    hook.Call("JailBreakWardenSpawnProp", JB.Gamemode, p, typ, model)
end

concommand.Add("jb_warden_spawn", function(p, c, a)
    if not IsValid(p) or not p.GetWarden or not p:GetWarden() or not tobool(JB.Config.wardenControl) then return end
    local opt = a[1]

    if not opt then
        return
    elseif opt == "Crate" then
        spawnProp(p, "prop_physics_multiplayer", "models/props_junk/wood_crate001a.mdl")
    elseif opt == "Blockade" then
        spawnProp(p, "prop_physics_multiplayer", "models/props_trainstation/TrackSign02.mdl")
    elseif opt == "AmmoBox" then
        spawnProp(p, "jb_ammobox")
    elseif opt == "MedBox" then
        spawnProp(p, "jb_medbox")
    elseif opt == "Chair" then
        spawnProp(p, "prop_physics_multiplayer", "models/props_c17/chair02a.mdl")
    elseif opt == "Watermelon" then
        spawnProp(p, "prop_physics_multiplayer", "models/props_junk/watermelon01.mdl")
    elseif opt == "Ball" then
        spawnProp(p, "prop_physics_multiplayer", "models/xqm/rails/gumball_1.mdl")
    end
end)

concommand.Add("jb_warden_trivia", function(p, c, a)
    if not IsValid(p) or not p.GetWarden or not p:GetWarden() or not tobool(JB.Config.wardenControl) then return end
    if p.nextTrivia then return end
    local opt = a[1]

    if not opt then
        return
    elseif opt == "trivia" then
        local subject = JB.randomQuestions[math.random(1, (#JB.randomQuestions - 1))]
        local rnd = table.Random(subject)
        question = rnd.question -- TODO: add more questions
        answer = rnd.answer
        PrintMessage(HUD_PRINTTALK, rnd.question)
        p:PrintMessage(HUD_PRINTTALK, "The secret answer is: " .. rnd.answer .. ". Only you have been told this!")
        p.nextTrivia = true

        timer.Simple(10, function()
            p.nextTrivia = false
        end)
    end
end)

local pointerRemove = -1

concommand.Add("jb_warden_placepointer", function(p, c, a)
    if not IsValid(p) or not p.GetWarden or not p:GetWarden() then return end
    local typ = tostring(a[1])
    if not typ then return end
    local pos = p:GetEyeTrace().HitPos
    JB:DebugPrint("Warden " .. p:Nick() .. " has placed a marker at " .. tostring(pos))
    JB:BroadcastQuickNotification("The warden has placed a marker")
    pointerRemove = CurTime() + 120
    JB.TRANSMITTER:SetJBWarden_PointerPos(pos)
    JB.TRANSMITTER:SetJBWarden_PointerType(typ)
    hook.Call("JailBreakWardenPlacePointer", JB.Gamemode, p, typ, pos)
end)

hook.Add("Think", "JB.Think.PointerTimeout", function()
    if CurTime() > pointerRemove and pointerRemove ~= -1 then
        JB.TRANSMITTER:SetJBWarden_PointerType("0")
    end
end)