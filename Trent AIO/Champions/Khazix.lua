local orb = module.internal("orb")
local evade = module.seek('evade')
local pred = module.internal('pred')
local ts = module.internal('TS')
local common = module.load(header.id, 'common2')
local crashreporter = module.load(header.id, 'crashreporter')
if player.charName ~= "Khazix" then
    print("not using Kha not loading")
    return
end
local menu = menu("Trent_Kha'Zixlel", "Trent Kha'Zix")

menu:header('header_keys', 'Combat')
menu:keybind('combat', 'Combat Key', 'Space', nil)
menu:keybind('farm', 'Farm Key', 'V', nil)

menu:menu('q', 'Q')
menu.q:boolean('enable_q', "Use Q", true)
menu.q:boolean('qfarm', 'Q Jungle Mobs', true)
menu.q:slider('mana_farmq', 'Q Farm Mana  <= ', 50, 1, 100, 5)

menu:menu('w', 'W')
menu.w:boolean('enable_w', 'Use W', true)
menu.w:boolean('wfarm', 'W Jungle Mobs', true)
menu.w:slider('mana_farmw', 'W Farm Mana >=', 50, 1, 100, 5)

menu:menu('e', 'E')
menu.e:boolean('enable_e', 'Use E', true)
menu.e:dropdown('e_mode', 'E Mode', 2, {"Mouse Pos", "With Prediction"})
menu.e:boolean('efarm', 'E Jungle Mobs', false)
menu.e:slider('mana_farme', 'E Farm Mana  <=', 50, 1, 100, 5)

menu:menu('r', 'R')
menu.r:boolean('enable_r', 'Use R', true)
menu.r:dropdown('r_mode', 'Ultimate Mode', 2, {'Always Ultimate', 'Smart Ultimate'})

menu:menu('ks', 'KS Settings')
menu.ks:boolean('sks', "Use Smart killsteal", true)
menu.ks:boolean('eks', 'Use E in Killsteal', false)
menu.ks:slider('hpe', 'Min HP to E', 30, 0, 100, 10)

menu:menu('range', 'Spell Range')
menu.range:boolean('q_range', 'Draw Q range', true)
menu.range:boolean('w_range', 'Draw W range', true)
menu.range:boolean('e_range', 'Draw E range', true)
menu.range:boolean('r_range', 'Draw R range', true)
menu.range:color('c1', 'Color Q ', 255, 89, 14, 199)
menu.range:color('c2', 'Color W', 255, 255, 14, 199)
menu.range:color('c3', 'Color E', 255, 89, 255, 199)
menu.range:color('c4', 'Color R', 144, 89, 14, 199)
menu.range:boolean('disable_drawings', 'Disable Drawings', false)

local q = {Range = 325}
local w = {Range = 1025}
local e = {Range = 700}

local QlvlDmg = {60, 85, 110, 135, 160}
local WlvlDmg = {85, 115, 145, 165, 205}
local ElvlDmg = {65, 100, 135, 170, 205}
local IsoDmg = {14, 20, 26, 32, 38, 44, 50, 56, 62, 68, 74, 80, 86, 92, 98, 104, 110, 116}
local QRange, ERange = 0, 0
local Isolated = false

local selectTarget = function(res, obj, dist)
    if dist > 1000 then return end
    res.obj = obj
    return true
end

local function getTarget() return ts.get_result(selectTarget).obj end

local function IsReady(spell) return player:spellSlot(spell).state == 0 end

local PredW = {
    range = 1000,
    width = 70,
    speed = 1650,
    delay = 0.25,
    boundingRadiusMod = 1,
    collision = {hero = true, minion = true, wall = true}
}

local PredE = {
    range = 700,
    radius = 320,
    speed = 1400,
    delay = 0.25,
    boundingRadiusMod = 0,
    collision = {hero = false, minion = false, wall = false}
}

local Isolated = nil

local function GetPercentHealth(obj)
    local obj = obj or player
    return (obj.health / obj.maxHealth) * 100
end

local function IsValidTarget(object)
	return (object and not object.isDead and object.isVisible and object.isTargetable) --and not CheckBuffType(object, 17))--
end

local function PhysicalReduction(target, damageSource)
	local damageSource = damageSource or player
	local armor = ((target.bonusArmor * damageSource.percentBonusArmorPenetration) + (target.armor - target.bonusArmor)) * damageSource.percentArmorPenetration
	local lethality = (damageSource.physicalLethality * .4) + ((damageSource.physicalLethality * .6) * (damageSource.levelRef / 18))
	return armor >= 0 and (100 / (100 + (armor - lethality))) or (2 - (100 / (100 - (armor - lethality))))
end

local function DamageReduction(damageType, target, damageSource)
	local damageSource = damageSource or player
	local reduction = 1
	if damageType == "AD" then
	end

	if damageType == "AP" then
	end
	return reduction
end

local function CalculatePhysicalDamage(target, damage, damageSource)
	local damageSource = damageSource or player
	if target then
		return (damage * PhysicalReduction(target, damageSource)) * DamageReduction("AD", target, damageSource)
	end
	return 0
end

local function GetBonusAD(obj)
	local obj = obj or player
	return ((obj.baseAttackDamage + obj.flatPhysicalDamageMod) * obj.percentPhysicalDamageMod) - obj.baseAttackDamage
end 

local function qDmg(target)
    local damage = QlvlDmg[player:spellSlot(0).level] + (GetBonusAD() * 1.15)
    if Isolated then
    damage = damage + damage
    end
    return CalculatePhysicalDamage(target, damage)
end

local function wDmg(target)
    local damage = WlvlDmg[player:spellSlot(1).level] + (GetBonusAD() * 1)
    return CalculatePhysicalDamage(target, damage)
end

local function eDmg(target)
	local damage = ElvlDmg[player:spellSlot(2).level] + (GetBonusAD() * 0.2)
	return CalculatePhysicalDamage(target, damage)
end

local function CastE(target)
	if player:spellSlot(_E).state == 0 then
		if player:spellSlot(_E).name == "KhazixE" then
			local res = pred.circular.get_prediction(PredE, target)
			if res and res.startPos:dist(res.endPos) < 600 and res.startPos:dist(res.endPos) > 325  then
				player:castSpell("pos", _E, vec3(res.endPos.x, game.mousePos.y, res.endPos.y))
			end
		elseif player:spellSlot(_E).name == "KhazixELong" then
			local res = pred.circular.get_prediction(PredE, target)
			if res and res.startPos:dist(res.endPos) < 900 and res.startPos:dist(res.endPos) > 400 then
				player:castSpell("pos", _E, vec3(res.endPos.x, game.mousePos.y, res.endPos.y))
			end
		end
	end
end

local function CastW(target)
	if player:spellSlot(_W).state == 0 then
		local seg = pred.linear.get_prediction(PredW, target)
		if seg and seg.startPos:dist(seg.endPos) < 970 then
			if not pred.collision.get_prediction(PredW, seg, target) then
				player:castSpell("pos", _W, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
			end
		end
	end
end

local function CastR()
	if player:spellSlot(_R).state == 0 then
		player:castSpell("self", _R)
	end
end

local function CastQ(target)
	if player:spellSlot(_Q).state == 0 then
		if player:spellSlot(_Q).name == "KhazixQ" then
			if target.pos:dist(player.pos) <= 325 then
				player:castSpell("obj", _Q, target)
			end
		elseif player:spellSlot(_Q).name == "KhazixQLong" then
			if target.pos:dist(player.pos) then
				player:castSpell("obj", _Q, target)
			end
		end
	end
end

local function PlayerAD()
	if Isolated == false then
    	return player.flatPhysicalDamageMod + player.baseAttackDamage
    else
    	return player.flatPhysicalDamageMod + player.baseAttackDamage + (IsoDmg[player.levelRef] + player.flatPhysicalDamageMod * .2 )
    end
end

local function KillSteal()
	for i = 0, objManager.enemies_n - 1 do
		local enemy = objManager.enemies[i]
		if not enemy.isDead and enemy.isVisible and enemy.isTargetable and menu.ks.sks:get() then
			local hp = enemy.health
			if hp == 0 then return end
			if player:spellSlot(_Q).state == 0 and qDmg(enemy) + PlayerAD() > hp and enemy.pos:dist(player.pos) < 325 then
				CastQ(enemy)
			elseif player:spellSlot(_W).state == 0 and wDmg(enemy) > hp and enemy.pos:dist(player.pos) < 960 then
				CastW(enemy)
			elseif player:spellSlot(_W).state == 0 and player:spellSlot(_Q).state == 0 and wDmg(enemy) + qDmg(enemy) > hp and enemy.pos:dist(player.pos) < 500 then
				CastQ(enemy)
				CastW(enemy)
			elseif player:spellSlot(_E).state == 0 and player:spellSlot(_Q).state == 0 and qDmg(enemy) + eDmg(enemy) + PlayerAD() > hp and menu.ks.eks:get() and GetPercentHealth(player) >= menu.ks.hpe:get() and enemy.pos:dist(player.pos) < 990 then
				CastE(enemy)
				CastQ(enemy)
			elseif player:spellSlot(_W).state == 0 and player:spellSlot(_Q).state == 0 and player:spellSlot(_E).state == 0 and qDmg(enemy) + eDmg(enemy) + wDmg(enemy) + PlayerAD() > hp and menu.ks.eks:get() and GetPercentHealth(player) >= menu.ks.hpe:get() and enemy.pos:dist(player.pos) < 990 then
				CastE(enemy)
				CastQ(enemy)
				if enemy.pos:dist(player.pos) <= 700 then
					CastW(enemy)
				end
			end
		end
	end
end

local function Combo()
	local target = getTarget()
	if target and IsValidTarget(target) then
		if menu.e.enable_e:get() then
			if menu.e.e_mode:get() == 1 then
				if player:spellSlot(_E).state == 0 and target.pos:dist(player.pos) <= 700 then
					common.DelayAction(function()player:castSpell("pos", 2, (game.mousePos)) end, 0.2)
				end
			elseif menu.e.e_mode:get() == 2 then
				CastE(target)
			end
		end
		if menu.q.enable_q:get() then
			CastQ(target)
		end
		if menu.w.enable_w:get() and target.pos:dist(player.pos) >= 470 then
			CastW(target)
		elseif menu.w.enable_w:get() and Isolated == true or player:spellSlot(_Q).state ~= 0 then
			CastW(target)
		end
		if menu.r.enable_r:get() and player:spellSlot(_R).state == 0 then
			if menu.r.r_mode:get() == 2 then
				if player:spellSlot(_W).state == 0 and player:spellSlot(_Q).state == 0 and player:spellSlot(_E).state == 0 and target.health <= ((qDmg(target)*2) + wDmg(target) + eDmg(target)) and target.health > (wDmg(target) + eDmg(target)) then
	                if target.pos:dist(player.pos) <= 900 then
	                    if player:spellSlot(_E).state == 0 then CastR() end
	                end
	            end
	        elseif menu.r.r_mode:get() == 1 then
	            if target.pos:dist(player.pos) <= 500 then 
	                if player:spellSlot(_E).state == 0 then CastR() end
	            end
	        end
		end
	end
end

local function validFarmTargetJungle(minion)
    for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
        local obj = objManager.minions[TEAM_NEUTRAL][i]
        if player.pos:dist(obj) <= 350 then
            if obj.isVisible and obj.isTargetable and obj.health >= 1 and
                common.IsValidTarget(obj) then
                if player.pos:dist(obj) <= 325 then

                    player:castSpell('obj', _Q, obj)

                end
                if player.pos:dist(obj) <= 350 then

                    player:castSpell('pos', _W, obj.pos)

                end
            end
        end

    end
end

local function Evoluir()
    if player:spellSlot(0).name == "KhazixQ" then
        QRange = 325
    elseif player:spellSlot(0).name == "KhazixQLong" then
    	QRange = 375
    end 
    if player:spellSlot(2).name == "KhazixE" then
        ERange = 700
    elseif player:spellSlot(2).name == "KhazixELong" then
    	ERange = 900
    end 
end

--[[local function ObjCreat(obj)
    if obj and obj.name and obj.type then
        if obj.name:find("SingleEnemy_Indicator") then
            Isolated = true
        end
    end
end

local function ObjDelete(obj)
	local obj = Isolated
    if obj and obj.name and obj.type then
    	if obj.name:find("SingleEnemy_Indicator") then
            Isolated = false
        end
    end
end--]]

local function OnTick()
	KillSteal()
    if orb.combat.is_active() then 
        Combo() 
    end
    if menu.range.q_range:get() or menu.range.e_range:get() then 
        Evoluir() 
    end
	if orb.menu.lane_clear:get() then
		validFarmTargetJungle()
	end
end

cb.add(cb.draw, function()
    local color1 = menu.range.c1:get()
    local color2 = menu.range.c2:get()
    local color3 = menu.range.c3:get()
    local color4 = menu.range.c4:get()
    if menu.range.disable_drawings:get() then return end
    if menu.range.q_range:get() then
        graphics.draw_circle(player.pos,
                             800, 2,
                             color1, 55)
    end
    if menu.range.q_range:get() then
        graphics.draw_circle(player.pos, 325, 2, color1, 55)
    if menu.range.w_range:get() then
        graphics.draw_circle(player.pos, 1025, 2, color2, 55)
    end
    if menu.range.e_range:get() then
        graphics.draw_circle(player.pos, 700, 2, color3, 55)
    end
end
end)

chat.add('[Trent]', {color = '#17fa50', bold = true})
chat.add(' Private Kha Loaded', {color = '#8Ff750', bold = true})
chat.print()

orb.combat.register_f_pre_tick(OnTick)
cb.add(cb.create_particle, ObjCreat)
cb.add(cb.delete_particle, ObjDelete)
cb.add(cb.draw, OnDraw)