local orb = module.internal("orb")
local evade = module.seek('evade')
local preds = module.internal('pred')
local ts = module.internal('TS')
local common = module.load(header.id, 'common2')
local crashreporter = module.load(header.id, 'crashreporter')

if player.charName ~= "Gnar" then
    print("not using gnar not loading")
    return
end
local menu = menu("Trent_Gnarxdlel", "Trent Gnar")

menu:menu("keys", "Key Settings")
menu.keys:keybind("combokey", "Combo Key", "Space", nil)
menu.keys:keybind("clearkey", "Clear Jungle/Lane Key", "V", nil)
menu.keys:keybind("harasskey", "Harass Key", "C", nil)
menu.keys:keybind("lasthitkey", "Lasthit Key", "X", nil)

menu:menu("combo", "Combo Settings")
menu.combo:header("tiny", "-- Tiny Gnar --")
menu.combo:boolean("qcombot", "Use Q in Combo", true)
menu.combo:boolean("ecombot", "Use E to Combo", true)
menu.combo:slider("ehpt", " Use E if Enemy Health % ", 30, 0, 100, 30)
menu.combo:boolean("turrett", "Don't Use E Under the Turret", true)

menu.combo:header("mega", "-- Mega Gnar --")
menu.combo:boolean("qcombom", "Use Q in Combo", true)
menu.combo:boolean("wcombom", "Use W in Combo", true)
menu.combo:boolean("ecombom", "Use E to Combo", true)
menu.combo:boolean("rcombo", "Use R in Combo", true)
menu.combo:slider("ehpm", "Use E if Enemy Health % ", 30, 0, 100, 30)
menu.combo:boolean("turretm", "Don't Use E Under the Turret", true)
menu.combo:slider("hitr", "Min Enemy Use R", 1, 0, 5, 1)
menu.combo:slider("autor", "Auto R Min Enemy ", 1, 0, 5, 3)

menu:menu("harass", "Harass Settings")
menu.harass:header("tiny", "-- Tiny Gnar --")
menu.harass:boolean("qharasst", "Use Q in Harass", true)
menu.harass:boolean("autoq", "Use Auto Q in Harass", true)
menu.harass:boolean("eharasst", "Use E in Harass", true)
menu.harass:boolean("turrett", "Don't Use E Under the Turret", true)
menu.harass:header("tiny", "-- Mega Gnar --")
menu.harass:boolean("qharassm", "Use Q in Harass", true)
menu.harass:boolean("wharassm", "Use W in Harass", true)
menu.harass:boolean("eharassm", "Use E in Harass", true)
menu.harass:boolean("turretm", "Don't Use E Under the Turret", true)

menu:menu("laneclear", "LaneClear Settings")
menu.laneclear:header("tiny", "-- Tiny Gnar --")
menu.laneclear:boolean("farmqt", "Use Q to Farm", true)
menu.laneclear:boolean("farmet", "Use E to Farm", false)
menu.laneclear:header("tiny", "-- Mega Gnar --")
menu.laneclear:boolean("farmqm", "Use Q to Farm", true)
menu.laneclear:boolean("farmwm", "Use W to Farm", true)
menu.laneclear:boolean("farmem", "Use E to Farm", false)

menu:menu("jungclear", "JungClear Settings")
menu.jungclear:header("tiny", "-- Tiny Gnar --")
menu.jungclear:boolean("jungqt", "Use Q to Jung", true)
menu.jungclear:boolean("junget", "Use E to Jung", false)
menu.jungclear:header("tiny", "-- Mega Gnar --")
menu.jungclear:boolean("jungqm", "Use Q to Jung", true)
menu.jungclear:boolean("jungwm", "Use W to Jung", true)
menu.jungclear:boolean("jungem", "Use E to Jung", true)

menu:menu("draws", "Drawings Settings")
menu.combo:header("tiny", "-- Tiny Gnar --")
menu.draws:boolean("drawq", "Draw Tiny Q Range", true)
menu.draws:color("colorq", " Color Settings", 255, 255, 255, 255)
menu.draws:boolean("drawe", "Draw Tiny E Range", true)
menu.draws:color("colore", " Color Settings", 255, 255, 255, 255)
menu.jungclear:header("tiny", "-- Mega Gnar --")
menu.draws:boolean("drawqm", "Draw Mega Q Range", true)
menu.draws:color("colorqm", " Color Settings", 255, 255, 255, 255)
menu.draws:boolean("drawwm", "Draw Mega W Range", true)
menu.draws:color("colorwm", " Color Settings", 255, 255, 255, 255)
menu.draws:boolean("drawem", "Draw Mega E Range", true)
menu.draws:color("colorem", " Color Settings", 255, 255, 255, 255)
menu.draws:boolean("drawr", "Draw R Range", true)
menu.draws:color("colorr", " Color Settings", 255, 255, 255, 255)

local QlDmgt = {65, 90, 115, 140, 165}
local ElDmgt = {70, 95, 120, 145, 170}

local QlDmgm = {65, 90, 115, 140, 165}
local WlDmgm = {65, 90, 115, 140, 165}
local ElDmgm = {70, 95, 120, 145, 170}
local RlDmgm = {65, 90, 115, 140, 165}

local TargetSelection = function(res, obj, dist)
	if dist <= 1100 then
		res.obj = obj
		return true
	end
end
local function select_target(res, obj, dist)
	if dist > 1100 then return end
	res.obj = obj
	return true
end
local function count_enemies_in_range(pos, range)
	local enemies_in_range = {}
	for i = 0, objManager.enemies_n - 1 do
		local enemy = objManager.enemies[i]
		if pos:dist(enemy.pos) < range and common.IsValidTarget(enemy) then
			enemies_in_range[#enemies_in_range + 1] = enemy
		end
	end
	return enemies_in_range
end
local function get_target(func)
	return ts.get_result(func).obj
end

local qpt = { delay = 0.25, width = 55, speed = 1700, range = 1100, boundingRadiusMod = 1, collision = { hero = false, minion = false } }
local qprt = { delay = 0.25, width = 70, speed = 1700, range = 1100, boundingRadiusMod = 1, collision = { hero = false, minion = false } }
local ept = { delay = 0.25, radius = 160, speed = 900, range = 475, boundingRadiusMod = 1, collision = { hero = false, minion = false } }

local qpm = { delay = 0.50, width = 90, speed = 2100, range = 1100, boundingRadiusMod = 1, collision = { hero = false, minion = true } }
local wpm = { delay = 0.60, radius = 125, speed = math.huge, range = 550, boundingRadiusMod = 1, collision = { hero = false, minion = false } }
local epm = { delay = 0.25, radius = 375, speed = 800, range = 800, boundingRadiusMod = 1, collision = { hero = false, minion = false } }
local rpm = { delay = 0.25, width = 475, speed = math.huge, range = 475, boundingRadiusMod = 1, collision = { hero = false, minion = false } }
    
    
local function CreateObj(object)
	if object and object.name then
		if object.name:find("GnarQReturn") then
			objHolder[object.ptr] = object
		end
	end
end
local function DeleteObj(object)
	if object and object.name then
		if object.name:find("GnarQReturn") then
			objHolder[object.ptr] = object
		end
	end
end

local function CastQt(target)
	if player:spellSlot(0).state == 0 and player:spellSlot(0).name == "GnarQ" and player.path.serverPos:distSqr(target.path.serverPos) < (1100 * 1100) then
		local ser = preds.linear.get_prediction(qpt, target)
		if ser and ser.startPos:dist(ser.endPos) < 1100 then
            if pred.collision.get_prediction(qpt, ser, obj) then return false end
			    player:castSpell("pos", 0, vec3(ser.endPos.x, game.mousePos.y, ser.endPos.y))
			    player:move("GnarQReturn")
		    end
        end
	end
end

local function CastEt(target)
	if player:spellSlot(2).state == 0 and player:spellSlot(2).name == "GnarE" and player.path.serverPos:distSqr(target.path.serverPos) < (475 * 475) then
		local ser = preds.linear.get_prediction(qpm, target)
		if ser and ser.startPos:dist(ser.endPos) < 475 then
			player:castSpell("pos", 2, vec3(ser.endPos.x, game.mousePos.y, ser.endPos.y))
		end
	end
end

local function CastQm(target)
	if player:spellSlot(0).state == 0 and player:spellSlot(0).name == "GnarBigQ" and player.path.serverPos:distSqr(target.path.serverPos) < (1100 * 1100) then
		local ser = preds.linear.get_prediction(qpm, target)
		if ser and ser.startPos:dist(ser.endPos) < 1100 then
			player:castSpell("pos", 0, vec3(ser.endPos.x, game.mousePos.y, ser.endPos.y))
		end
	end
end 

local function CastWm(target)
	if player:spellSlot(1).state == 0 and player:spellSlot(1).name == "GnarBigW" and player.path.serverPos:distSqr(target.path.serverPos) < (550 * 550) then
		local ser = preds.circular.get_prediction(wpm, target)
		if ser and ser.startPos:dist(ser.endPos) < 550 then		
			player:castSpell("pos", 1, vec3(ser.endPos.x, game.mousePos.y, ser.endPos.y))
		end
	end
end 

local function CastEm(target)
	if player:spellSlot(2).state == 0 and player:spellSlot(2).name == "GnarBigE" and player.path.serverPos:distSqr(target.path.serverPos) < (600 * 600) then
		local ser = preds.circular.get_prediction(epm, target)
		if ser and ser.startPos:dist(ser.endPos) < 600 then
			player:castSpell("pos", 2, vec3(ser.endPos.x, game.mousePos.y, ser.endPos.y))
		end
	end
end  

local function CastR(target)
	if player:spellSlot(3).state == 0 and player:spellSlot(3).name == "GnarR" and player.path.serverPos:distSqr(target.path.serverPos) < (300 * 300) then
		local ser = preds.linear.get_prediction(rpm, target)
		local c = player.pos
		local p = 36
		local r = 300
		local s = 2 * math.pi / p

	for i = 0, p, 1 do
		local angle = s * i
		local _X = c.x + r * math.cos(angle)
		local _Z = c.z + r * math.sin(angle)
		local RPOS = vec3(_X, 0, _Z)

		if navmesh.isWall(RPOS) then
		  		player:castSpell("pos", 3, RPOS)
		end
	end
	end
end  

local function Combo()
    local target = get_target(select_target)
    for i = 0, objManager.enemies_n - 1 do
    local enemy = objManager.enemies[i]
    if enemy and common.IsValidTarget(enemy) then
    local hp = enemy.health
        if target and common.IsValidTarget(target) then
            if menu.combo.qcombot:get() and player:spellSlot(0).state == 0 and player.pos:dist(target.pos) <= qpt.range then
                CastQt(target)
            end	
            if menu.combo.ecombot:get() and player:spellSlot(2).state == 0 and player.pos:dist(target.pos) <= (475 * 475) and 
                (target.health / target.maxHealth * 100) <= menu.combo.ehpt:get() then
                if menu.combo.turrett:get() and not common.IsUnderTurret(object)
                     then CastEt(target)
                end
            end	
            if menu.combo.qcombom:get() and player:spellSlot(0).state == 0 and player.pos:dist(target.pos) <= qpm.range 
                then CastQm(target)
            end			
            if menu.combo.wcombom:get() and player:spellSlot(1).state == 0 and player.pos:dist(target.pos) <= wpm.range
                then CastWm(target)
            end	
            if menu.combo.ecombom:get() and player:spellSlot(2).state == 0 and player.pos:dist(target.pos) <= epm.range and 
                (target.health / target.maxHealth * 100) <= menu.combo.ehpm:get() then
                if menu.combo.turretm:get() and not common.IsUnderTurret(object)
                    then CastEm(target)
                end
            end	
            if menu.combo.rcombo:get() and player:spellSlot(3).state == 0 and menu.combo.hitr:get() <= #count_enemies_in_range(target.pos, 400) and player.pos:dist(target.pos) <= (300 * 300 )
                    then CastR(target)
            end	
        end
    end
end				

local function Harass()
    local target = get_target(select_target)
        if target and common.IsValidTarget(target) then
            if menu.harass.qharasst:get() and menu.keys.harasskey:get() and player:spellSlot(0).state == 0 and player.pos:dist(target.pos) <= qpt.range then
                CastQt(target)
            end
            if (target.health / target.maxHealth * 100) <= menu.combo.ehpt:get() then
                if menu.harass.eharasst:get() and menu.keys.harasskey:get() and player:spellSlot(2).state == 0 and player.pos:dist(target.pos) <= (475 * 475) then
                    if menu.harass.turrett:get() and not common.IsUnderTurret(object)
                        then CastEt(target)
                    end
                end	
            end
            if menu.harass.qharassm:get() and menu.keys.harasskey:get() and player:spellSlot(0).state == 0 and player.pos:dist(target.pos) <= qpm.range 
                then CastQm(target)
            end			
            if menu.harass.wharassm:get() and menu.keys.harasskey:get() and player:spellSlot(1).state == 0 and player.pos:dist(target.pos) <= wpm.range
                then CastWm(target)
            end	
            if (target.health / target.maxHealth * 100) <= menu.combo.ehpm:get() then
                if menu.harass.eharassm:get() and menu.keys.harasskey:get() and player:spellSlot(2).state == 0 and player.pos:dist(target.pos) <= epm.range then
                    if menu.harass.turretm:get() and not common.IsUnderTurret(object)
                        then CastEm(target)
                    end
                end
            end
        end
    end
end

local function Harass()
    local target = get_target(select_target)
        if target and common.IsValidTarget(target) then
            if menu.harass.qharasst:get() and menu.keys.harasskey:get() and player:spellSlot(0).state == 0 and player.pos:dist(target.pos) <= qpm.range then
                CastQt(target)
            end
            if (target.health / target.maxHealth * 100) <= menu.combo.ehpt:get() then
                if menu.harass.eharasst:get() and menu.keys.harasskey:get() and player:spellSlot(2).state == 0 and player.pos:dist(target.pos) <= (475 * 475) then
                    if menu.harass.turrett:get() and not common.IsUnderTurret(obj)
                        then CastEt(target)
                    end
                end	
            end
            if menu.harass.qharassm:get() and menu.keys.harasskey:get() and player:spellSlot(0).state == 0 and player.pos:dist(target.pos) <= qpm.range 
                then CastQm(target)
            end			
            if menu.harass.wharassm:get() and menu.keys.harasskey:get() and player:spellSlot(1).state == 0 and player.pos:dist(target.pos) <= wpm.range
                then CastWm(target)
            end	
            if (target.health / target.maxHealth * 100) <= menu.combo.ehpm:get() then
                if menu.harass.eharassm:get() and menu.keys.harasskey:get() and player:spellSlot(2).state == 0 and player.pos:dist(target.pos) <= epm.range then
                    if menu.harass.turretm:get() and not common.is_under_tower(vec3(target.x, target.y, target.z))
                        then CastEm(target)
                    end
                end	
            end
        end			
    end
end

local function JungClear()	
    if menu.jungclear.jungqt:get() and menu.keys.clearkey:get() then	
        local enemyMinionsQ = common.GetMinionsInRange(qpt.range, TEAM_NEUTRAL)
        for i, minion in pairs(enemyMinionsQ) do
            if minion and not minion.isDead and common.IsValidTarget(minion) then
                local minionPos = vec3(minion.x, minion.y, minion.z)
                if minionPos:dist(player.pos) <= qpt.range then
                    CastQt(minion)
                end
            end
        end
    end
    if menu.jungclear.jungqt:get() and menu.keys.clearkey:get() then	
        local enemyMinionsE = common.GetMinionsInRange(475, TEAM_NEUTRAL)
        for i, minion in pairs(enemyMinionsE) do
            if minion and not minion.isDead and common.IsValidTarget(minion) then
                local minionPos = vec3(minion.x, minion.y, minion.z)
                if minionPos:dist(player.pos) <= 475 then
                    CastEt(minion)
                 end
             end
        end
    end
    if menu.jungclear.jungqm:get() and menu.keys.clearkey:get() then	
        local enemyMinionsQ = common.GetMinionsInRange(qpm.range, TEAM_NEUTRAL)
        for i, minion in pairs(enemyMinionsQ) do
            if minion and not minion.isDead and common.IsValidTarget(minion) then
                local minionPos = vec3(minion.x, minion.y, minion.z)
                if minionPos:dist(player.pos) <= qpm.range then
                    CastQm(minion)
                end
            end
         end
    end
    if menu.jungclear.jungwm:get() and menu.keys.clearkey:get() then	
        local enemyMinionsW = common.GetMinionsInRange(wpm.range, TEAM_NEUTRAL)
        for i, minion in pairs(enemyMinionsW) do
            if minion and not minion.isDead and common.IsValidTarget(minion) then
                local minionPos = vec3(minion.x, minion.y, minion.z)
                if minionPos:dist(player.pos) <= wpm.range then
                    CastWm(minion)
                end
            end
         end
    end
    if menu.jungclear.jungem:get() and menu.keys.clearkey:get() then	
        local enemyMinionsE = common.GetMinionsInRange(epm.range, TEAM_NEUTRAL)
        for i, minion in pairs(enemyMinionsE) do
            if minion and not minion.isDead and common.IsValidTarget(minion) then
                local minionPos = vec3(minion.x, minion.y, minion.z)
                if minionPos:dist(player.pos) <= epm.range then
                    CastEm(minion)
                end
            end
        end
    end
end

local function LaneClear()
    if menu.laneclear.farmqt:get() and menu.keys.clearkey:get() then
        local enemyMinionsQ = common.GetMinionsInRange(qpt.range, TEAM_ENEMY)
        for i, minion in pairs(enemyMinionsQ) do
            if minion and not minion.isDead and common.IsValidTarget(minion) then
            local minionPos = vec3(minion.x, minion.y, minion.z)
                if minionPos:dist(player.pos) <= qpt.range then
                    CastQt(minion)
                end
            end	
        end
    end
    if menu.laneclear.farmet:get() and menu.keys.clearkey:get() then
        local enemyMinionsE = common.GetMinionsInRange(475, TEAM_ENEMY)
        for i, minion in pairs(enemyMinionsE) do
            if minion and not minion.isDead and common.IsValidTarget(minion) then
            local minionPos = vec3(minion.x, minion.y, minion.z)
                if minionPos:dist(player.pos) <= 475 then
                    CastEt(minion)
                end
            end	
        end
    end	
    if menu.laneclear.farmqm:get() and menu.keys.clearkey:get() then
        local enemyMinionsQ = common.GetMinionsInRange(qpm.range, TEAM_ENEMY)
        for i, minion in pairs(enemyMinionsQ) do
            if minion and not minion.isDead and common.IsValidTarget(minion) then
            local minionPos = vec3(minion.x, minion.y, minion.z)
                if minionPos:dist(player.pos) <= qpm.range then
                    CastQm(minion)
                end
            end	
        end
    end	
    if menu.laneclear.farmwm:get() and menu.keys.clearkey:get() then
        local enemyMinionsW = common.GetMinionsInRange(wpm.range, TEAM_ENEMY)
        for i, minion in pairs(enemyMinionsW) do
            if minion and not minion.isDead and common.IsValidTarget(minion) then
            local minionPos = vec3(minion.x, minion.y, minion.z)
                if minionPos:dist(player.pos) <= wpm.range then
                    CastWm(minion)
                end
            end	
        end
    end	
    if menu.laneclear.farmem:get() and menu.keys.clearkey:get() then
        local enemyMinionsE = common.GetMinionsInRange(epm.range, TEAM_ENEMY)
        for i, minion in pairs(enemyMinionsE) do
            if minion and not minion.isDead and common.IsValidTarget(minion) then
            local minionPos = vec3(minion.x, minion.y, minion.z)
                if minionPos:dist(player.pos) <= epm.range then
                    CastEm(minion)
                end
            end	
        end
    end	
end

local function AutoQ()
    local target = get_target(select_target)
    if target and common.IsValidTarget(target) then	
        if menu.harass.autoq:get() and player:spellSlot(0).state == 0 and player:spellSlot(0).name == "GnarQ" and player.pos:dist(target.pos) <= qpt.range 
            then CastQt(target)	 
        end	
    end
end

local function OnTick()
	if orb.combat.is_active() then Combo() end
	if menu.harass.autoq:get() then AutoQ() end
	if menu.keys.harasskey:get() then Harass() end
	if menu.keys.clearkey:get() then JungClear() end
	if menu.keys.clearkey:get() then LaneClear() end
end

local function OnDraw()
	if menu.draws.drawq:get() and player:spellSlot(0).state == 0 then
		graphics.draw_circle(player.pos, qSpell.range, 2, menu.draws.colorq:get(), 100)
	end
	if menu.draws.drawe:get() and player:spellSlot(2).state == 0 then
		graphics.draw_circle(player.pos, eSpell.range, 2, menu.draws.colore:get(), 100)
	end 
	if menu.draws.drawqm:get() and player:spellSlot(0).name == "GnarBigQ" and player:spellSlot(0).state == 0 then
		graphics.draw_circle(player.pos, qSpellm.range, 2, menu.draws.colorqm:get(), 100)
	end
	if menu.draws.drawwm:get() and player:spellSlot(1).name == "GnarBigW" and player:spellSlot(1).state == 0 then
		graphics.draw_circle(player.pos, wSpellm.range, 2, menu.draws.colorwm:get(), 100)
	end 
	if menu.draws.drawem:get() and player:spellSlot(2).name == "GnarBigE" and player:spellSlot(2).state == 0 then
		graphics.draw_circle(player.pos, eSpellm.range, 2, menu.draws.colorem:get(), 100)
	end
	if menu.draws.drawr:get() and player:spellSlot(3).state == 0 then
		graphics.draw_circle(player.pos, rSpell.range, 2, menu.draws.colorr:get(), 100)
	end			 	
end 

cb.add(cb.tick, OnTick)
cb.add(cb.draw, OnDraw)