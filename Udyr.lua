local orb = module.internal("orb")
local evade = module.seek('evade')
local preds = module.internal('pred')
local ts = module.internal('TS')
local common = module.load(header.id, 'common2')
local crashreporter = module.load(header.id, 'crashreporter')
if player.charName ~= "Udyr" then
    print("not using Udyr not loading")
    return
end
local menu = menu("Trent_Udyr", "Trent Udyr")

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
menu.w:slider("whp", " ^- Priority W if X Health", 30, 0, 100, 1)

menu:menu('e', 'E')
menu.e:boolean('enable_e', 'Use E', true)

menu:menu('r', 'R')
menu.r:boolean('enable_r', 'Use R', true)
menu.r:boolean('rfarm', 'R Jungle Mobs', true)
menu.r:slider('mana_farmr', 'R Farm Mana  <=', 50, 1, 100, 5)

menu:menu('rotation', 'Rotation')
menu.rotation:dropdown('cstance', 'Combo Rotation', 1, {"E > R > W > Q", "E  > Q > R > W"})
menu.rotation:dropdown('fstance', 'Farm Rotation', 2, {"R > W > R", "Q > R > W"})

menu:menu("flee", "Flee")
menu.flee:boolean("stune", "Stun with E while Fleeing", true)
menu.flee:keybind("fleekey", "Flee Key", "Z", nil)

menu:menu("draws", "Draw Settings")
menu.draws:boolean("drawe", "Draw E Engage Range", true)
menu.draws:color("colore", "  ^- Color", 255, 255, 255, 255)

local spellQ = {}

local spellW = {}

local spellE = {
	range = 800
}

local spellR = {}

local TargetSelection = function(res, obj, dist)
	if dist < spellE.range then
		res.obj = obj
		return true
	end
end

local GetTarget = function()
	return ts.get_result(TargetSelection).obj
end
local TargetSelectionW = function(res, obj, dist)
	if dist < 270 then
		res.obj = obj
		return true
	end
end

local GetTargetW = function()
	return ts.get_result(TargetSelectionW).obj
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

local function Combo()
    if
		menu.w.enable_w:get() and menu.w.whp:get() >= (player.health / player.maxHealth) * 100 and
			player:spellSlot(1).state == 0
	 then
		local target = GetTargetW()
		if target then
			if common.IsValidTarget(target) then
				player:castSpell("self", 1)
			end
		end
	end
	if menu.e.enable_e:get() and player:spellSlot(2).state == 0 then
		local target = GetTarget()
		if target then
			if common.IsValidTarget(target) and target.pos:dist(player.pos) > 250 then
				player:castSpell("self", 2)
			--	return meow
			end
		end
	end

	if menu.e.enable_e:get() and player:spellSlot(2).state == 0 then
		local target = GetTarget()
		if target then
			if
				common.IsValidTarget(target) and
					(common.CheckBuff(player, "UdyrPhoenixStance") ~= 3 or
						(common.CheckBuff(player, "UdyrPhoenixStance") == 3 and target.pos:dist(player.pos) > 250)) and
					not common.CheckBuff(target, "udyrbearstuncheck")
			 then
				player:castSpell("self", 2)
			--	return meow
			end
		end
	end
	if orb.combat.target then
		if common.IsValidTarget(orb.combat.target) and player.pos:dist(orb.combat.target.pos) < 250 then
			if menu.rotation.cstance:get() == 1 then
				if menu.e.enable_e:get() and player:spellSlot(2).state == 0 then
					local target = GetTarget()
					if target then
						if
							common.IsValidTarget(target) and
								(common.CheckBuff(player, "UdyrPhoenixStance") ~= 3 or
									(common.CheckBuff(player, "UdyrPhoenixStance") == 3 and target.pos:dist(player.pos) > 250)) and
								not common.CheckBuff(target, "udyrbearstuncheck")
						 then
							player:castSpell("self", 2)
						--	return meow
						end
					end
				end
				local target = GetTargetW()
                if target then
					if orb.core.can_attack() then
						if
							common.CheckBuff(target, "udyrbearstuncheck") or player:spellSlot(2).level == 0 or
								menu.e.enable_e:get() == false
						 then
							if menu.r.enable_r:get() and player:spellSlot(3).state == 0 then
								player:castSpell("self", 3)
								return meow
							end
							if
								(player:spellSlot(3).state ~= 0 or menu.r.enable_r:get() == false) and
									common.CheckBuff(player, "UdyrPhoenixStance") ~= 3 or
									player:spellSlot(3).level == 0
							 then
								if menu.w.enable_w:get() and player:spellSlot(1).state == 0 then
									player:castSpell("self", 1)
									return meow
								end
							end
							if
								(player:spellSlot(1).state ~= 0 or menu.w.enable_w:get() == false) and
									common.CheckBuff(player, "UdyrPhoenixStance") ~= 3 or
									player:spellSlot(1).level == 0
							 then
								if menu.q.enable_q:get() and player:spellSlot(0).state == 0 then
									player:castSpell("self", 0)
									return meow
								end
							end
						end
					end
				end
			end
            if menu.rotation.cstance:get() == 2 then
				local target = GetTargetW()

				if target then
					if
						common.CheckBuff(target, "udyrbearstuncheck") or player:spellSlot(2).level == 0 or
							menu.e.enable_e:get() == false
					 then
						if orb.core.can_attack() then
							if menu.q.enable_q:get() and player:spellSlot(0).state == 0 then
								player:castSpell("self", 0)
								return meow
							end
							if (player:spellSlot(0).state ~= 0 or menu.q.enable_q:get() == false) or player:spellSlot(0).level == 0 then
								if menu.r.enable_r:get() and player:spellSlot(3).state == 0 then
									player:castSpell("self", 3)
									return meow
								end
							end
							if
								(player:spellSlot(3).state ~= 0 or menu.r.enable_r:get() == false) and
									common.CheckBuff(player, "UdyrPhoenixStance") ~= 3 or
									player:spellSlot(3).level == 0
							 then
								if menu.w.enable_w:get() and player:spellSlot(1).state == 0 then
									player:castSpell("self", 1)
									return meow
								end
							end
						end
					end
				end
			end
		end
	end
end

local function JungleClear()
	if orb.core.can_attack() then
		if menu.rotation.fstance:get() == 1 then
			for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
				local minion = objManager.minions[TEAM_NEUTRAL][i]
				if
					minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
						minion.pos:dist(player.pos) < 300
				 then
					if (player.buff["udyrbearstance"] and minion.buff["udyrbearstuncheck"]) or player.buff["udyrbearstance"] == nil then
						if menu.r.rfarm:get() and player:spellSlot(3).state == 0 then
							if minion.pos:dist(player.pos) < 300 and player:spellSlot(3).state == 0 then
								player:castSpell("self", 3)
								return meow
							end
						end
						if player:spellSlot(3).state ~= 0 and common.CheckBuff(player, "UdyrPhoenixStance") == 1 then
							if minion.pos:dist(player.pos) < 300 then
								if menu.w.wfarm:get() and player:spellSlot(1).state == 0 then
									player:castSpell("self", 1)
									return meow
								end
							end
						end
					end
				end
			end
		end
		if menu.rotation.fstance:get() == 2 then
			for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
				local minion = objManager.minions[TEAM_NEUTRAL][i]
				if
					minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
						minion.pos:dist(player.pos) < 300
				 then
					if (player.buff["udyrbearstance"] and minion.buff["udyrbearstuncheck"]) or player.buff["udyrbearstance"] == nil then
						if menu.q.qfarm:get() then
							if minion.pos:dist(player.pos) < 300 and player:spellSlot(0).state == 0 then
								player:castSpell("self", 0)
								return meow
							end
						end
						if player:spellSlot(0).state ~= 0 or player:spellSlot(0).level == 0 then
							if minion.pos:dist(player.pos) < 300 then
								if menu.r.rfarm:get() and player:spellSlot(3).state == 0 then
									player:castSpell("self", 3)
									return meow
								end
							end
						end
						if
							player:spellSlot(3).state ~= 0 and common.CheckBuff(player, "UdyrPhoenixStance") == 1 or
								player:spellSlot(3).level == 0
						 then
							if menu.w.wfarm:get() then
								if minion.pos:dist(player.pos) < 300 and player:spellSlot(1).state == 0 then
									player:castSpell("self", 1)
									return meow
								end
							end
						end
					end
				end
			end
		end
	end
end

local function count_minions_in_range(pos, range)
	local enemies_in_range = {}
	for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
		local enemy = objManager.minions[TEAM_ENEMY][i]
		if pos:dist(enemy.pos) < range and common.IsValidTarget(enemy) then
			enemies_in_range[#enemies_in_range + 1] = enemy
		end
	end
	return enemies_in_range
end

local function LaneClear()
	if orb.core.can_attack() then
		if menu.rotation.fstance:get() == 1 then
			for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
				local minion = objManager.minions[TEAM_ENEMY][i]
				if minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead then
					if menu.r.rfarm:get() and player:spellSlot(3).state == 0 then
						if minion.pos:dist(player.pos) < 300 and player:spellSlot(3).state == 0 then
							player:castSpell("self", 3)
							return meow
						end
					end
					if player:spellSlot(3).state ~= 0 and common.CheckBuff(player, "UdyrPhoenixStance") == 1 then
						if minion.pos:dist(player.pos) < 300 then
							if menu.w.wfarm:get() and player:spellSlot(1).state == 0 then
								player:castSpell("self", 1)
								return meow
							end
						end
					end
				end
			end
		end
		if menu.rotation.fstance:get() == 2 then
			for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
				local minion = objManager.minions[TEAM_ENEMY][i]
				if minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead then
					if menu.q.qfarm:get() then
						if minion.pos:dist(player.pos) < 300 and player:spellSlot(0).state == 0 then
							player:castSpell("self", 0)
							return meow
						end
					end
					if player:spellSlot(0).state ~= 0 or player:spellSlot(0).level == 0 then
						if minion.pos:dist(player.pos) < 300 then
							if menu.r.rfarm:get() and player:spellSlot(3).state == 0 then
								player:castSpell("self", 3)
								return meow
							end
						end
					end
					if
						player:spellSlot(3).state ~= 0 and common.CheckBuff(player, "UdyrPhoenixStance") == 1 and
							menu.w.wfarm:get() or
							player:spellSlot(3).level == 0
					 then
						if minion.pos:dist(player.pos) < 300 and player:spellSlot(1).state == 0 then
							player:castSpell("self", 1)
							return meow
						end
					end
				end
			end
		end
	end
end

local function OnDraw()
	if player.isOnScreen then
		if menu.draws.drawe:get() then
			graphics.draw_circle(player.pos, spellE.range, 2, menu.draws.colore:get(), 50)
		end
	end
end


cb.add(
    cb.tick,
    function()
        if menu.farm:get() then
            JungleClear()
            LaneClear()
        end

        if menu.combat:get() then
            local target = GetTarget()
            if target then
                Combo()
            end
        end
        
        if menu.flee.fleekey:get() then
            player:move(mousePos)
            if player:spellSlot(2).state == 0 then
                player:castSpell("self", 2)
            end
            if menu.flee.stune:get() then
                local target = GetTargetW()
                if target and target.pos:dist(player.pos) <= 240 then
                    if not common.CheckBuff(target, "udyrbearstuncheck") and common.CheckBuff(player, "UdyrBearStance") then
                        player:attack(target)
                    end
                end
            end
        end
    end
)

cb.add(cb.draw, OnDraw)