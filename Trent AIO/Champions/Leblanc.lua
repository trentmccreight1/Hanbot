local orb = module.internal("orb")
local evade = module.seek('evade')
local preds = module.internal('pred')
local ts = module.internal('TS')
local common = module.load(header.id, 'common2')
local crashreporter = module.load(header.id, 'crashreporter')
if player.charName ~= "Leblanc" then
    print("not using Leblanc not loading")
    return
end

local menu = menu("trent_leblancxd", "Trent Leblanc")
menu:menu("keys", "Key Settings")
menu.keys:keybind("c", "2 Chains Combo", "A", false)
menu:menu("combo", "Combo Settings")
menu.combo:boolean("q", "Use Q", true)

menu.combo:boolean("w", "Use W", true)
menu.combo:boolean("smartW", "Use Smart W", true)
menu.combo:boolean("wBack", "W Back After Target Dead", false)
menu.combo:keybind("comboGap1", "Gap Close if Needed", false, "T")


menu.combo:boolean("e", "Use E", true)


menu.combo:boolean("r", "Use Smart R", true)

menu:menu("harass", "Harass Settings")
menu.harass:slider("mode", "Mode: 1 = Q | 2 = Q-W | 3 = Q-W-E |", 2, 1, 3, 1)
menu.harass:boolean("smartW", "No Back W", true)
menu.harass:boolean("QCheck", "Check for Q", true)
menu.harass:slider("Mana", "Min. Mana Percent: ", 10, 0, 100, 10)

menu:menu("auto", "Killsteal Settings")
menu.auto:boolean("uks", "Use Killsteal", true)
menu.auto:boolean("uksr", "Use R on Killsteal", false)

menu:menu("draws", "Draw Settings")
menu.draws:header("xd", "Drawing Options")
menu.draws:boolean("q", "Draw Q Range", true)
menu.draws:boolean("e", "Draw E Range", true)
menu.draws:boolean("ds", "GapClose State", true)

local function select_target(res, obj, dist)
	if dist > 865 then
		return
	end
	res.obj = obj
	return true
end

local function select_gaptarget(res, obj, dist)
	if dist > 1300 then
		return
	end
	res.obj = obj
	return true
end

local function get_target(func)
	return ts.get_result(func).obj
end

local QMissile, RMissile = nil, nil
local Qobj, Robj = false, false
local leblancW, leblancRW = nil, nil
local LW, RW = false, false

local QlvlDmg = {65, 90, 115, 140, 165}
local WlvlDmg = {75, 110, 145, 180, 215}
local ElvlDmg = {50, 70, 90, 110, 130}
local RQlvlDmg = {70, 140, 210}
local RWlvlDmg = {150, 300, 450}
local RElvlDmg = {70, 140, 210}

local wPred = {
	delay = 0.6,
	radius = 260,
	speed = 1450,
	boundingRadiusMod = 0,
	collision = {hero = false, minion = false}
}
local ePred = {
	delay = 0.25,
	width = 54,
	speed = 1750,
	boundingRadiusMod = 1,
	collision = {hero = true, minion = true, wall = true}
}

local function qDmg(target)
	if player:spellSlot(0).level > 0 then
	    local damage = (QlvlDmg[player:spellSlot(0).level] + (common.GetTotalAP() * .4)) or 0
	    return common.CalculateMagicDamage(target, damage)
    end
end

local function wDmg(target)
	if player:spellSlot(1).level > 0 then
	    local damage = WlvlDmg[player:spellSlot(1).level] + (common.GetTotalAP() * .6) or 0
	    return common.CalculateMagicDamage(target, damage)
	end
end

local function eDmg(target)
	if player:spellSlot(2).level > 0 then
	    local damage = (ElvlDmg[player:spellSlot(2).level] + (common.GetTotalAP() * .3)) or 0
	    return common.CalculateMagicDamage(target, damage)
	end
end

local function rqDmg(target)
    if player:spellSlot(3).level > 0 then
        local damage = (RQlvlDmg[player:spellSlot(3).level] + (common.GetTotalAP() * .4)) or 0
        return common.CalculateMagicDamage(target, damage)
    end
end

local function rwDmg(target)
    if player:spellSlot(3).level > 0 then
        damage = RWlvlDmg[player:spellSlot(3).level] + (common.GetTotalAP() * .75) or 0
        return common.CalculateMagicDamage(target, damage)
    end
end

local function reDmg(target)
    if player:spellSlot(3).level > 0 then
        damage = (RElvlDmg[player:spellSlot(3).level] + (common.GetTotalAP() * .4)) or 0
        return common.CalculateMagicDamage(target, damage)
    end
end

local function wUsed() 
	if player:spellSlot(1).name == "LeblancWReturn" then 
		return true
	else 
		return false
	end
end

local function oncreateobj(object)
	if object and object.name:find("W_return_indicator") then
        leblancW[object.ptr] = object
        LW = true
    end
end


local function ondeleteobj(object)
    if object and object.name:find("W_return_indicator") then
        leblancW[object.ptr] = nil
        LW = false
    end
end

local function CastQ(target)
	if player.path.serverPos:dist(target.path.serverPos) < 710 and player:spellSlot(0).state == 0 then
		player:castSpell("obj", 0, target)
	end
end

local function CastRQ(target)
	if player.path.serverPos:dist(target.path.serverPos) < 710 and player:spellSlot(3).state == 0 and player:spellSlot(3).name == "LeblancRQ" then
		player:castSpell("obj", 3, target)
	end
end

local function CastW(target)
	if not wUsed() or not leblancW then
		if player:spellSlot(1).state == 0 and player.path.serverPos:distSqr(target.path.serverPos) < (750 * 750) then
			local res = preds.circular.get_prediction(wPred, target)
			if res and res.startPos:dist(res.endPos) < 800 and not navmesh.isWall(vec3(res.endPos.x, game.mousePos.y, res.endPos.y)) then
				player:castSpell("pos", 1, vec3(res.endPos.x, game.mousePos.y, res.endPos.y))
			end
		end
	end
end

local function CastRW(target)
	if player:spellSlot(3).state == 0 and player.path.serverPos:distSqr(target.path.serverPos) < (750 * 750) and player:spellSlot(3).name == "LeblancRW" then
		local res = preds.circular.get_prediction(wPred, target)
		if res and res.startPos:dist(res.endPos) < 750 and not navmesh.isWall(vec3(res.endPos.x, game.mousePos.y, res.endPos.y)) then
			player:castSpell("pos", 3, vec3(res.endPos.x, game.mousePos.y, res.endPos.y))
		end
	end
end

local function CastE(target)
	if player:spellSlot(2).state == 0 and player.path.serverPos:dist(target.path.serverPos) < 865 then
		local seg = preds.linear.get_prediction(ePred, target)
		if seg and seg.startPos:dist(seg.endPos) < 865 then
			if not preds.collision.get_prediction(ePred, seg, target) then
				player:castSpell("pos", 2, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
			end
		end
	end
end

local function CastRE(target)
	if player:spellSlot(3).state == 0 and player.path.serverPos:dist(target.path.serverPos) < 865 and player:spellSlot(3).name == "LeblancRE" then
		local seg = preds.linear.get_prediction(ePred, target)
		if seg and seg.startPos:dist(seg.endPos) < 865 then
			if not preds.collision.get_prediction(ePred, seg, target) then
				player:castSpell("pos", 3, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
			end
		end
	end
end

local function CastGPW(target)
	if player:spellSlot(1).name == "LeblancWReturn" then return end
	if not wUsed() then
		if vec3(target.x, target.y, target.z):dist(player) < 1200 and target.pos:dist(player.pos) > 700 and not wUsed() and player:spellSlot(1).state == 0 and not navmesh.isWall(target.pos) then
			if player:spellSlot(1).name == "LeblancW" then
				player:castSpell("pos", 1, target.pos)
			end
		end
	end
end

local function CastGPR(target)
	if player:spellSlot(0).state == 0 and vec3(target.x, target.y, target.z):dist(player) < 1200 and target.pos:dist(player.pos) > 700 and player:spellSlot(3).state == 0 and player:spellSlot(3).name == "LeblancRW" and not navmesh.isWall(target.pos) then
		player:castSpell("pos", 3, target.pos)
	end
end

local function Combo()
	local wPriority = (player:spellSlot(1).level > player:spellSlot(0).level) or false
	if menu.combo.comboGap1:get() then
		local target = get_target(select_gaptarget)
		if target and common.IsValidTarget(target) and not common.CheckBuff(target, "sionpassivezomie") then
			local d = player.path.serverPos:dist(target.path.serverPos)
			if d <= 1300 and not wPriority then
				if not wUsed() then
					if target.pos:dist(player.pos) < 600 and player:spellSlot(1).state == 0 and not LW then
						CastW(target)
					elseif player:spellSlot(1).name == "LeblancW" and not LW then
						if not wUsed() or not leblancW then
							if player:spellSlot(1).state == 0 and player.path.serverPos:distSqr(target.path.serverPos) < (1200 * 1200) then
								local res = preds.circular.get_prediction(wPred, target)
								if res and res.startPos:dist(res.endPos) < 1200 and not navmesh.isWall(vec3(res.endPos.x, game.mousePos.y, res.endPos.y)) then
									player:castSpell("pos", 1, vec3(res.endPos.x, game.mousePos.y, res.endPos.y))
								end
							end
						end
					end
				end
				if menu.combo.q:get() and d <= 710 then
					CastQ(target)
				end
				if menu.combo.r:get() and d <= 710 and player:spellSlot(0).state == 32 then
					CastRQ(target)
				end
				if menu.combo.e:get() and d <= 865 and player:spellSlot(3).state == 32 or common.CheckBuff(target, "LeblancQMark") then
					CastE(target)
				end
			elseif d <= 1200 and wPriority then
				if not wUsed() or not leblancW then
					if player:spellSlot(0).state == 0 and vec3(target.x, target.y, target.z):dist(player) < 1200 and d > 700 and not wUsed() and player:spellSlot(1).state == 0 then
						player:castSpell("pos", 1, target.pos) 
					elseif d < 600 and player:spellSlot(1).state == 0 then
						CastW(target)
					end
				end
				if menu.combo.r:get() and d <= 750 and LW then
					CastRW(target)
				end
				if menu.combo.q:get() and d <= 700 and RW then
					CastQ(target)
				end
				if menu.combo.e:get() and d <= 865 and RW or common.CheckBuff(target, "LeblancQMark")then
					CastE(target)
				end
			end
		end
	elseif not menu.combo.comboGap1:get() then
		local target = get_target(select_target)
		if target and common.IsValidTarget(target) and not common.CheckBuff(target, "sionpassivezomie") then
			local d = player.path.serverPos:dist(target.path.serverPos)
			if d <= 865 and not wPriority then
				if menu.combo.e:get() then
					CastE(target)
				end
				if menu.combo.q:get() and d <= 710 and player:spellSlot(2).state ~= 0 then
					CastQ(target)
				end
				if menu.combo.r:get() and d <= 710 and player:spellSlot(3).name == "LeblancRQ" and common.CheckBuff(target, "LeblancQMark")then
					CastRQ(target)
				end
				if menu.combo.w:get() and d <= 750 and common.CheckBuff(target, "LeblancRQMark") or common.CheckBuff(target, "LeblancQMark")then
					CastW(target)
				end
			elseif d <= 865 and wPriority then
				if menu.combo.w:get() and d <= 750 then
					CastW(target)
				end
				if menu.combo.r:get() and d <= 750 and LW then
					CastRW(target)
				end
				if menu.combo.q:get() and d <= 700 and player.levelRef < 6 then
					CastQ(target)
				elseif menu.combo.q:get() and player:spellSlot(3).state ~= 0 then
					common.DelayAction(function() CastQ(target) end, 0.4)
				end
				if menu.combo.e:get() and common.CheckBuff(target, "LeblancQMark")or player:spellSlot(0).state ~= 0 then
					CastE(target)
				end
				if player:spellSlot(1).state ~= 0 or player:spellSlot(2).state ~= 0 then
					CastRQ(target)
				end
			end
			if common.CountEnemyHeroesInRange(300, target.pos) > 2 then
				CastW(target)
				if wUsed() then
					CastRW(target)
				end
			end
		end
	end
end

local function Harass()
	if player.par / player.maxPar * 100 >= menu.harass.Mana:get() then
		local target = get_target(select_target)
		if target and common.IsValidTarget(target) and not common.CheckBuff(target, "sionpassivezomie") then
			if menu.harass.mode:get() == 1 then
				CastQ(target)
			elseif menu.harass.mode:get() == 2 then
				CastQ(target)
				if player:spellSlot(0).state ~= 0 and player.path.serverPos:dist(target.path.serverPos) <= 700 then
					common.DelayAction(function() CastW(target) end, 0.2)
				end
			elseif menu.harass.mode:get() == 3 then
				CastE(target)
				if common.CheckBuff(target, "leblanceroot") then
					CastQ(target)
					if common.CheckBuff(target, "LeblancQMark")then
						CastW(target)
					end
				end
			end
			if not menu.harass.smartW:get() and wUsed() then
				player:castSpell("pos", 1, player.pos)
			end
		end
	end
end

local function KillSteal()
	for i = 0, objManager.enemies_n - 1 do
		local enemy = objManager.enemies[i]
		if enemy and menu.auto.uks:get() and common.IsValidTarget(enemy) and not common.CheckBuff(enemy,"sionpassivezombie") then
			local d = player.path.serverPos:distSqr(enemy.path.serverPos)
			local q, ql = player:spellSlot(0).state == 0, player:spellSlot(0).level > 0
			local w, wl = player:spellSlot(1).state == 0, player:spellSlot(1).level > 0
			local e, el = player:spellSlot(2).state == 0, player:spellSlot(2).level > 0
			local r, rl = player:spellSlot(3).state == 0, player:spellSlot(3).level > 0
			local hp = enemy.health
			local WQRange = 1300
			local WWQRange = 1900
			if player:spellSlot(0).level > 0 and hp < qDmg(enemy) and d < (WWQRange * WWQRange) and d > (WQRange+5 * WQRange+5) then
	  			CastQ(enemy)
	  		elseif player:spellSlot(0).level > 0 and hp < qDmg(enemy) and d < (710 * 710) then
	  			CastQ(enemy)
	  		elseif ql and w and hp < qDmg(enemy) and d < (WQRange * WQRange) and d > (710 * 710) then
	  			CastGPW(enemy)
	  			CastQ(enemy)
	  		elseif ql and w and rl and hp < qDmg(enemy) and d < (WWQRange * WWQRange) and d > (WQRange+5 * WQRange+5) then
	  				CastGPW(enemy)
		  			if d < 1900 * 1900 then
		  				CastGPR(enemy)
		  				CastQ(enemy)
		  			end
   			elseif wl and hp < wDmg(enemy) and d < (750 * 750) then 
   				CastW(enemy)
   			elseif el and hp < eDmg(enemy) and d < (865 * 865) then
   				CastE(enemy)
   			elseif el and wl and ql and hp < eDmg(enemy) + qDmg(enemy)*1.5 and d > (750 * 750) and d < (WQRange * WQRange) then
   				if not wUsed() then
   					CastGPW(enemy)
   				end
   				CastE(enemy)
   				CastQ(enemy)
   			elseif ql and rl and hp < qDmg(enemy) + rqDmg(enemy) and d < (710 * 710) and common.CheckBuff(enemy, "LeblancRQMark") then
   				CastQ(enemy)
   			elseif rl and player:spellSlot(3).name == "LeblancRQ" and menu.auto.uksr:get() and hp < rqDmg(enemy) * 2 and d < (710 * 710) then
   				CastRQ(enemy)
   			elseif rl and player:spellSlot(3).name == "LeblancRQ" and menu.auto.uksr:get() and d < (710 * 710) and hp < rqDmg(enemy) + qDmg(enemy) * 2 and common.CheckBuff(enemy, "LeblancQMark") then
   				CastRQ(enemy)
   			elseif rl and player:spellSlot(3).name == "LeblancRW" and menu.auto.uksr:get() and hp < rwDmg(enemy) and d < (700 * 700) then
   				CastRW(enemy)
   			elseif rl and ql and wl and menu.auto.uksr:get() and hp < (qDmg(enemy)*2+rqDmg(enemy)) and d < (WQRange * WQRange) and d > (700 * 700) then
   				if not wUsed then
   					CastGPW(enemy)
   				end
   				CastQ(enemy)
   				CastRQ(enemy)
   			elseif rl and q and w and menu.auto.uksr:get() and hp < (qDmg(enemy)+wDmg(enemy)+rwDmg(enemy)) and d < (700 * 700) then
   				CastQ(enemy)
   				CastW(enemy)
   				if wUsed then
   					CastRW(enemy)
   				end
			end
		end
	end
end

local function Chainz()
	if menu.keys.c:get() then
		local target = get_target(select_target)
		player:move((game.mousePos))
		if target and target.pos:dist(player.pos) < 865 then
			if player:spellSlot(2).state == 0 then
				CastE(target)
			end
			if common.CheckBuff(target, "leblanceroot") then
				CastRE(target)
			end
		end
	end
end

local function smartW()
    if wUsed() and leblancW then
    	local target = get_target(select_gaptarget)
        if common.GetEnemyHeroesInRange(600, leblancW.pos) < common.GetEnemyHeroesInRange(600, player.pos) then
            if target and common.IsValidTarget(target) and player:spellSlot(0).level > 0 and player:spellSlot(1).level > 0 and player:spellSlot(2).level > 0 and player:spellSlot(3).level > 0 then
                if target.health > (qDmg(target) + wDmg(target) + eDmg(target)+ rqDmg(target) + 500) then
                    player:castSpell("pos", 1, player.pos)
                end
            end
        end
    end
end

local function OnTick()
	if orb.combat.is_active() then
		Combo()
	end
	if menu.combo.smartW:get() then smartW() end
	if menu.harass.smartW:get() then smartW() end
	if menu.auto.uks:get() then
		KillSteal()
	end
	if orb.menu.hybrid.key:get() then
		Harass()
	end
	if menu.keys.c:get() then Chainz() 
	end	

end

local function OnDraw()
	if menu.draws.q:get() and player:spellSlot(0).state == 0 and player.isOnScreen then
		graphics.draw_circle(player.pos, 700, 2, graphics.argb(255, 7, 141, 237), 50)
	end
	if menu.draws.e:get() and player:spellSlot(2).state == 0 and player.isOnScreen then
		graphics.draw_circle(player.pos, 865, 2, graphics.argb(255, 255, 112, 255), 50)
	end
	if leblancW then
		graphics.draw_circle(leblancW.pos, 260, 2, graphics.argb(255, 248, 131, 121), 50)
	end
	if leblancRW then
		graphics.draw_circle(leblancRW.pos, 260, 2, graphics.argb(255, 248, 70, 121), 50)
	end
	 if menu.draws.ds:get() and player:spellSlot(3).level > 0 then
        local pos = graphics.world_to_screen(vec3(player.x-20, player.y, player.z-50))
        if menu.combo.comboGap1:get() then
           graphics.draw_text_2D("Gapclosing: On", 15, pos.x, pos.y, graphics.argb(255, 51, 255, 51))
        else
           graphics.draw_text_2D("Gapclosing: Off", 15, pos.x, pos.y, graphics.argb(255, 255, 30, 30))
        end
     end
end

orb.combat.register_f_pre_tick(OnTick)
cb.add(cb.draw, OnDraw)
cb.add(cb.create_particle, oncreateobject)
cb.add(cb.delete_particle, ondeleteobject)