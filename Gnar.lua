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
menu.keys:keybind("harasskey", "Harass Key", "C", nil)
menu.keys:keybind("clearkey", "Lane Clear Key", "V", nil)
menu.keys:keybind("lastkey", "Last Hit", "X", nil)
menu.keys:keybind("run", "Flee", "Z", false)

menu:menu("combo", "Combo Settings")
menu.combo:header("xd", "Q Settings")
menu.combo:boolean("q", "Use Q", true)
menu.combo:boolean("qmagnet", "Catch Q", true)
menu.combo:boolean("q2", "Use Mega Q", true)

menu.combo:header("xd", "W Settings")
menu.combo:boolean("w", "Use W", true)
menu.combo:boolean("w2", "Use Mega W", true)

menu.combo:header('xd', "E Settings")
menu.combo:boolean("e", "Use E", true)
menu.combo:boolean("e2", "Use Mega E", true)

menu.combo:header("xd", "R Settings")
menu.combo:boolean("r", "Use R", true)

menu:menu("laneclear", "Laneclear Settings")
menu.laneclear:header("xd", "Q Settings")
menu.laneclear:boolean("q", "Use Q", true)
menu.laneclear:boolean("q2", "Use Mega Q", true)

menu:menu("junglefarm", "Jungle Farm Settings")
menu.junglefarm:header("xd", "Q Settings")
menu.junglefarm:boolean("q", "Use Q", true)
menu.junglefarm:boolean("q2", "Use Mega Q", true)

local spellQ = {
    range = 1100,
    width = 60, 
    radius = 55, 
    speed = 1700, 
    delay = 0.25, 
    boundingRadiusMod = 1,
    collision = true
}

local spellQ2 = {
    range = 1100,
    width = 80,
    radius = 90, 
    speed = 2100, 
    delay = 0.50, 
    boundingRadiusMod = 1
}

local spellW2 = {
    range = 550, 
    width = 80,
    radius = 100, 
    speed = math.huge, 
    delay = 0.6, 
    boundingRadiusMod = 1
}

local spellE = {
    range = 475, 
    width = 150,
    radius = 160, 
    speed = 900, 
    delay = 0.25, 
    boundingRadiusMod = 1
}

local spellE2 = {
    range = 600, 
    width = 300,
    radius = 375, 
    speed = 800, 
    delay = 0.25, 
    boundingRadiusMod = 1
}

local spellR = {
    range = 475, 
    width = 400,
    radius = 475, 
    speed = math.huge, 
    delay = 0.25, 
    boundingRadiusMod = 1
}

local TargetSelectionQ = function(res, obj, dist)
	if dist <= spellQ.range then
		res.obj = obj
		return true
	end
end

local GetTargetQ = function()
	return ts.get_result(TargetSelectionQ).obj
end

local TargetSelectionQ2 = function(res, obj, dist)
	if dist <= spellQ2.range then
		res.obj = obj
		return true
	end
end

local GetTargetQ2 = function()
	return ts.get_result(TargetSelectionQ2).obj
end

local TargetSelectionW2 = function(res, obj, dist)
	if dist <= spellW2.range then
		res.obj = obj
		return true
	end
end

local GetTargetW2 = function()
	return ts.get_result(TargetSelectionW2).obj
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

local selectTarget = function(res, obj, dist)
    if dist > 1200 then return end
    res.obj = obj
    return true
end

local function getTarget() return ts.get_result(selectTarget).obj end

local GetTargetR = function()
	return ts.get_result(TargetSelectionR).obj
end

local trace_filter = function(input, segment, target)
    if segment.startPos:dist(segment.endPos) > spellQ.range then return false end -- Checking before spellcast to see if our projected segment end is out of range if not return 
    if preds.trace.linear.hardlock(input, segment, target) then return true end -- checking cc status if so send it no real pred needed
    if preds.trace.linear.hardlockmove(input, segment, target) then -- checking cc status if so send it no real pred needed
        return true
    end
    if preds.trace.newpath(target, 0.033, 0.5) then return true end -- Kiri path strictness :omegalul:
end

local function qpred()

    local target = GetTargetQ() 
    if common.IsValidTarget(target) then 

        local pos = preds.linear.get_prediction(spellQ, target) 
        if pos and pos.startPos:dist(pos.endPos) <= spellQ.range then 

            if not trace_filter(spellQ, pos, target) then return end 

            player:castSpell("pos", 0,
                             vec3(pos.endPos.x, mousePos.y, pos.endPos.y)) 

        end
    end
end

local function q2pred()

    local target = GetTargetQ2() 
    if common.IsValidTarget(target) then 

        local pos = preds.linear.get_prediction(spellQ2, target) 
        if pos and pos.startPos:dist(pos.endPos) <= spellQ2.range then 

            if not trace_filter(spellQ2, pos, target) then return end 

            player:castSpell("pos", 0,
                             vec3(pos.endPos.x, mousePos.y, pos.endPos.y)) 

        end
    end
end

local function w2pred()

    local target = GetTargetW2() 
    if common.IsValidTarget(target) then 

        local pos = preds.linear.get_prediction(spellW2, target) 
        if pos and pos.startPos:dist(pos.endPos) <= spellW2.range then 

            if not trace_filter(spellW2, pos, target) then return end 

            player:castSpell("pos", 1,
                             vec3(pos.endPos.x, mousePos.y, pos.endPos.y)) 

        end
    end
end

local function epred()

    local target = GetTargetE() 
    if common.IsValidTarget(target) then 

        local pos = preds.circular.get_prediction(spellE, target) 
        if pos and pos.startPos:dist(pos.endPos) <= spellE.range then 

            if not trace_filter(spellE, pos, target) then return end 

            player:castSpell("pos", 2,
                             vec3(pos.endPos.x, mousePos.y, pos.endPos.y)) 

        end
    end
end

local function e2pred()

    local target = GetTargetE2() 
    if common.IsValidTarget(target) then 

        local pos = preds.circular.get_prediction(spellE2, target) 
        if pos and pos.startPos:dist(pos.endPos) <= spellE2.range then 

            if not trace_filter(spellE2, pos, target) then return end 

            player:castSpell("pos", 2,
                             vec3(pos.endPos.x, mousePos.y, pos.endPos.y)) 

        end
    end
end

local function rpred()

    local target = GetTargetR() 
    if common.IsValidTarget(target) then 

        local pos = preds.circular.get_prediction(spellR, target) 
        if pos and pos.startPos:dist(pos.endPos) <= spellR.range then 

            if not trace_filter(spellR, pos, target) then return end 

            player:castSpell("pos", 3,
                             vec3(pos.endPos.x, mousePos.y, pos.endPos.y)) 

        end
    end
end

local r_pos = nil
local r_target = nil
local last_r = os.clock()

local function GnarR(target)
    target = target or GetTargetR()
	if player:spellSlot(3).state ~= 0 then return end

	local obj = ts.get_result(TargetSelectionR).obj;
	local range = 475

	if not obj then return end

	r_target = obj
	local p = preds.present.get_source_pos(obj)
	local unitPos = vec3(p.x, obj.y, p.y);
	
	if player.pos:dist(unitPos) <= 475 then
		for k = 1, 5, 1 do
			r_pos = unitPos * (unitPos - player.pos):norm()
			last_r = os.clock();
			if navmesh.isWall(r_pos) then
				rpred()
                print('re cast')
			end
		end
	else
		r_pos = nil
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

local gnarreturn = nil
if gnarreturn then
    --[[       expectedlol = pred.core.get_pos_after_time(gnarreturn, 0.25) ]]
    local startpos = gnarreturn.startPos -- start of missile 
    local endpos = gnarreturn.endPos -- end of missle 
    local between = startpos:lerp(endpos, 0.3) -- 0.3 of both of these values which is the point where the missile is about to hit us release (can be variable)
    if player.pos:dist(between) <= 300 then return end
    player:move(between) -- move 
end

local function on_create_missile(obj)
    --   print(obj.name, obj.speed, obj.spell.name)

    if obj.name == 'GnarQMissileReturn' then
        print('GnarQMissileReturn')
        gnarreturn = obj
    end
end

local function on_delete_missile(obj)
    if gnarreturn then
        if gnarreturn.ptr == obj.ptr then
            print('Gnar Return Deleted')
            gnarreturn = nil
        end
    end
end

cb.add(cb.create_missile, on_create_missile)
cb.add(cb.delete_missile, on_delete_missile)


local QLevelDamage = {5, 45, 85, 125, 165}
function QDamage(target)
	local damage = 0
	if player:spellSlot(0).level > 0 then
		damage =
		common.CalculatePhysicalDamage(target,(QLevelDamage[player:spellSlot(0).level] +(common.GetTotalAD() * 1.15)), player)
	end
	return damage
end

local Q2LevelDamage = {25, 70, 115, 160, 205}
function Q2Damage(target)
	local damage = 0
	if player:spellSlot(0).level > 0 and player:spellSlot(0).name == "GnarBigQ" then
		damage =
		common.CalculatePhysicalDamage(target,(Q2LevelDamage[player:spellSlot(0).level] +(common.GetTotalAD() * 1.4)), player)
	end
	return damage
end

local W2LevelDamage = {25, 55, 85, 115, 145}
function W2Damage(target)
	local damage = 0
	if player:spellSlot(1).level > 0 and player:spellSlot(1).name == "GnarBigW" then
		damage =
		common.CalculatePhysicalDamage(target,(W2LevelDamage[player:spellSlot(1).level] +(common.GetTotalAD() * 1.0)), player)
	end
	return damage
end

local RLevelDamage = {200, 300, 400,}
function RDamage(target)
	local damage = 0
	if player:spellSlot(3).level > 0 then
		damage =
		common.CalculatePhysicalDamage(target,(RLevelDamage[player:spellSlot(3).level] +(common.GetTotalAD() * .5)), player) +
        common.CalculateMagicDamage(target,(RLevelDamage[player:spellSlot(3).level] +(common.GetTotalAP() * 1.0)), player)
	end
	return damage
end

local function validFarmTargetJungle(minion)
    for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
        local obj = objManager.minions[TEAM_NEUTRAL][i]
        if player.pos:dist(obj) <= 900 then
            if obj.isVisible and obj.isTargetable and obj.health >= 1 and
                common.IsValidTarget(obj) then
                if player.pos:dist(obj) <= 1100 then

                    player:castSpell('pos', _Q, obj.pos)

                end
                --[[if player.pos:dist(obj) <= spellQ2.range and player.spellSlot(0).name == "GnarBigQ" then

                    player:castSpell('pos', _Q, obj.pos)

                end--]]
                --[[if player.pos:dist(obj) <= spellW2.range and player.spellSlot(1).name == "GnarBigW" then

                    player:castSpell('pos', _W, obj.pos)

                end--]]
            end
        end
    end
end

local function validTurd(minion)
    if not minion then return false end
    if minion.isDead then return false end
    if minion.pos:dist(player.pos) > 
        spellQ.range then return false
    end
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
        end
    end
end

local function Combo(target)
    local target = getTarget()
    if player:spellSlot(_Q).state == 0 and player.pos:dist(target.pos) <= spellQ.range and menu.combo.q:get() and
        player:spellSlot(_Q).name == "GnarQ" then
            qpred()
    end

    if player:spellSlot(_Q).state == 0 and player.pos:dist(target.pos) <= spellQ2.range and menu.combo.q2:get() and
        player:spellSlot(_Q).name == "GnarBigQ" then
            q2pred()
    end

    if player:spellSlot(_W).state == 0 and player.pos:dist(target.pos) <= spellW2.range and menu.combo.w2:get() and
        player:spellSlot(_W).name == "GnarBigW" then
            w2pred()
    end

    if player:spellSlot(_E).state == 0 and player.pos:dist(target.pos) <= spellE.range and menu.combo.e:get() and
        player:spellSlot(_E).name == "GnarE" and 
            not common.IsUnderTurret then
        epred()
    end

    if player:spellSlot(_E).state == 0 and player.pos:dist(target.pos) <= spellE2.range and menu.combo.e2:get() and
        player:spellSlot(_E).name == "GnarE2" then
            e2pred()
    end

    --[[if player:spellSlot(_R).state == 0 and player.pos:dist(target.pos) <= spellR.range and menu.combo.r:get() and
        player:spellSlot(_R).name == "GnarR" then
            rpred()
    end--]]
end

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
                             spellQ.range, 2,
                             color1, 55)
end
if menu.range.w_range:get() then
    graphics.draw_circle(player.pos, spellW2.range, 2, color2, 55)
end
if menu.range.e_range:get() then
    graphics.draw_circle(player.pos, spellE2.range, 2, color3, 55)
end
if menu.range.r_range:get() then
    graphics.draw_circle(player.pos, spellR.range, 2, color4, 55)
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
        GnarR()
    end

    if gnarreturn then
        --[[       expectedlol = pred.core.get_pos_after_time(gnarreturn, 0.25) ]]
        local startpos = gnarreturn.startPos -- start of missile 
        local endpos = gnarreturn.endPos -- end of missle 
        local between = startpos:lerp(endpos, 0.3) -- 0.3 of both of these values which is the point where the missile is about to hit us release (can be variable)
        if player.pos:dist(between) <= 300 then return end
        player:move(between) -- move 
    end
end)
chat.add('[Trent]', {color = '#17fa50', bold = true})
chat.add(' Private Gnar Loaded', {color = '#8Ff750', bold = true})
chat.print()


    
    

    


            

