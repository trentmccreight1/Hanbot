local orb = module.internal("orb")
local evade = module.seek('evade')
local preds = module.internal('pred')
local ts = module.internal('TS')
local common = module.load(header.id, 'common2')
local crashreporter = module.load(header.id, 'crashreporter')
if player.charName ~= "Hecarim" then
    print("not using hec not loading")
    return
end
local menu = menu("Trent_Hecarimlel", "Trent Hecarim")

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
menu.e:boolean('efarm', 'E Jungle Mobs', true)
menu.e:slider('mana_farme', 'E Farm Mana  <=', 50, 1, 100, 5)

menu:menu('r', 'R')
menu.r:boolean('enable_r', 'Use R', true)
menu.r:slider('enemy_count', 'Enemy Count <=', 3, 1, 5, 1)

local e = {Range = (player.moveSpeed + (player.moveSpeed * 0.25)) * 2.85}
local r = {Range = 1300}

local selectTarget = function(res, obj, dist)
    if dist > 700 then return end
    res.obj = obj
    return true
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

local function getTarget() return ts.get_result(selectTarget).obj end

local function IsReady(spell) return player:spellSlot(spell).state == 0 end

local spellR = {
    range = 1300,
    width = 100,
    speed = 1200,
    delay = 0.35,
    boundingRadiusMod = 0,
    collision = {hero = false, minion = false, wall = true}
}

local TargetSelectionR = function(res, obj, dist)
    if dist <= spellR.range then
        res.obj = obj
        return true
    end
end
local GetTargetR = function() return ts.get_result(TargetSelectionR).obj end
local trace_filterR = function(input, segment, target)
    if segment.startPos:dist(segment.endPos) > spellR.range then return false end -- Checking before spellcast to see if our projected segment end is out of range if not return 

    return true
end

local function rpred()

    local target = GetTargetR() -- grab target
    if common.IsValidTarget(target) then -- check if valid target

        local pos = preds.linear.get_prediction(spellR, target) -- generate initial pred params 
        if pos and pos.startPos:dist(pos.endPos) <= spellR.range then -- do soft range change 

            if not trace_filterR(spellR, pos, target) then return end -- check if filter is returning true 

            player:castSpell("pos", _R,
                             vec3(pos.endPos.x, mousePos.y, pos.endPos.y)) -- casting spell 

        end
    end
end

local function validTurd(minion)
    if not minion then return false end
    if minion.isDead then return false end
    if minion.pos:dist(player.pos) >
        (375) then return false
    end

    if common.GetPercentMana(player) < menu.q.mana_farmq:get() then return false end
    return true
end

local function validFarmTarget(minion)
    if not orb.menu.lane_clear.key:get() and not orb.menu.last.key:get() then
        return
    end
    for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
        local minion = objManager.minions[TEAM_ENEMY][i]
        if validTurd(minion) then
            player:castSpell('pos', _Q, minion.pos)
            player:attack(minion)
        end
    end
end

local function validFarmTargetJungle(minion)
    for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
        local obj = objManager.minions[TEAM_NEUTRAL][i]
        if player.pos:dist(obj) <= 700 then
            if obj.isVisible and obj.isTargetable and obj.health >= 1 and
                common.IsValidTarget(obj) then
                if player.pos:dist(obj) <= 375 then

                    player:castSpell('self', _Q)

                end
                if player.pos:dist(obj) <= 525 then

                    player:castSpell('self', _W)

                end
                if player.pos:dist(obj) <= (player.moveSpeed + (player.moveSpeed * 0.25)) * 2.85 then

                    player:castSpell('self', _E)
                end
            end
        end
    end
end
local function combo(target)
    if target then 
    if player:spellSlot(_Q).state == 0 and player.pos:dist(target.pos) <= 375 
    and menu.q.enable_q:get() then 
    player:castSpell('self', _Q)
    end

    if player:spellSlot(_W).state == 0 and player.pos:dist(target.pos) <= 525 and 
    menu.w.enable_w:get() then 
    player:castSpell('self', _W)
    end

    if player:spellSlot(_E).state == 0 and player.pos:dist(target.pos) <= (player.moveSpeed + (player.moveSpeed * 0.25)) * 2.85 and 
    menu.e.enable_e:get() then
    player:castSpell('self', _E)
    end

    if player:spellSlot(_R).state == 0 and player.pos:dist(target.pos) <= 1300 and
    menu.r.enable_r:get() and  enemiesnearenemies(target.pos,400) >= menu.r.enemy_count:get() then
    rpred()
    end
end
end

cb.add(cb.tick, function()
    if menu.farm:get() then 
        validFarmTargetJungle() 
        validFarmTarget()
    end

    if menu.combat:get() then
        local target = getTarget()
        if target then combo(target) end
    end
end)

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

cb.add(cb.draw, function()
local color1 = menu.range.c1:get()
local color2 = menu.range.c2:get()
local color3 = menu.range.c3:get()
local color4 = menu.range.c4:get()
if menu.range.disable_drawings:get() then return end
if menu.range.q_range:get() then
    graphics.draw_circle(player.pos,
                         375, 2,
                         color1, 55)
end
if menu.range.w_range:get() then
    graphics.draw_circle(player.pos, 525, 2, color2, 55)
end
if menu.range.e_range:get() then
    graphics.draw_circle(player.pos, (player.moveSpeed + (player.moveSpeed * 0.25)) * 2.85, 2, color3, 55)
end
if menu.range.r_range:get() then
    graphics.draw_circle(player.pos, 1300, 2, color4, 55)
end
end)
chat.add('[Trent]', {color = '#17fa50', bold = true})
chat.add(' Private Hec Loaded', {color = '#8Ff750', bold = true})
chat.print()