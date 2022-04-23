local orb = module.internal("orb")
local evade = module.seek("evade")
local preds = module.internal("pred")
local ts = module.internal("TS")
local common = module.load(header.id, "common2")
local crashreporter = module.load(header.id, "crashreporter")
if player.charName ~= "Kayn" then
    print("not using Kayn not loading")
    return
end

local selectTarget = function(res, obj, dist)
    if dist > 1000 then return end
    res.obj = obj
    return true
end

local function GetTarget() return ts.get_result(selectTarget).obj end

local TargetSelectionQ = function(res, obj, dist)
	if dist <= 460 then
		res.obj = obj
		return true
	end
end

local GetTargetQ = function()
	return ts.get_result(TargetSelectionQ).obj
end
local TargetSelectionW = function(res, obj, dist)
	if dist <= 700 then
		res.obj = obj
		return true
	end
end
local GetTargetW = function()
	return ts.get_result(TargetSelectionW).obj
end

local TargetSelectionW = function(res, obj, dist)
	if dist <= 900 then
		res.obj = obj
		return true
	end
end
local GetTargetW2 = function()
	return ts.get_result(TargetSelectionW).obj
end

local TargetSelectionR = function(res, obj, dist)
	if dist <= 550 then
		res.obj = obj
		return true
	end
end
local GetTargetR = function()
	return ts.get_result(TargetSelectionR).obj
end


local QlvlDmg = {65, 90, 115, 140, 165}
local wlvlDmg = {85, 115, 145, 165, 205}
local rlvlDmg = {150, 250, 350}
local RP, Darkin, KaynP = nil, nil, nil
local AS = false

local qPred = {
    delay = 0.25,
    radius = 270,
    speed = math.huge,
    boundingRadiusMod = 0,
    collision = {hero = false, minion = false}
}
local wPred = {
    delay = 0.3,
    width = 100,
    speed = 1700,
    boundingRadiusMod = 1,
    collision = {hero = false, minion = false}
}
local w2Pred = {
    delay = 0.6,
    width = 100,
    speed = 500,
    boundingRadiusMod = 1,
    collision = {hero = false, minion = false}
}

local menu = menu("Trent_Kaynlel", "Trent Kayn")

menu:header("header_keys", "Combat")
menu:keybind("combat", "Combat Key", "Space", nil)
menu:keybind("farm", "Farm Key", "V", nil)

menu:menu("q", "Q")
menu.q:boolean("enable_q", "Use Q", true)
menu.q:dropdown("qm", "Q Mode: ", 2, {"Never", "With Prediction", "MousePosition"})
menu.q:boolean("qfarm", "Q Jungle Mobs", true)
menu.q:slider("mana_farmq", "Q Farm Mana  <= ", 50, 1, 100, 5)

menu:menu("w", "W")
menu.w:boolean("enable_w", "Use W", true)
menu.w:boolean("wfarm", "W Jungle Mobs", true)
menu.w:slider("mana_farmw", "W Farm Mana >=", 50, 1, 100, 5)

menu:menu("r", "R")
menu.r:boolean("enable_r", "Use R", true)
--menu.r:dropdown("rm", "Ultimate Mode: ", 2, {"Always Ultimate", "Smart Ultimate"})

menu:menu("ks", "Killsteal")
menu.ks:boolean("uks", "Use Smart Killsteal", true)
menu.ks:boolean("ukse", "Use R in Killsteal", false)

local function IsReady(spell)
    return player:spellSlot(spell).state == 0
end

function Combo()
    if menu.combat:get() then
        if menu.q.enable_q:get() and menu.q.qm:get() > 1 then
            if menu.q.qm:get() == 3 then
                if IsReady(_Q) and player.pos:dist(target.pos) <= 560 then
                    player:castSpell("pos", 0, vec3(game.mousePos))
                end
            elseif menu.q.qm:get() == 2 then
                CastQ(target)
            end
        end
        if menu.w.enable_w:get() then
            CastW(target)
        end
    end
end

function CastQ(target)
    if menu.q.enable_q:get() and IsReady(_Q) then
        local target = GetTargetQ()
        if common.IsValidTarget(target) and target then
            local pos = preds.circular.get_prediction(qPred, target)
            if pos and player.pos:to2D():dist(pos.endPos) < 460 then
                player:castSpell("pos", _Q, vec3(pos.endPos.x, mousePos.y, pos.endPos.y))
            end
        end
    end
end

function CastW(target)
    if menu.w.enable_w:get() and IsReady(_W) then
        local target = GetTargetW()
        if AS == false and common.IsValidTarget(target) and target then
            local pos = preds.linear.get_prediction(wPred, target)
            if pos and pos.startPos:dist(pos.endPos) < 700 then
                player:castSpell("pos", 1, vec3(pos.endPos.x, mousePos.y, pos.endPos.y))
            end
        end
        if AS == true then
            local pos = preds.linear.get_prediction(w2Pred, target)
            if pos and pos.startPos:dist(pos.endPos) < 900 then
                player:castSpell("pos", 1, vec3(pos.endPos.x, mousePos.y, pos.endPos.y))
            end
        end
    end
end

function CastR(target)
    if IsReady(_R) then
        if AS == false and player.pos:dist(target.pos) <= 550 then
            player:castSpell("obj", 3, target)
        elseif AS == true and player.pos:dist(target.pos) <= 750 then
            player:castSpell("obj", 3, target)
        end
    end
end

function KillSteal()
    local enemy = common.GetEnemyHeroes()
	for i, enemies in ipairs(enemy) do
        if
            not enemy.isDead and enemy.isVisible and enemy.isTargetable and menu.r.uks:get() and
                player.pos:dist(target.pos) <= 1000
         then
            local hp = enemy.health
            if hp == 0 then
                return
            end
            if player:spellslot(0).state == 0 and qDmg(enemy) > hp then
                CastQ(enemy)
            elseif player:spellslot(1).state == 0 and wDmg(enemy) > hp then
                CastW(enemy)
            elseif player:spellslot(3).state == 0 and menu.r.ukse:get() and rDmg(enemy) > hp then
                CastR(enemy)
            elseif player:spellslot(1).state == 0 and player:spellslot(0).state == 0 and wDmg(enemy) + qDmg(enemy) > hp then
                CastQ(enemy)
                CastW(enemy)
            elseif
                player:spellslot(3).state == 0 and player:spellslot(0).state == 0 and qDmg(enemy) + rDmg(enemy) > hp and
                    menu.r.ukse:get()
             then
                CastR(enemy)
                CastQ(enemy)
            elseif
                player:spellslot(1).state == 0 and player:spellslot(0).state == 0 and player:spellslot(3).state == 0 and
                    qDmg(enemy) + rDmg(enemy) + wDmg(enemy) > hp and
                    menu.r.ukse:get()
             then
                CastR(enemy)
                CastQ(enemy)
                CastW(enemy)
            end
        end
    end
end

function oncreateobj(obj)
    if obj and obj.name and obj.type then
        if obj.name:find("Kayn_Base_R_marker_beam") then
            RP = true
        end
        if obj.name:find("Kayn_Base_Primary_R_Mark") then
            KaynP = true
        end
        if obj.name:find("Kayn_Base_Slayer") then
            Darkin = true
        end
        if obj.name:find("Kayn_Base_Assassin") then
            AS = true
        end
    --if obj and obj.name and obj.name:lower():find("kayn") then print("Created "..obj.name) end
    end
end

function ondeleteobj(obj)
    if obj and obj.name and obj.type then
        if obj.name:find("Kayn_Base_R_marker_beam") then
            RP = false
        end
        if obj.name:find("Kayn_Base_Primary_R_Mark") then
            KaynP = false
        end
        if obj.name:find("Kayn_Base_Slayer") then
            Darkin = false
        end
    end
end

function qDmg(target)
    local qDamage = CalcADmg(target, QlvlDmg[player:spellslot(0).level] + player.flatPhysicalDamageMod * 0.95, player)
    return qDamage
end

function wDmg(target)
    local wDamage = CalcADmg(target, WlvlDmg[player:spellslot(1).level] + player.flatPhysicalDamageMod * 1.5, player)
    return wDamage
end

function rDmg(target)
    local rDamage = CalcADmg(target, RlvlDmg[player:spellslot(3).level] + player.flatPhysicalDamageMod * 1.85, player)
    return rDamage
end

--[[function CountEnemyHeroInRange(range)
	local range, count = range*range, 0 
	for i = 0, objmanager.enemies_n - 1 do
		if player.pos:distSqr(objmanager.enemies[i].pos) < range then 
	 		count = count + 1 
	 	end 
	end 
	return count 
end--]]
function CalcADmg(target, amount, from)
    local from = from or player or objmanager.player
    local target = target or orb.combat.target
    local amount = amount or 0
    local targetD = target.armor * math.ceil(from.percentArmorPenetration) - from.flatArmorPenetration
    local dmgMul = 100 / (100 + targetD)
    if dmgMul < 0 then
        dmgMul = 2 - (100 / (100 - targetD))
    end
    amount = amount * dmgMul
    return math.floor(amount)
end


local function JungleClear()
    if menu.q.qfarm:get() and player:spellSlot(0).state == 0 then
        for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
            local minion = objManager.minions[TEAM_NEUTRAL][i]
            if
                minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
                    minion.pos:dist(player.pos) < 460
             then
                player:castSpell("pos", 0, minion.pos)
            end
        end
    end
    if menu.w.wfarm:get() and player:spellSlot(1).state == 0 then
        for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
            local minion = objManager.minions[TEAM_NEUTRAL][i]
            if
                minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
                    minion.pos:dist(player.pos) < 700
             then
                player:castSpell("pos", 1, minion.pos)
            end
        end
    end
end

cb.add(
    cb.tick,
    function()
        if menu.farm:get() then
            JungleClear()
        end

        if menu.combat:get() then
            local target = GetTarget()
            if target then
                Combo(target)
            end
        end
        KillSteal()
    end
)

menu:menu("range", "Spell Range")
menu.range:boolean("q_range", "Draw Q range", true)
menu.range:boolean("w_range", "Draw W range", true)
menu.range:boolean("e_range", "Draw E range", true)
menu.range:boolean("r_range", "Draw R range", true)
menu.range:color("c1", "Color Q ", 255, 89, 14, 199)
menu.range:color("c2", "Color W", 255, 255, 14, 199)
menu.range:color("c3", "Color E", 255, 89, 255, 199)
menu.range:color("c4", "Color R", 144, 89, 14, 199)
menu.range:boolean("disable_drawings", "Disable Drawings", false)

cb.add(
    cb.draw,
    function()
        local color1 = menu.range.c1:get()
        local color2 = menu.range.c2:get()
        local color3 = menu.range.c3:get()
        local color4 = menu.range.c4:get()
        if menu.range.disable_drawings:get() then
            return
        end
        if menu.range.q_range:get() then
            graphics.draw_circle(player.pos, 460, 2, color1, 55)
        end
        if menu.range.w_range:get() then
            graphics.draw_circle(player.pos, 700, 2, color2, 55)
        end
        if menu.range.r_range:get() then
            graphics.draw_circle(player.pos, 550, 2, color4, 55)
        end
    end
)
