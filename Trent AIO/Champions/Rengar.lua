local orb = module.internal("orb")
local evade = module.seek('evade')
local preds = module.internal('pred')
local ts = module.internal('TS')
local common = module.load(header.id, 'common2')
--local crashreporter = module.load(header.id, 'crashreporter')
if player.charName ~= "Rengar" then
    print("not using rengar not loading")
    return
end
local menu = menu("Trent_Rengarlel", "Trent Rengar")

menu:menu("keys", "Key Settings")
menu.keys:keybind("combokey", "Combo Key", "Space", nil)
menu.keys:keybind("harasskey", "Harass Key", "C", nil)
menu.keys:keybind("clearkey", "Lane Clear Key", "V", nil)
menu.keys:keybind("lastkey", "Last Hit", "X", nil)

menu:menu("combo", "Combo Settings")
menu.combo:header("xd", "Q Settings")
menu.combo:boolean("q", "Use Q", true)

menu.combo:header("xd", "W Settings")
menu.combo:boolean("w", "Use W", true)

menu.combo:header('xd', "E Settings")
menu.combo:boolean("e", "Use E", true)

menu:menu("laneclear", "Laneclear Settings")
menu.laneclear:header("xd", "Q Settings")
menu.laneclear:boolean("q", "Use Q", true)

menu:menu("junglefarm", "Jungle Farm Settings")
menu.junglefarm:header("xd", "Q Settings")
menu.junglefarm:boolean("q", "Use Q", true)
menu.junglefarm:boolean("w", "Use W in Jungle", true)
menu.junglefarm:boolean("e", "Use E in Jungle", true)


local spellE = {
    range = 1000, 
    width = 50,
    radius = 60, 
    speed = 1500, 
    delay = 0.25, 
    boundingRadiusMod = 1,
    collision = true
}

local TargetSelectionE = function(res, obj, dist)
	if dist <= spellE.range then
		res.obj = obj
		return true
	end
end

local GetTargetE = function()
	return ts.get_result(TargetSelectionE).obj
end

local selectTarget = function(res, obj, dist)
    if dist > 1000 then return end
    res.obj = obj
    return true
end

local function getTarget() return ts.get_result(selectTarget).obj end

local trace_filter = function(input, segment, target)
    if segment.startPos:dist(segment.endPos) > spellE.range then return false end -- Checking before spellcast to see if our projected segment end is out of range if not return 
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

            if not trace_filter(spellE, pos, target) then return end 

            player:castSpell("pos", 2,
                             vec3(pos.endPos.x, mousePos.y, pos.endPos.y)) 

        end
    end
end

local function validFarmTargetJungle(minion)
    for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
        local obj = objManager.minions[TEAM_NEUTRAL][i]
        if player.pos:dist(obj) <= 900 then
            if obj.isVisible and obj.isTargetable and obj.health >= 1 and
                common.IsValidTarget(obj) then
                if player.pos:dist(obj) <= player.attackRange + player.boundingRadius + 25 then

                    player:castSpell('self', _Q)

                end
                if player.pos:dist(obj) <= player.attackRange + player.boundingRadius then

                    player:castSpell('self', _W)

                end
                if player.pos:dist(obj) <= 1000 then

                    player:castSpell('pos', _E, obj.pos)

                end
            end
        end
    end
end

local function validTurd(minion)
    if not minion then return false end
    if minion.isDead then return false end
    if minion.pos:dist(player.pos) >
        (player.attackRange + player.boundingRadius + 25) then return false
    end
end

local function validFarmTarget(minion)
    if not orb.menu.lane_clear.key:get() and not orb.menu.last.key:get() then
        return
    end
    for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
        local minion = objManager.minions[TEAM_ENEMY][i]
        if validTurd(minion) then
            player:castSpell('self', _Q)
        end
    end
end

--[[orb.combat.register_f_after_attack(
    function()
        if not orb.core.can_attack() and menu.keys.combokey:get() then
            if orb.combat.target then
                if
                    orb.combat.target and common.IsValidTarget(orb.combat.target) and
                        player.pos:dist(orb.combat.target.pos) < common.GetAARange(orb.combat.target)
                 then
                    if menu.combo.q:get() and player:spellSlot(0).state == 0 then
                        player:castSpell("self", 1)
                        orb.combat.set_invoke_after_attack(false)
                        return "kek"
                    end
                end
            end
        end
    end
)--]]

local function Combo(target)
    local target = getTarget()
    if player:spellSlot(_Q).state == 0 and player.pos:dist(target.pos) <= common.GetAARange(target) and menu.combo.q:get() then
        player:castSpell("self", 0)
    end

    if player:spellSlot(_W).state == 0 and player:spellSlot(_Q).state ~= 0 and player.pos:dist(target.pos) <= 300 and menu.combo.w:get() then
        player:castSpell("self", 1)
    end

    if player:spellSlot(_E).state == 0 and player:spellSlot(_Q).state ~= 0 
    and player:spellSlot(_W).state ~= 0 and player.pos:dist(target.pos) <= spellE.range and menu.combo.e:get() then
            epred()
    end
end

menu:menu('range', 'Spell Range')
menu.range:boolean('q_range', 'Draw Q range', true)
menu.range:boolean('w_range', 'Draw W range', true)
menu.range:boolean('e_range', 'Draw E range', true)
menu.range:boolean('r_range', 'Draw R range', true)
menu.range:color('c1', 'Color Q ', 255, 89, 14, 199)
menu.range:color('c2', 'Color W', 255, 255, 14, 199)
menu.range:color('c3', 'Color E', 255, 89, 255, 199)
menu.range:boolean('disable_drawings', 'Disable Drawings', false)

cb.add(cb.draw, function()
local color1 = menu.range.c1:get()
local color2 = menu.range.c2:get()
local color3 = menu.range.c3:get()
if menu.range.disable_drawings:get() then return end
if menu.range.q_range:get() then
    graphics.draw_circle(player.pos,
    player.attackRange + player.boundingRadius + 25, 2,
                             color1, 55)
end
if menu.range.w_range:get() then
    graphics.draw_circle(player.pos, 450, 2, color2, 55)
end
if menu.range.e_range:get() then
    graphics.draw_circle(player.pos, spellE.range, 2, color3, 55)
end
end)

cb.add(cb.tick, function()
    if menu.keys.clearkey:get() then 
        validFarmTargetJungle() 
        validFarmTarget()
    end

    if menu.keys.combokey:get() then
        local target = getTarget()
        if target then Combo(target) end
    end
end)

--orb.combat.register_f_pre_tick(OnTick)
chat.add('[Trent]', {color = '#17fa50', bold = true})
chat.add(' Private Rengar Loaded', {color = '#8Ff750', bold = true})
chat.print()