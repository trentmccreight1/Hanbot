local orb = module.internal("orb")
local evade = module.seek('evade')
local gpred = module.internal('pred')
local ts = module.internal('TS')
local common = module.load(header.id, 'common2')
local crashreporter = module.load(header.id, 'crashreporter')

if player.charName ~= "RekSai" then
    print("not using rek not loading")
    return
end
local menu = menu("Trent_RekSaixdd", "Trent RekSai")

menu:menu("keys", "Key Settings")
menu.keys:keybind("combokey", "Combo Key", "Space", nil)
menu.keys:keybind("harasskey", "Harass Key", "C", nil)
menu.keys:keybind("clearkey", "Lane Clear Key", "V", nil)
menu.keys:keybind("lastkey", "Last Hit", "X", nil)
menu.keys:keybind("run", "Flee", "Z", false)

menu:menu("combo", "Combo Settings")
menu.combo:header("xd", "Q Settings")
menu.combo:boolean("q", "Use Q", true)
menu.combo:slider('q_range', 'Q Range <= ', 700, 300, 1450, 1)
menu.combo:dropdown("modeq", "Choose Mode: ", 2, {"Before AA", "After AA"})

menu.combo:header("xd", "E Settings")
menu.combo:boolean("e", "Use E", true)
menu.combo:dropdown("modee", "Choose Mode: ", 1, {"After Q", "During Q", "Rage on 100"})
menu.combo:keybind('eflash', 'E Flash Key', 'A', nil)

menu.combo:header("xd", "R Settings")
menu.combo:boolean("r", "Use R", false)
menu.combo:slider("rx", "Max. Enemys in Range", 2, 0, 5, 1)

menu:menu("jg", "Jungle Clear Settings")
menu.jg:header("xd", "Jungle Settings")
menu.jg:boolean("q", "Use Q", true)
menu.jg:boolean("e", "Use E", true)

menu:menu("auto", "Killsteal Settings")
menu.auto:header("xd", "KillSteal Settings")
menu.auto:boolean("uks", "Use Killsteal", true)
menu.auto:boolean("ksq", "Use Q in Killsteal", true)
menu.auto:boolean("kse", "Use E in Killsteal", true)
menu.auto:boolean("ksr", "Use R in Killsteal", true)

menu:menu("draws", "Draw Settings")
menu.draws:header("xd", "Drawing Options")
menu.draws:boolean("q", "Draw Q Range", true)
menu.draws:boolean("e", "Draw R Range", true)
menu.draws:boolean("drawdamage", "Draw Damage", true)

local FlashSlot = nil
if player:spellSlot(4).name == "SummonerFlash" then
	FlashSlot = 4
elseif player:spellSlot(5).name == "SummonerFlash" then
	FlashSlot = 5
end

local enemies = common.GetEnemyHeroes()
local UG = false
local QAA = false
local minionmanager = objManager.minions

local QlvlDmg = {20, 25, 30, 35, 40}
local Q2lvlDmg = {60, 90, 120, 150, 180}
local ElvlDmg = {55, 65, 75, 85, 95}
local RlvlDmg = {100, 250, 400}
local RHPDmg = {20, 25, 30}
local qPred = { delay = 0.5, width = 60, speed = 1950, boundingRadiusMod = 1, collision = { hero = true, minion = true } }

local function select_target(res, obj, dist)
	if dist > 325 then return end
	res.obj = obj
	return true
end

local function select_Etarget(res, obj, dist)
	if dist > 750 then return end
	res.obj = obj
	return true
end

local function select_Qtarget(res, obj, dist)
	if dist > menu.combo.q_range:get() then return end
	res.obj = obj
	return true
end

local function get_target(func)
	return ts.get_result(func).obj
end


local function Buff()
	if player.buff["reksaiw"] then
		UG = true
	else
		UG = false
	end
	if player.buff["reksaiq"] then
		QAA = true
	else
		QAA = false
	end
end

local function qDmg(target)
  local damage = Q2lvlDmg[player:spellSlot(0).level] + (common.GetTotalAP() * .7)
  local damage2 = (common.GetBonusAD() * 0.4)
  	return common.CalculatePhysicalDamage(target, damage2) + common.CalculateMagicDamage(target, damage)
end

local function rDmg(target)
    local damage = (RlvlDmg[player:spellSlot(3).level] + (common.GetBonusAD() * 1.85) ) + ((RHPDmg[player:spellSlot(3).level]/100) * (target.maxHealth - target.health))
    return common.CalculatePhysicalDamage(target, damage)
end

local function eDmg(target)
	if player.mana == 100 then
		local damage = (ElvlDmg[player:spellSlot(2).level] + (common.GetBonusAD() * 0.85))*2
	    return common.CalculatePhysicalDamage(target, damage)
	else
		local damage = ElvlDmg[player:spellSlot(2).level] + (common.GetBonusAD() * 0.85)
    	return common.CalculatePhysicalDamage(target, damage)
    end
end

local function Combo()
	if not UG then
		local target = get_target(select_target)
		if target and common.IsValidTarget(target) then
			if menu.combo.q:get() and player:spellSlot(0).state == 0 and player.path.serverPos:dist(target.path.serverPos) <= player.attackRange + player.boundingRadius then
				if player:spellSlot(0).name == "RekSaiQ" then
					if menu.combo.modeq:get() == 1 then
						player:castSpell("self", 0)
					end
				end
			end
			if menu.combo.e:get() and player:spellSlot(2).state == 0 and player.path.serverPos:dist(target.path.serverPos) <= 315 then
				if menu.combo.modee:get() == 1 and not QAA and player:spellSlot(0).state ~= 0 then
					player:castSpell("obj", 2, target)
				elseif menu.combo.modee:get() == 2 and QAA then
					player:castSpell("obj", 2, target)
				elseif menu.combo.modee:get() == 3 and player.mana == 100 then
					player:castSpell("obj", 2, target)
				end
			end
			if player:spellSlot(0).state ~= 0 and player:spellSlot(2).state ~= 0 and player.path.serverPos:dist(target.path.serverPos) <= 250 and player:spellSlot(1).state == 0 and not QAA then
				player:castSpell("self", 1)
			end
		end
	end
	if UG then
		local target = get_target(select_Qtarget)
		if target and common.IsValidTarget(target) then
			if menu.combo.q:get() and player:spellSlot(0).state == 0 and player:spellSlot(0).name == "RekSaiQBurrowed" then
				if player.path.serverPos:dist(target.path.serverPos) < menu.combo.q_range:get() then
					local seg = gpred.linear.get_prediction(qPred, target)
					if seg and seg.startPos:dist(seg.endPos) < menu.combo.q_range:get() then
						if not gpred.collision.get_prediction(qPred, seg, target) then
							player:castSpell("pos", 0, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
						end
					end
				end
			end
		end
	end
	if UG then
		local target = get_target(select_Etarget)
		if target then
			calairtime = (player.pos:dist(target) / (player.moveSpeed * 2)) + 0.25
			local predpos = gpred.core.get_pos_after_time(target, calairtime)
			if predpos then
				formateedpredpos = vec3(predpos.x, mousePos.y, predpos.y)
				if player:spellSlot(_E).name ~= "RekSaiE" then
					player:castSpell("pos", _E, formateedpredpos )
				end
			end
		end
	end
end

local TargetSelectionFE = function(res, obj, dist)
	if dist < 1350 then
		res.obj = obj
		return true
	end
end
local GetTargetFE = function()
	return ts.get_result(TargetSelectionFE).obj
end

local function FlashE()
    if not menu.combo.eflash:get() then
		--print("Flash E is disabled")
        return
    end
    player:move(vec3(mousePos.x, mousePos.y, mousePos.z))
    if not FlashSlot
    or player:spellSlot(_E).name == "RekSaiE"
    or not player:spellSlot(FlashSlot).state == 0 then
		--print('Flash E not ready')
        return
    end
	
    local target = GetTargetFE()
    if not target
    or not common.IsValidTarget(target) then
        return
    end
    local dist = target.pos:dist(player.pos)
    if dist > 1350 then
    --or dist <= 750 then
        return
    end
    calairtime = (player.pos:dist(target) / (player.moveSpeed * 2)) + 0.25
    local predpos = gpred.core.get_pos_after_time(target, calairtime)
    if not predpos then
        return
    end
    formateedpredpos = vec3(predpos.x, mousePos.y, predpos.y) 
    player:castSpell("pos", _E, formateedpredpos)
    
	common.DelayAction(
        function()
           -- print('2')
            player:castSpell("pos", FlashSlot, target.pos)
			--print('we flashed')
        end,
        0.25
    )
end

local function KillSteal()
	for i = 0, objManager.enemies_n - 1 do
		local enemy = objManager.enemies[i]
 		if enemy and common.IsValidTarget(enemy) and not enemy.buff["sionpassivezombie"] then
  			if menu.auto.ksq:get() and player:spellSlot(0).state == 0 and UG and enemy.health < qDmg(enemy) and player.path.serverPos:dist(enemy.path.serverPos) < 1450 and player:spellSlot(0).name == "RekSaiQBurrowed" then
	  			local seg = gpred.linear.get_prediction(qPred, enemy)
				if seg and seg.startPos:dist(seg.endPos) < 1450 then
					if not gpred.collision.get_prediction(qPred, seg, enemy) then
						player:castSpell("pos", 0, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
					end
				end
	  		end
	  		if menu.auto.kse:get() and player:spellSlot(2).state == 0 and enemy.health < eDmg(target) and player.path.serverPos:dist(enemy.path.serverPos) < 315 then
	  			player:castSpell("obj", 2, enemy)
	  		end
   			if menu.auto.ksr:get() and player:spellSlot(3).state == 0 and enemy.health < rDmg(enemy) and player.path.serverPos:dist(enemy.path.serverPos) < 1500 then
   				if enemy.buff["reksairprey"] then
   					player:castSpell("obj", 3, enemy)
   				elseif not enemy.buff["reksairprey"] and player:spellSlot(0).state == 0 and UG and player:spellSlot(0).name == "RekSaiQBurrowed" and player.path.serverPos:dist(enemy.path.serverPos) < 1450 then
   					local seg = gpred.linear.get_prediction(qPred, enemy)
					if seg and seg.startPos:dist(seg.endPos) < 1450 then
						if not gpred.collision.get_prediction(qPred, seg, enemy) then
							player:castSpell("pos", 0, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
						end
					end
				elseif not UG and player:spellSlot(0).name == "RekSaiQ" and player:spellSlot(1).state == 0 then
					player:castSpell("self", 1)
				end   				
   			end
  		end
 	end
end

local function Clear()
	local target = { obj = nil, health = 0, mode = "jungleclear" }
	local aaRange = player.attackRange + player.boundingRadius + 200
	for i = 0, minionmanager.size[TEAM_NEUTRAL] - 1 do
		local obj = minionmanager[TEAM_NEUTRAL][i]
		if player.pos:dist(obj.pos) <= aaRange and obj.maxHealth > target.health then
			target.obj = obj
			target.health = obj.maxHealth
		end
	end
	if target.obj then
		if target.mode == "jungleclear" then
			if not UG then
				if menu.jg.q:get() and player:spellSlot(0).state == 0 and player.path.serverPos:dist(target.obj.path.serverPos) <= player.attackRange + player.boundingRadius and player:spellSlot(0).name == "RekSaiQ" then
					player:castSpell("self", 0)
				end
				if menu.jg.e:get() and player:spellSlot(2).state == 0 and player.path.serverPos:dist(target.obj.path.serverPos) < 315 then
					if not QAA and player:spellSlot(0).state ~= 0 and player.mana == 100 then
						player:castSpell("obj", 2, target.obj)
					end
				end
				if player:spellSlot(0).state ~= 0 and player:spellSlot(2).state ~= 0 and player.path.serverPos:dist(target.obj.path.serverPos) <= 250 and player:spellSlot(1).state == 0 and not QAA then
					player:castSpell("self", 1)
				end
			end
			if UG then
				if menu.jg.q:get() and player:spellSlot(0).state == 0 and player:spellSlot(0).name == "RekSaiQBurrowed" then
					if player.path.serverPos:dist(target.obj.path.serverPos) < 1450 then
						local seg = gpred.linear.get_prediction(qPred, target.obj)
						if seg and seg.startPos:dist(seg.endPos) < 1450 then
							if not gpred.collision.get_prediction(qPred, seg, target.obj) then
								player:castSpell("pos", 0, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))
							end
						end
					end
				end
			end
		end
	end
end

local function Run()
	if menu.keys.run:get() then
		player:move(vec3(mousePos.x, mousePos.y, mousePos.z))
		if player:spellSlot(2).state == 0 then
			if UG then
				player:castSpell("pos", 2, vec3(mousePos.x, mousePos.y, mousePos.z))
			else
				player:castSpell("self", 1)
			end
		end
	end
end

local function on_create_particle(obj)
    local name = obj.name
    if name:find('RekSai_.*_W_tar_TremorSense_Champion') then
        print('found enemy!')
    end
end
cb.add(cb.create_particle, on_create_particle)

local function OnTick()
	if orb.combat.is_active() then Combo() end
	if orb.menu.lane_clear.key:get() then Clear() end
	if menu.auto.uks:get() then KillSteal() end
	if menu.keys.run:get() then Run() end
	Buff()
	FlashE()
end

--[[function DrawDamagesE(target)
	if target.isVisible and not target.isDead then
		local pos = graphics.world_to_screen(target.pos)
		if
			(math.floor(
				(rDmg(target) + eDmg(target) + qDmg(target)) / target.health * 100
			) < 100)
		 then
			graphics.draw_line_2D(pos.x, pos.y - 30, pos.x + 30, pos.y - 80, 1, graphics.argb(255, 255, 153, 51))
			graphics.draw_line_2D(pos.x + 30, pos.y - 80, pos.x + 50, pos.y - 80, 1, graphics.argb(255, 255, 153, 51))
			graphics.draw_line_2D(pos.x + 50, pos.y - 85, pos.x + 50, pos.y - 75, 1, graphics.argb(255, 255, 153, 51))

			graphics.draw_text_2D(
				tostring(
					"R: " .. math.floor(rDmg(target) + eDmg(target) + qDmg(target))
				) ..
					" (" ..
						tostring(
							math.floor(
								(rDmg(target) + eDmg(target) + qDmg(target)) / target.health * 100
							)
						) ..
							"%)" .. "Not Killable",
				20,
				pos.x + 55,
				pos.y - 80,
				graphics.argb(255, 255, 153, 51)
			)
		end
		if
			(math.floor(
				(rDmg(target) + eDmg(target) + qDmg(target)) / target.health * 100
			) >= 100)
		 then
			graphics.draw_line_2D(pos.x, pos.y - 30, pos.x + 30, pos.y - 80, 1, graphics.argb(255, 150, 255, 200))
			graphics.draw_line_2D(pos.x + 30, pos.y - 80, pos.x + 50, pos.y - 80, 1, graphics.argb(255, 150, 255, 200))
			graphics.draw_line_2D(pos.x + 50, pos.y - 85, pos.x + 50, pos.y - 75, 1, graphics.argb(255, 150, 255, 200))
			graphics.draw_text_2D(
				tostring(
					"R: " .. math.floor(rDmg(target) + eDmg(target) + qDmg(target))
				) ..
					" (" ..
						tostring(
							math.floor(
								(rDmg(target) + eDmg(target) + qDmg(target)) / target.health * 100
							)
						) ..
							"%)" .. "Kilable",
				20,
				pos.x + 55,
				pos.y - 80,
				graphics.argb(255, 150, 255, 200)
			)
		end
	end
end--]]


local function OnDraw()
	if menu.draws.q:get() and player:spellSlot(0).state == 0 and player.isOnScreen then
		if player:spellSlot(0).name == "RekSaiQ" then
			graphics.draw_circle(player.pos, 320, 2, graphics.argb(255, 255, 255, 255), 70)
		elseif player:spellSlot(0).name == "RekSaiQBurrowed" then
			graphics.draw_circle(player.pos, 1450, 2, graphics.argb(255, 255, 255, 255), 70)
		end
	end
	if menu.draws.e:get() and player:spellSlot(3).state == 0 and player.isOnScreen then
		graphics.draw_circle(player.pos, (1500), 2, graphics.argb(255, 255, 255, 255), 70)
	end
	--[[if menu.draws.drawdamage:get() then
		local enemy = common.GetEnemyHeroes()
		for i, enemies in ipairs(enemy) do
			if
				enemies and common.IsValidTarget(enemies) and player.pos:dist(enemies) < 1000 and
					not common.CheckBuffType(enemies, 17)
			 then
				DrawDamagesE(enemies)
			end
		end
	end--]]
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