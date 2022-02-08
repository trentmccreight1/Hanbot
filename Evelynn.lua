local orb = module.internal("orb")
local evade = module.seek('evade')
local preds = module.internal('pred')
local ts = module.internal('TS')
local common = module.load(header.id, 'common2')
local crashreporter = module.load(header.id, 'crashreporter')

if player.charName ~= "Evelynn" then
    print("not using eve not loading")
    return
end
local menu = menu("Trent_Evelynnxdd", "Trent Evelynn")

menu:header('header_keys', 'Combat')
menu:keybind('combat', 'Combat Key', 'Space', nil)
menu:keybind('farm', 'Farm Key', 'V', nil)

menu:menu('q', 'Q')
menu.q:boolean('enable_q', "Use Q", true)
menu.q:boolean('qfarm', 'Q Jungle Mobs', true)
menu.q:slider('mana_farmq', 'Q Farm Mana  <= ', 50, 1, 100, 5)
--[[ menu.q:slider('mana_farmq', 'Q Farm Mana  <= ', 50, 1, 100, 5)
 ]]
menu:menu('w', 'W')
menu.w:boolean('enable_w', 'Use W', false)
menu.w:slider('w_range', 'W Range <= ', 750, 300, 1200, 1)
menu:menu('e', 'E')
menu.e:boolean('enable_e', 'Use E', true)
menu.e:boolean('efarm', 'E Jungle Mobs', true)
menu.e:slider('mana_farme', 'E Farm Mana  <= ', 50, 1, 100, 5)
--[[ menu.e.slider('mana_farme', 'E Farm Mana <=', 50, 1, 100, 5) ]]

menu:menu('r', 'R')
menu.r:boolean('enable_r', 'Use R', true)

local q = {Range = 800}
local w = {Range = menu.w.w_range:get() or 1200}
local e = {Range = 280}
local r = {Range = 500}

local RlvlDmg = {125, 250, 375}

local selectTarget = function(res, obj, dist)
    if dist > 1200 then return end
    res.obj = obj
    return true
end

local function getTarget() return ts.get_result(selectTarget).obj end

local function getPercentHealth(obj)
    local obj = obj or player
    return (obj.health / obj.maxHealth) * 100
end

local function IsReady(spell) return player:spellSlot(spell).state == 0 end

local RlvlDmg2 = {300, 600, 900}
local function rDmg(target)
    if player:spellSlot(_R).level > 0 and IsReady(_R) then
        local damage = RlvlDmg[player:spellSlot(_R).level] +
                           (common.GetTotalAP() * .75) or 0
        local damage2 = RlvlDmg2[player:spellSlot(_R).level] +
                            (common.GetTotalAP() * 1.8) or 0

        if common.GetPercentHealth(target) <= 30 then
            print("EXTRA damage", common.CalculateMagicDamage(target, damage2))
            return common.CalculateMagicDamage(target, damage2)

        end
        print("normal damage", common.CalculateMagicDamage(target, damage))
        return common.CalculateMagicDamage(target, damage)
    else
        return 0
    end
end

local spellQ = {
    range = 800,
    width = 60,
    speed = 2400,
    delay = 0.25,
    boundingRadiusMod = 0,
    collision = {hero = true, minion = true, wall = true}
}

local TargetSelectionQ = function(res, obj, dist)
    if dist <= spellQ.range then
        res.obj = obj
        return true
    end
end
local GetTargetQ = function() return ts.get_result(TargetSelectionQ).obj end
local trace_filter = function(input, segment, target)
    if segment.startPos:dist(segment.endPos) > spellQ.range then return false end -- Checking before spellcast to see if our projected segment end is out of range if not return 
    if preds.trace.linear.hardlock(input, segment, target) then return true end -- checking cc status if so send it no real pred needed
    if preds.trace.linear.hardlockmove(input, segment, target) then -- checking cc status if so send it no real pred needed
        return true
    end
    if preds.trace.newpath(target, 0.033, 0.5) then return true end -- Kiri path strictness :omegalul:
end

local spellR = {
    range = 500,
    width = 100,
    speed = math.huge,
    delay = 0.35,
    boundingRadiusMod = 0,
    collision = {hero = false, minion = false, wall = false}
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

local function qpred()

    local target = GetTargetQ() -- grab target
    if common.IsValidTarget(target) then -- check if valid target

        local pos = preds.linear.get_prediction(spellQ, target) -- generate initial pred params 
        if pos and pos.startPos:dist(pos.endPos) <= spellQ.range then -- do soft range change 

            if not trace_filter(spellQ, pos, target) then return end -- check if filter is returning true 

            player:castSpell("pos", 0,
                             vec3(pos.endPos.x, mousePos.y, pos.endPos.y)) -- casting spell 

        end
    end
end

local function rpred()

    local target = GetTargetR() -- grab target
    if common.IsValidTarget(target) then -- check if valid target

        local pos = preds.linear.get_prediction(spellR, target) -- generate initial pred params 
        if pos and pos.startPos:dist(pos.endPos) <= spellR.range then -- do soft range change 

            if not trace_filter(spellR, pos, target) then return end -- check if filter is returning true 

            player:castSpell("pos", _R,
                             vec3(pos.endPos.x, mousePos.y, pos.endPos.y)) -- casting spell 

        end
    end
end
function SpecialBuffCheck(object)
    local buff1 = object.buff.gwenw
    local buff2 = object.buff.judicatorintervention
    local buff3 = object.buff.kayler
    local buff4 = object.buff.undyingrage
    local buff5 = object.buff.sionpassivezombie
    local buff6 = object.buff.taricr
    local buff7 = object.buff.chronoshift
    local buff8 = object.buff.kindredr
    if object.buff[BUFF_UNKILLABLE] or object.buff[BUFF_INVULNERABILITY] then
        return true
    end
    if buff1 then return true end
    if buff2 then return true end
    if buff3 then return true end
    if buff4 then return true end
    if buff5 then return true end
    if buff6 then return true end
    if buff7 then return true end
    if buff8 then return true end

    return false
end
local function checkcharmbuffready(obj)
    if obj then
        if obj.buff.evelynnw then
            local timetopop = obj.buff.evelynnw.startTime + 2.5
            if timetopop <= game.time then
                print('charm ready ')
                return true
            end
        else
            return false
        end
        return false
    end
    return false
end
local function checkcharmbuff(obj)
    if obj then
        if obj.buff.evelynnw then
            return true
        else
            return false
        end
        return false
    end
    return false
end

local delayxdd = 0 
local function Should_Q(target) 
    if checkcharmbuffready(target) then 
        print('Charm is ready to pop!') 
        return true
    end
    if checkcharmbuff(target) then 
        print('Charm found.. Not ready ')
        return false
    end


    if player:spellSlot(_W).level <= 0 then 
        print('Not possible to Charm ')
        
        return true
    end



    if not menu.w.enable_w:get() then 
        print('Auto Charm is off.')
       
        return true
    end

    if delayxdd <= game.time then
        print('W was just casted waiting for the buff to travel through time and space before doing this func..?')
        if player:spellSlot(_W).state ~= 0 then 
            print('Charm is down')
            
            return true
        end
    end
end
local function on_process_spell(spell) 
    if spell.name == 'EvelynnW' and spell.owner == player then
        delayxdd = game.time + 0.35
    end
end

local function KS()
    if player:spellSlot(_R).state == 0 then
        for i = 0, objManager.enemies_n - 1 do
            local enemy = objManager.enemies[i]
            if common.IsValidTarget(enemy) and enemy then
                if enemy.pos:dist(player.pos) <= 500 then
                    hp = enemy.health + enemy.magicalShield + enemy.allShield
                    if player:spellSlot(_R).level > 0 and hp <= rDmg(enemy) and
                        menu.r.enable_r:get() then

                        if SpecialBuffCheck(enemy) then
                            return
                        end

                        rpred()

                    end
                end
            end
        end
    end
end

local function validTurd(minion)
    if not minion then return false end
    if minion.isDead then return false end
    if minion.pos:dist(player.pos) >
        (550) then return false
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
        if player.pos:dist(obj) <= 1200 then
            if obj.isVisible and obj.isTargetable and obj.health >= 1 and
                common.IsValidTarget(obj) then
                if player.pos:dist(obj) <= 800 then

                    player:castSpell('pos', _Q, obj.pos)

                end
                if player.pos:dist(obj) <= 300 then

                    player:castSpell('obj', _E, obj)

                end
            end
        end

    end
end

cb.add(cb.spell, on_process_spell)
local function combo(target)
    if
        player:spellSlot(_Q).state == 0 and player.pos:dist(target.pos) <= 800 and menu.q.enable_q:get() and
            player:spellSlot(_Q).name == 'EvelynnQ'
     then
        if Should_Q(target) then
            qpred()
            return true
        end
    else
        if player:spellSlot(_Q).name ~= 'EvelynnQ' then
            if player:spellSlot(_Q).state == 0 and menu.q.enable_q:get() then
                if Should_Q(target) then
                    player:castSpell('self', _Q)
                    return true
                end
            end
        end
    end
    if
        player:spellSlot(_W).state == 0 and (player.pos:dist(target.pos) <= menu.w.w_range:get() or
            1200) and menu.w.enable_w:get()
     then
        player:castSpell('obj', _W, target)
    end

    if player:spellSlot(_E).state == 0 and player.pos:dist(target.pos) <= 300 and menu.e.enable_e:get() then
        player:castSpell('obj', _E, target)
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

    KS()
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
                         800, 2,
                         color1, 55)
end
if menu.range.w_range:get() then
    graphics.draw_circle(player.pos, 1200, 2, color2, 55)
end
if menu.range.e_range:get() then
    graphics.draw_circle(player.pos, 300, 2, color3, 55)
end
if menu.range.r_range:get() then
    graphics.draw_circle(player.pos, 500, 2, color4, 55)
end
end)
chat.add('[Trent]', {color = '#17fa50', bold = true})
chat.add(' Private Eve Loaded', {color = '#8Ff750', bold = true})
chat.print()
