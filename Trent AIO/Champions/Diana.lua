local orb = module.internal("orb")
local evade = module.seek('evade')
local preds = module.internal('pred')
local ts = module.internal('TS')
local common = module.load(header.id, 'common2')
local crashreporter = module.load(header.id, 'crashreporter')
if player.charName ~= "Diana" then
    print("not using Diana not loading")
    return
end
local menu = menu("Trent_Diana", "Trent Diana")

menu:header('header_keys', 'Combat')
menu:keybind('combat', 'Combat Key', 'Space', nil)
menu:keybind('farm', 'Farm Key', 'V', nil)

menu:menu('q', 'Q')
menu.q:boolean('enable_q', "Use Q", true)
menu.q:boolean('qfarm', 'Q Jungle Mobs', true)
menu.q:slider('mana_farmq', 'Q Farm Mana  <= ', 50, 1, 100, 5)
menu.q:boolean('qks', 'Use Q in Killsteal', true)

menu:menu('w', 'W')
menu.w:boolean('enable_w', 'Use W', true)
menu.w:boolean('wfarm', 'W Jungle Mobs', true)
menu.w:slider('mana_farmw', 'W Farm Mana >=', 50, 1, 100, 5)

menu:menu('e', 'E')
menu.e:boolean('enable_e', 'Use E', true)
menu.e:boolean('efarm', 'E Jungle Mobs', false)
menu.e:slider('mana_farme', 'E Farm Mana  <=', 50, 1, 100, 5)
menu.e:boolean('eks', 'Use E in Killsteal', true)

menu:menu('r', 'R')
menu.r:boolean('enable_r', 'Use R', true)
menu.r:slider('enemy_count', 'Enemy Count <=', 3, 1, 5, 1)
menu.r:boolean('rks', 'Use R in Killsteal', true)

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

local spellQ = {
    range = 900, 
    radius = 150, 
    speed = 1900, 
    delay = 0.25, 
    boundingRadiusMod = 1
}
local spellW = {range = 250}
local spellE = {range = 825}
local spellR = {range = 450}

local TargetSelectionQ = function(res, obj, dist)
	if dist <= spellQ.range then
		res.obj = obj
		return true
	end
end

local GetTargetQ = function()
	return ts.get_result(TargetSelectionQ).obj
end
local TargetSelectionW = function(res, obj, dist)
	if dist <= spellW.range then
		res.obj = obj
		return true
	end
end
local GetTargetW = function()
	return ts.get_result(TargetSelectionW).obj
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

local TargetSelectionR = function(res, obj, dist)
	if dist <= spellR.range then
		res.obj = obj
		return true
	end
end
local GetTargetR = function()
	return ts.get_result(TargetSelectionR).obj
end

local trace_filter = function(input, segment, target)
   if segment.startPos:dist(segment.endPos) > spellQ.range then return false end -- Checking before spellcast to see if our projected segment end is out of range if not return 
   if preds.trace.circular.hardlock(input, segment, target) then return true end -- checking cc status if so send it no real pred needed
   if preds.trace.circular.hardlockmove(input, segment, target) then -- checking cc status if so send it no real pred needed
       return true
   end
   if preds.trace.newpath(target, 0.033, 0.5) then return true end -- Kiri path strictness :omegalul:
end

local function qpred()

   local target = GetTargetQ() 
   if common.IsValidTarget(target) then 

      local pos = preds.circular.get_prediction(spellQ, target)
      if pos and player.pos:to2D():dist(pos.endPos) < spellQ.range then

           if not trace_filter(spellQ, pos, target) then return end 

           player:castSpell("pos", 0,
                            vec3(pos.endPos.x, mousePos.y, pos.endPos.y)) 

       end
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

local waiting = 0
local uhhh = 0
local enemy = nil

local QLevelDamage = {60, 95, 130, 165, 200}
function QDamage(target)
	local damage = 0
	if player:spellSlot(0).level > 0 then
		damage =
		common.CalculateMagicDamage(target,(QLevelDamage[player:spellSlot(0).level] +(common.GetTotalAP() * .7)), player)
	end
	return damage
end

local ELevelDamage = {40, 60, 80, 100, 120}
function EDamage(target)
	local damage = 0
	if player:spellSlot(1).level > 0 then
		damage =
		common.CalculateMagicDamage(target,(ELevelDamage[player:spellSlot(2).level] +(common.GetTotalAP() * .4)), player)
	end
	return damage
end

local RLevelDamage = {200, 300, 400}
function RDamage(target)
	local damage = 0
	if player:spellSlot(3).level > 0 then
		damage =
		common.CalculateMagicDamage(target,(RLevelDamage[player:spellSlot(3).level] +(common.GetTotalAP() * .6)), player)
	end
	return damage
end

local function validFarmTargetJungle(minion)
    for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
        local obj = objManager.minions[TEAM_NEUTRAL][i]
        if player.pos:dist(obj) <= 900 then
            if obj.isVisible and obj.isTargetable and obj.health >= 1 and
                common.IsValidTarget(obj) then
                if player.pos:dist(obj) <= 900 then

                    player:castSpell('pos', _Q, obj.pos)

                end
                if player.pos:dist(obj) <= 250 then

                    player:castSpell('self', _W)

                end
                if player.pos:dist(obj) <= 825 and (common.CheckBuff(obj, "dianamoonlight")) then

                    player:castSpell('obj', _E, obj)
                end
            end
        end
    end
end

local function Combo()
    if menu.q.enable_q:get() then
         qpred()
      end
    if menu.w.enable_w:get() then
    local target = GetTargetW()
       if common.IsValidTarget(target) and target then
          if (target.pos:dist(player) < spellW.range) then
             player:castSpell("self", _W)
          end
       end
    end
    if menu.r.enable_r:get() then
    local target = GetTargetR()
       if common.IsValidTarget(target) and target then
          if enemiesnearenemies(target.pos,400) >= menu.r.enemy_count:get() then
             player:castSpell("self", _R)
          end
       end
    end
    if menu.e.enable_e:get() then
    local target = GetTargetE()
       if common.IsValidTarget(target) and target then
          if (target.pos:dist(player) <= spellE.range) and (common.CheckBuff(target, "dianamoonlight")) then
             player:castSpell("obj", _E, target)
          end
       end
    end	  
end

local function KillSteal()
    local enemy = common.GetEnemyHeroes()
       for i, enemies in ipairs(enemy) do
          if enemies and common.IsValidTarget(enemies) and not common.CheckBuffType(enemies, 17) then
          local hp = common.GetShieldedHealth("AP", enemies)
             if menu.q.qks:get() then
                if player:spellSlot(_Q).state == 0 and QDamage(enemies) >= hp then
                local pos = preds.circular.get_prediction(spellQ, enemies)
                   if pos and pos.startPos:dist(pos.endPos) < spellQ.range then
                      player:castSpell("pos", _Q, vec3(pos.endPos.x, mousePos.y, pos.endPos.y))
                   end
                end
             end
             if menu.e.eks:get() then
                if player:spellSlot(_E).state == 0 and EDamage(enemies) >= hp then
                   if (enemies.pos:dist(player) <= spellE.range) then
                      player:castSpell("obj", _E, enemies)
                   end
                end
             end
             if menu.r.rks:get() then
                if player:spellSlot(_R).state == 0 and RDamage(enemies) >= hp then
                   if (enemies.pos:dist(player) <= spellR.range) then
                      player:castSpell("self", _R)
                   end
                end
             end
        end
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
                             900, 2,
                            color1, 55)
    end
    if menu.range.w_range:get() then
        graphics.draw_circle(player.pos, 250, 2, color2, 55)
    end
    if menu.range.e_range:get() then
        graphics.draw_circle(player.pos, 825, 2, color3, 55)
    end
    if menu.range.r_range:get() then
        graphics.draw_circle(player.pos, 450, 2, color4, 55)
    end
end)

cb.add(cb.tick, function()
    if menu.farm:get() then 
        validFarmTargetJungle() 
    end

    if menu.combat:get() then
       Combo()
    end

    KillSteal()
end)