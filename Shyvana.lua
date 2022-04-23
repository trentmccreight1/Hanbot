local orb = module.internal("orb")
local evade = module.seek('evade')
local preds = module.internal('pred')
local ts = module.internal('TS')
local common = module.load(header.id, 'common2')
local crashreporter = module.load(header.id, 'crashreporter')

if player.charName ~= "Shyvana" then
    print("not using shyv not loading")
    return
end
local menu = menu("Trent_Shyvana", "Trent Shyvana")

menu:menu("keys", "Key Settings")
menu.keys:keybind("combokey", "Combo Key", "Space", nil)
menu.keys:keybind("harasskey", "Harass Key", "C", nil)
menu.keys:keybind("clearkey", "Lane Clear Key", "V", nil)
menu.keys:keybind("lastkey", "Last Hit", "X", nil)

menu:menu("combo", "Combo Settings")
menu.combo:header("xd", "Q Settings")
menu.combo:boolean("q", "Use Q", true)
menu.combo:dropdown("modeq", "Choose Mode: ", 2, {"Before AA", "After AA"})

menu.combo:header("xd", "W Settings")
menu.combo:boolean("w", "Use W", true)

menu.combo:header("xd", "E Settings")
menu.combo:boolean("e", "Use E", true)

menu.combo:header("xd", "R Settings")
menu.combo:boolean("r", "Use R", true)
menu.combo:slider("rmin", "Min Enemies to R", 2, 1, 5, 1)

menu:menu("jg", "Jungle Clear Settings")
menu.jg:header("xd", "Jungle Settings")
menu.jg:boolean("q", "Use Q", true)
menu.jg:boolean("w", "Use W", true)
menu.jg:boolean("e", "Use E", true)

menu:menu("draws", "Draw Settings")
menu.draws:header("xd", "Drawing Options")
menu.draws:boolean("q", "Draw Q Range", true)
menu.draws:boolean("e", "Draw E Range", true)
menu.draws:boolean("r", "Draw R Range", true)


local enemies = common.GetEnemyHeroes()
local UG = false
local QAA = false
local minionmanager = objManager.minions

local ElvlDmg = {60, 100, 140, 180, 220}
local E2lvlDmg = {60, 100, 140, 180, 220}
local RlvlDmg = {150, 250, 350}

local ePred = { delay = 0.25, width = 60, speed = 1575, boundingRadiusMod = 1, collision = { hero = true, minion = true } }


local spellE = {
    range = 925, 
    width = 60,
    radius = 60, 
    speed = 1575, 
    delay = 0.25, 
    boundingRadiusMod = 1
}

local spellE2 = {
    range = 925, 
    width = 60,
    radius = 60, 
    speed = 1575, 
    delay = 0.333, 
    boundingRadiusMod = 1
}

local spellR = {
    range = 850, 
    width = 160,
    radius = 160, 
    speed = 1130, 
    delay = 0.25, 
    boundingRadiusMod = 1
}

local function select_target(res, obj, dist)
	if dist > 325 then return end
	res.obj = obj
	return true
end

local function get_target(func)
	return ts.get_result(func).obj
end

local TargetSelectionE = function(res, obj, dist)
	if dist <= spellE.range then
		res.obj = obj
		return true
	end
end

local GetTargetE = function()
	return ts.get_result(TargetSelectionE).obj
end

local TargetSelectionE2 = function(res, obj, dist)
	if dist <= spellE2.range then
		res.obj = obj
		return true
	end
end

local GetTargetE2 = function()
	return ts.get_result(TargetSelectionE2).obj
end

local TargetSelectionR = function(res, obj, dist)
	if dist <= spellR.range then
		res.obj = obj
		return true
	end
end

local GetTargetR = function()
	return ts.get_result(TargetSelectionR).obj
end

local function get_target(func)
	return ts.get_result(func).obj
end

local trace_filterE = function(input, segment, target)
    if segment.startPos:dist(segment.endPos) > spellE.range then return false end -- Checking before spellcast to see if our projected segment end is out of range if not return 
    if preds.trace.linear.hardlock(input, segment, target) then return true end -- checking cc status if so send it no real pred needed
    if preds.trace.linear.hardlockmove(input, segment, target) then -- checking cc status if so send it no real pred needed
        return true
    end
    if preds.trace.newpath(target, 0.033, 0.5) then return true end -- Kiri path strictness :omegalul:
end

local trace_filterE2 = function(input, segment, target)
    if segment.startPos:dist(segment.endPos) > spellE2.range then return false end -- Checking before spellcast to see if our projected segment end is out of range if not return 
    if preds.trace.linear.hardlock(input, segment, target) then return true end -- checking cc status if so send it no real pred needed
    if preds.trace.linear.hardlockmove(input, segment, target) then -- checking cc status if so send it no real pred needed
        return true
    end
    if preds.trace.newpath(target, 0.033, 0.5) then return true end -- Kiri path strictness :omegalul:
end

local trace_filterR = function(input, segment, target)
    if segment.startPos:dist(segment.endPos) > spellR.range then return false end -- Checking before spellcast to see if our projected segment end is out of range if not return 
    if preds.trace.linear.hardlock(input, segment, target) then return true end -- checking cc status if so send it no real pred needed
    if preds.trace.linear.hardlockmove(input, segment, target) then -- checking cc status if so send it no real pred needed
        return true
    end
    if preds.trace.newpath(target, 0.033, 0.5) then return true end -- Kiri path strictness :omegalul:
end

local function epred()

    local target = GetTargetE() 
    if common.IsValidTarget(target) then 

        local pos = preds.linear.get_prediction(spellE, target) 
        if pos and pos.startPos:dist(pos.endPos) <= spellE.range then 

            if not trace_filterE(spellE, pos, target) then return end 

            player:castSpell("pos", 2,
                             vec3(pos.endPos.x, mousePos.y, pos.endPos.y)) 

        end
    end
end

local function e2pred()

    local target = GetTargetE2() 
    if common.IsValidTarget(target) then 

        local pos = preds.linear.get_prediction(spellE2, target) 
        if pos and pos.startPos:dist(pos.endPos) <= spellE2.range then 

            if not trace_filterE2(spellE2, pos, target) then return end 

            player:castSpell("pos", 2,
                             vec3(pos.endPos.x, mousePos.y, pos.endPos.y)) 

        end
    end
end

local function rpred()

    local target = GetTargetR() 
    if common.IsValidTarget(target) then 

        local pos = preds.linear.get_prediction(spellR, target) 
        if pos and pos.startPos:dist(pos.endPos) <= spellR.range then 

            if not trace_filterR(spellR, pos, target) then return end 

            player:castSpell("pos", 3,
                             vec3(pos.endPos.x, mousePos.y, pos.endPos.y)) 

        end
    end
end

local function Buff()
	if player.buff["ShyvanaTransform"] then
		UG = true
	else
		UG = false
	end
	if player.buff["ShyvanaDoubleAttack"] then
		QAA = true
    elseif player.buff["ShyvanaDoubleAttackDragon"] then
		QAA = true
    else
        QAA = false
	end
end

local function enemiesnearenemies(pos, range)
    local Hcount = 0
    for i = 0, objManager.enemies_n - 1 do
        local eHERO = objManager.enemies[i]
        if eHERO and not eHERO.isDead and eHERO.isVisible and eHERO.isTargetable and
            pos:dist(eHERO.pos) < (range) then Hcount = Hcount + 1 end
    end
    if Hcount == 0 then return 0 end
    return Hcount
end

local function Combo()
    local target = GetTargetE()
    if target and common.IsValidTarget(target) then
        if menu.combo.q:get() and player:spellSlot(0).state == 0 and player.path.serverPos:dist(target.path.serverPos) <= player.attackRange + player.boundingRadius then
            if menu.combo.modeq:get() == 1 then
                player:castSpell("self", 0)
            end
        end
    
  
    if menu.combo.w:get() and player:spellSlot(1).state == 0 and player.path.serverPos:dist(target.path.serverPos) <= player.attackRange + player.boundingRadius then
        player:castSpell("self", 1)
    end
    
    if menu.combo.e:get() and player:spellSlot(2).state == 0 then
        epred()
    else
        if menu.combo.e:get() and player:spellSlot(2).state == 0 and player.spellSlot(2).name ~= "ShyvanaFireball" then
            e2pred()
        end
    end
    
    if menu.combo.r:get() and player:spellSlot(3).state == 0 then
        if enemiesnearenemies(target.pos,400) >= menu.combo.rmin:get() then
            rpred()
        end
    end
end
end


local function Clear()
    for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
        local obj = objManager.minions[TEAM_NEUTRAL][i]
        if player.pos:dist(obj) <= 925 then
            if obj.isVisible and obj.isTargetable and obj.health >= 1 and
                common.IsValidTarget(obj) then
                if player.pos:dist(obj) <= player.attackRange + player.boundingRadius then

                    player:castSpell('self', _Q)

                end
                if player.pos:dist(obj) <= 925 then

                    player:castSpell('pos', _E, obj.pos)

                end
                if player.pos:dist(obj) <= 400 then

                    player:castSpell('self', _W)

                end
            end
        end

    end
end



local function OnTick()
	if orb.combat.is_active() then Combo() end
	if orb.menu.lane_clear.key:get() then Clear() end
	Buff()
end

local function OnDraw()
	if menu.draws.q:get() and player:spellSlot(0).state == 0 and player.isOnScreen then
		graphics.draw_circle(player.pos, 320, 2, graphics.argb(255, 255, 255, 255), 70)
	end
	if menu.draws.e:get() and player:spellSlot(3).state == 0 and player.isOnScreen then
		graphics.draw_circle(player.pos, (925), 2, graphics.argb(255, 255, 255, 255), 70)
	end
    if menu.draws.r:get() and player:spellSlot(3).state == 0 and player.isOnScreen then
        graphics.draw_circle(player.pos, (850), 2, graphics.argb(255, 255, 255, 255), 70)
    end
end

orb.combat.register_f_pre_tick(OnTick)
cb.add(cb.draw, OnDraw)
orb.combat.register_f_after_attack(
	function()
		if orb.combat.is_active() then
			if orb.combat.target then
				if menu.combo.q:get() and menu.combo.modeq:get() == 2 and orb.combat.target and common.IsValidTarget(orb.combat.target) and player.pos:dist(orb.combat.target.pos) < common.GetAARange(orb.combat.target) then
					if player:spellSlot(0).state == 0 then
						player:castSpell("self", 0)
						orb.core.set_server_pause()
						orb.combat.set_invoke_after_attack(false)
						player:attack(orb.combat.target)
						orb.core.set_server_pause()
						orb.combat.set_invoke_after_attack(false)
						return "on_after_attack_hydra"
					end
				end
			end
		end
	end
)
