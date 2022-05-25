local orb = module.internal("orb")
local evade = module.seek("evade")
local preds = module.internal("pred")
local ts = module.internal("TS")
local common = module.load(header.id, "common2")
-- local crashreporter = module.load(header.id, 'crashreporter')
if player.charName ~= "Nidalee" then
    print("not using Nidalee not loading")
    return
end

local menu = menu("trent_nidaleexd", "Trent Nidalee")
menu:menu("keys", "Key Settings")
menu.keys:keybind("flee", "flee/kite to mouse", "T", false)

menu:menu("combo", "Combo Settings")
menu.combo:header("Human", "Human Settings")
menu.combo:boolean("Q", "Use Q", true)
menu.combo:boolean("W", "Use W", true)
menu.combo:header("Cougar", "Cougar Settings")
menu.combo:boolean("QC", "Use Q", true)
menu.combo:boolean("WC", "Use W", true)
menu.combo:boolean("EC", "Use E", true)
menu.combo:boolean("RC", "Use R", true)

menu:menu("harass", "Harass Settings")
menu.harass:header("Human", "Human Settings")
menu.harass:boolean("Q", "Use Q", true)
menu.harass:slider("Mana", "Min. Mana Percent: ", 10, 0, 100, 10)

menu:menu("farm", "Farm Settings")
menu.farm:header("Human", "Human Settings")
menu.farm:boolean("Q", "Use Q", true)
menu.farm:boolean("W", "Use W", true)
menu.farm:header("Cougar", "Cougar Settings")
menu.farm:boolean("QC", "Use Q", true)
menu.farm:boolean("WC", "Use W", true)
menu.farm:boolean("EC", "Use E", true)
menu.farm:boolean("autoR", "Auto Swap Forms", true)
menu.farm:slider("Mana", "Min. Mana Percent: ", 40, 10, 100, 5)

menu:menu("heal", "Heal Settings")
menu.heal:header("info1", "Self Heal")
menu.heal:boolean("useSelf", "Use E to Heal", true)
menu.heal:slider("healthSelf", "Health Limit %", 40, 10, 100, 5)
menu.heal:slider("Mana1", "Min. Mana Percent: ", 40, 10, 100, 5)
menu.heal:header("info2", "Ally Heal")
menu.heal:boolean("useAlly", "Use E to Heal", true)
menu.heal:slider("healthAlly", "Health Limit %", 40, 10, 100, 5)
menu.heal:slider("Mana2", "Min. Mana Percent: ", 40, 10, 100, 5)
menu.heal:boolean("autoR", "Auto Swap Forms", true)

menu:menu("ks", "Killsteal Settings")
menu.ks:boolean("Q", "KS With Spear", true)

menu:menu("draws", "Draw Settings")
menu.draws:header("Human", "Human Draws")
menu.draws:boolean("Q", "Draw Q Range", true)
menu.draws:boolean("W", "Draw W Range", true)
menu.draws:boolean("E", "Draw E Range", true)
menu.draws:header("Cougar", "Cougar Draws")
menu.draws:boolean("QC", "Draw Q Range", true)
menu.draws:boolean("WC", "Draw W Range", true)
menu.draws:boolean("EC", "Draw E Range", true)

local qPred = {
    delay = 0.25,
    width = 40,
    speed = 1300,
    range = 1500,
    boundingRadiusMod = 1,
    collision = {hero = true, minion = true, wall = true}
}

local wPred = {
    delay = 0.25,
    width = 45,
    radius = 40,
    speed = 1300,
    boundingRadiusMod = 1,
    collision = {hero = true, minion = true, wall = false}
}

local qRange = 1500
local wRange = 900

local function TargetSelection(res, obj, dist)
    if dist <= 1500 then
        res.obj = obj
        return true
    end
end

local function GetTarget() return ts.get_result(TargetSelection).obj end

local trace_filter = function(input, segment, target)
    if segment.startPos:dist(segment.endPos) > qPred.range then return false end -- Checking before spellcast to see if our projected segment end is out of range if not return
    if preds.trace.linear.hardlock(input, segment, target) then return true end -- checking cc status if so send it no real pred needed
    if preds.trace.linear.hardlockmove(input, segment, target) then -- checking cc status if so send it no real pred needed
        return true
    end
    if preds.trace.newpath(target, 0.05445, 1.0) then return true end -- Kiri path strictness :omegalul:
end

local function qpred()
    local target = GetTarget()
    if common.IsValidTarget(target) then
        local pos = preds.linear.get_prediction(qPred, target)
        if pos and pos.startPos:dist(pos.endPos) <= qPred.range then
            if not preds.collision.get_prediction(qPred, pos, target) then
                if not trace_filter(qPred, pos, target) then
                    return
                end

                player:castSpell("pos", 0,
                                 vec3(pos.endPos.x, mousePos.y, pos.endPos.y))
            end
        end
    end
end

local function isHuman() return player:spellSlot(0).name == "JavelinToss" end

local function isHunted(unit)
    return common.CheckBuff(unit, "NidaleePassiveHunted")
end

local function GetQDmg(unit, pos)
    if player:spellSlot(0).level < 1 or not unit or unit.isDead or
        not unit.isVisible or not unit.isTargetable then return 0 end
    local d = pos and player.path.serverPos:dist(pos) or
                  player.path.serverPos:dist(unit.path.serverPos)
    local pctIncrease = 1
    if d >= 622 then
        if d >= 1300 then
            pctIncrease = 3
        else
            local hold = (d - 525) / 96.875
            pctIncrease = ({1.25, 1.5, 1.75, 2, 2.25, 2.5, 2.75, 3})[math.floor(
                              hold)]
        end
    end
    local damage = (({70, 85, 100, 115, 130})[player:spellSlot(0).level] +
                       (0.4 * common.GetTotalAP())) * pctIncrease
    return common.CalculateMagicDamage(unit, damage)
end

local function FleeKiteLogic()
    player:move(game.mousePos)
    local target = GetTarget()
    if target then
        local dist = player.path.serverPos:dist(target.path.serverPos)
        if isHuman() then
            if player:spellSlot(0).state == 0 and common.IsValidTarget(target) and
                dist < 1500 then
                qpred()
                print("Used Q")
            else
                if player:spellSlot(0).state ~= 0 and player:spellSlot(3).state ==
                    0 then
                    player:castSpell("self", 3)
                    print("Used R to Cougar")
                end
            end
        end
    end

    if not isHuman() then
        if player:spellSlot(0).name ~= "JavelinToss" and
            player:spellSlot(3).state == 0 then
            player:castSpell("self", 3)
            print("Used R to Human")
        else
            if player:spellSlot(1).name == "Pounce" and
                player:spellSlot(1).state == 0 then
                local jumpPos =
                    player.pos + (game.mousePos - player.pos):norm() * 400
                player:castSpell("pos", 1, jumpPos)
                print("Jump")
            end
        end
    end
end

--[[local function FleeKiteLogic()
    player:move(game.mousePos)
    local target = GetTarget()
    if target then
        local dist = player.path.serverPos:dist(target.path.serverPos)
        local Qlevel = player:spellSlot(0).level
        if isHuman() then
            if player:spellSlot(0).state == 0 and common.IsValidTarget(target) and dist < 1500 then
                player:castSpell("pos", 0, target.pos)
            elseif
                (player:spellSlot(0).state ~= 0 or not common.IsValidTarget(target) or
                    (common.IsValidTarget(target) and dist >= 1500)) and
                    player:spellSlot(3).state == 0
             then
                player:castSpell("self", 3)
                print('casting 3')
            end
            if not isHuman() then
                if
                    player:spellSlot(0).state == 0 and player:spellSlot(0).name == "JavelinToss" and
                        player:spellSlot(3).state == 0
                 then
                    if common.IsValidTarget(target) and dist < 1500 then
                        player:castSpell("self", 3)
                        print("Casting R")
                    --end
                elseif
                    player:spellSlot(0).state ~= 0 or player:spellSlot(0).name ~= "JavelinToss" or
                        not common.IsValidTarget(target) or
                        (common.IsvalidTarget(target) and dist > 1500)
                 then
                    print("Jumping")
                    player:castSpell("pos", 1, game.MousePos)
                    print("done")
                end
            end
        end
    end
end--]]

local function GetWHuman(target)
    if target ~= 0 then
        local Damage = 0
        local DamageAP = {40, 80, 120, 160, 200}
        if player:spellSlot(1).state == 0 then
            Damage = (DamageAP[player:spellSlot(1).level] + 0.2 *
                         player.flatMagicDamageMod *
                         player.percentMagicDamageMod)
        end
        return Damage
    end
    return 0
end

local function GetWCour(target)
    if target ~= 0 then
        local Damage = 0
        local DamageAP = {60, 110, 160, 21}
        if player:spellSlot(1).state == 0 then
            Damage = (DamageAP[player:spellSlot(3).level] + 0.3 *
                         player.flatMagicDamageMod *
                         player.percentMagicDamageMod)
        end
        return Damage
    end
    return 0
end

local function Farm()
    local manaCheck = common.GetPercentPar(player) >= menu.farm.Mana:get()
    local minions = objManager.minions
    for i = 0, minions.size[TEAM_ENEMY] - 1 do
        local minion = minions[TEAM_ENEMY][i]
        if minion and common.IsValidTarget(minion) then
            local dist = player.path.serverPos:dist(minion.path.serverPos)
            if not isHuman() then
                if menu.farm.QC:get() and player:spellSlot(0).state == 0 and
                    player:spellSlot(0).name ~= "JavelinToss" and dist <= 400 then
                    player:castSpell("self", 0)
                end
                if menu.farm.WC:get() and player:spellSlot(1).state == 0 and
                    player:spellSlot(1).name == "Pounce" then
                    if dist <= 750 then
                        player:castSpell("pos", 1, minion.pos)
                    end
                end
                if menu.farm.EC:get() and player:spellSlot(2).state == 0 and
                    player:spellSlot(2).name == "Swipe" then
                    if dist < (300 + minion.boundingRadius) then
                        player:castSpell("pos", 2, minion.pos)
                    end
                end
                if menu.farm.autoR:get() and player:spellSlot(3).state == 0 then
                    if player:spellSlot(0).state ~= 0 and
                        player:spellSlot(0).name ~= "JavelinToss" and
                        player:spellSlot(1).state ~= 0 and
                        player:spellSlot(1).name == "Pounce" and
                        player:spellSlot(2).state ~= 0 and
                        player:spellSlot(2).name == "Swipe" and manaCheck then
                        player:castSpell("self", 3)
                    end
                end
            end
            if isHuman() then
                if menu.farm.Q:get() and player:spellSlot(0).state == 0 and
                    player:spellSlot(0).name == "JavelinToss" and manaCheck and
                    dist <= 1500 then
                    player:castSpell("pos", 0, minion.pos)
                end
                if menu.farm.W:get() and player:spellSlot(1).state == 0 and
                    player:spellSlot(1).name == "BushWhack" and dist < 900 and
                    manaCheck then
                    if GetWHuman(minion) > minion.health and
                        not minion.pathssActive then
                        player:castSpell("pos", 1, minion.pos)
                    end
                end
                if menu.farm.autoR:get() and player:spellSlot(3).state == 0 and
                    (player:spellSlot(0).state ~= 0 and player:spellSlot(0).name ==
                        "JavelinToss" or not manaCheck or not menu.farm.Q:get()) then
                    player:castSpell("self", 3)
                end
            end
        end
    end
end

local function GetClosestJungleMob()
    local closestMob, distanceMob = nil, math.huge
    local minions = objManager.minions
    for i = 0, minions.size[TEAM_NEUTRAL] - 1 do
        local check = minions[TEAM_NEUTRAL][i]
        if check and common.IsValidTarget(check) then
            local mobDist = player.path.serverPos:dist(check.path.serverPos)
            if mobDist < distanceMob then
                distanceMob = mobDist
                closestMob = check
            end
        end
    end
    return closestMob
end

local function JungleFarm()
    local manaCheck = common.GetPercentMana() > menu.farm.Mana:get()
    local minions = objManager.minions
    for i = 0, minions.size[TEAM_NEUTRAL] - 1 do
        local minion = minions[TEAM_NEUTRAL][i]
        if minion and common.IsValidTarget(minion) then
            local dist = player.path.serverPos:dist(minion.path.serverPos)
            if not isHuman() then
                if menu.farm.QC:get() and player:spellSlot(0).state == 0 and
                    player:spellSlot(0).name ~= "JavelinToss" and dist <= 400 then
                    player:castSpell("self", 0)
                end
                if menu.farm.WC:get() and player:spellSlot(1).state == 0 and
                    player:spellSlot(1).name == "Pounce" then
                    if dist <= 750 then
                        player:castSpell("pos", 1, minion.pos)
                    end
                end
                if menu.farm.EC:get() and player:spellSlot(2).state == 0 and
                    player:spellSlot(2).name == "Swipe" then
                    if dist < (300 + minion.boundingRadius) then
                        player:castSpell("pos", 2, minion.pos)
                    end
                end
                if menu.farm.autoR:get() and player:spellSlot(3).state == 0 then
                    if player:spellSlot(0).state ~= 0 and
                        player:spellSlot(0).name ~= "JavelinToss" and manaCheck then
                        player:castSpell("self", 3)
                    end
                end
            end
            if isHuman() then
                if menu.farm.Q:get() and player:spellSlot(0).state == 0 and
                    player:spellSlot(0).name == "JavelinToss" and manaCheck and
                    dist <= 1500 then
                    player:castSpell("pos", 0, minion.pos)
                end
                if menu.farm.W:get() and player:spellSlot(1).state == 0 and
                    player:spellSlot(1).name == "Bushwhack" and dist < 900 and
                    manaCheck then
                    player:castSpell("pos", 1, minion.pos)
                    -- end
                end
                if menu.farm.autoR:get() and player:spellSlot(3).state == 0 and
                    (player:spellSlot(0).state ~= 0 and player:spellSlot(0).name ==
                        "JavelinToss" or not manaCheck or not menu.farm.Q:get()) then
                    player:castSpell("self", 3)
                end
            end
        end
    end
end

local function Healing()
    if player.isRecalling or player.isDead then return end
    if player:spellSlot(2).state == 0 and player:spellSlot(2).name ~= "Swipe" then
        if menu.heal.useSelf:get() and common.GetPercentHealth(obj) <
            menu.heal.healthSelf:get() and common.GetPercentPar(obj) >
            menu.heal.Mana1:get() then
            if isHuman() and player:spellSlot(2).state == 0 then
                player:castSpell("self", 2)
            end
            if not isHuman() and menu.heal.autoR:get() and
                player:spellSlot(3).state == 0 and not orb.combo.is_active() and
                not orb.menu.lane_clear:get() then
                player:castSpell("self", 3)
                orb.core.set_server_pause()
                player:castSpell("self", 2)
            end
        end

        if menu.heal.useAlly:get() and common.GetPercentPar(obj) >
            menu.heal.Mana2:get() then
            for i = 0, objManager.allies_n - 1 do
                local ally = objManager.allies[i]
                if ally and not ally.isDead and ally.isVisible then
                    local dist = player.path.serverPos:dist(ally.path.serverPos)
                    if dist <= 600 and common.GetPercentHealth(ally) <
                        menu.heal.healthAlly:get() then
                        if isHuman() and player:spellSlot(2).state == 0 then
                            player:castSpell("obj", 2, ally)
                        end
                        if not isHuman() and menu.heal.autoR:get() and
                            player:spellSlot(3).state == 0 and
                            not orb.combat.is_active() and
                            not orb.menu.lane_clear:get() then
                            player:castSpell("self", 3)
                            orb.core.set_server_pause()
                            player:castSpell("obj", 2, ally)
                        end
                    end
                end
            end
        end
    end
end

local function KS()
    if not menu.ks.Q:get() or player:spellSlot(0).state ~= 0 or
        player:spellSlot(0).name ~= "JavelinToss" then return end
    for i = 0, objManager.enemies_n - 1 do
        local enemy = objManager.enemies[i]
        if enemy and common.IsValidTarget(enemy) and enemy.pos:dist(player.pos) <=
            1500 then
            if isHuman() and player:spellSlot(0).state == 0 and
                player:spellSlot(0).name == "JavelinToss" then
                if GetQDmg(enemy) > common.GetShieldedHealth("AP", enemy) then
                    player:castSpell("pos", 0, enemy.pos)
                end
            end
        end
    end
end

local function Harass()
    if common.GetPercentPar(obj) < menu.harass.Mana:get() or not isHuman() then
        return
    end
    if menu.harass.Q:get() and isHuman() and player:spellSlot(0).state == 0 then
        local target = GetTarget()
        if target and common.IsValidTarget(target) and
            target.pos:dist(player.pos) <= 1500 then
            player:castSpell("pos", 0, target.pos)
        end
    end
end

local function Combo()
    local target = GetTarget()
    if orb.combat.target then target = orb.combat.target end
    if target and common.IsValidTarget(target) then
        local dist = player.path.serverPos:dist(target.path.serverPos)
        if isHuman() then
            if menu.combo.Q:get() and player:spellSlot(0).state == 0 then
                -- wprint("Called QPred")
                qpred()
            end
            if menu.combo.W:get() and player:spellSlot(1).state == 0 then
                if dist <= 900 then
                    local res = preds.circular.get_prediction(wPred, target)
                    if res and res.startPos:dist(res.endPos) < 900 then
                        player:castSpell("pos", 1, target.pos)
                    end
                end
            end
            if menu.combo.RC:get() and player:spellSlot(3).state == 0 then
                if dist <= 375 or (isHunted(target)) and dist <= 750 then
                    player:castSpell("self", 3)
                end
            end
        end
        if not isHuman() then
            if menu.combo.WC:get() and player:spellSlot(1).state == 0 then
                if isHunted(target) and dist <= 750 then
                    player:castSpell("pos", 1, target.pos)
                end
            elseif dist <= 375 then
                player:castSpell("pos", 1, target.pos)
            end
            if menu.combo.EC:get() and player:spellSlot(2).state == 0 then
                if dist < (300 + target.boundingRadius) then
                    player:castSpell("pos", 2, target.pos)
                end
            end
            if menu.combo.QC:get() and player:spellSlot(0).state == 0 and
                player:spellSlot(0).name == "Takedown" and dist < 400 then
                player:castSpell("self", 0)
                orb.core.reset()
            end
            if menu.combo.RC:get() and player:spellSlot(3).state == 0 then
                local Qlevel = player:spellSlot(0).level
                local manaSpear =
                    Qlevel > 0 and ({50, 60, 70, 80, 90})[Qlevel] or 0
                if isHunted(target) and dist > 750 and player.par >= manaSpear and
                    player:spellSlot(0).state == 0 then
                    player:castSpell("self", 3)
                elseif dist >= 375 then
                    player:castSpell("self", 3)
                elseif player:spellSlot(0).state ~= 0 and
                    player:spellSlot(1).state ~= 0 and player:spellSlot(2).state ~=
                    0 then
                    if common.GetPercentPar(obj) >= manaSpear then
                        player:castSpell("self", 3)
                    end
                end
            end
        end
    end
end

local function OnDraw()
    if isHuman() then
        if menu.draws.Q:get() and player:spellSlot(0).state == 0 and
            player.isOnScreen then
            graphics.draw_circle(player.pos, 1500, 2,
                                 graphics.argb(255, 7, 141, 237), 50)
        end
        if menu.draws.W:get() and player:spellSlot(1).state == 0 and
            player.isOnScreen then
            graphics.draw_circle(player.pos, 900, 2,
                                 graphics.argb(255, 7, 141, 237), 50)
        end
    else
        if menu.draws.QC:get() and player:spellSlot(0).state == 0 and
            player.isOnScreen then
            graphics.draw_circle(player.pos, 325, 2,
                                 graphics.argb(255, 7, 141, 237), 50)
        end
        if menu.draws.WC:get() and player:spellSlot(1).state == 0 and
            player.isOnScreen then
            graphics.draw_circle(player.pos, 375, 2,
                                 graphics.argb(255, 7, 141, 237), 50)
        end
        if menu.draws.EC:get() and player:spellSlot(2).state == 0 and
            player.isOnScreen then
            graphics.draw_circle(player.pos, 300, 2,
                                 graphics.argb(255, 7, 141, 237), 50)
        end
    end
end

local function OnTick()
    if orb.combat.is_active() then Combo() end
    if orb.menu.hybrid.key:get() then Harass() end
    if orb.menu.lane_clear.key:get() then
        Farm()
        JungleFarm()
    end
    if menu.keys.flee:get() then FleeKiteLogic() end
    KS()
    Healing()
end

orb.combat.register_f_pre_tick(OnTick)
cb.add(cb.draw, OnDraw)
