local orb = module.internal("orb")
local evade = module.seek("evade")
local pred = module.internal("pred")
local ts = module.internal("TS")
local common = module.load(header.id, "common2")
local crashreporter = module.load(header.id, "crashreporter")
if player.charName ~= "MasterYi" then
    print("not using Yi not loading")
    return
end

local spellQ = {
    range = 600
}

local spellW = {}

local spellE = {
    range = 900,
    delay = 0.25,
    speed = 1800,
    width = 120,
    boundingRadiusMod = 1
}

local spellR = {
    range = 900,
    delay = 0.4,
    speed = 2000,
    width = 100,
    boundingRadiusMod = 1
}

local TargetSelection = function(res, obj, dist)
    if dist < 1200 then
        res.obj = obj
        return true
    end
end

local GetTarget = function()
    return ts.get_result(TargetSelection).obj
end

local aaaaaaaaaa = 0
local dodgeWs = {
    ["garen"] = {
        {menuslot = "R", slot = 3}
    },
    ["darius"] = {
        {menuslot = "R", slot = 3}
    },
    ["karthus"] = {
        {menuslot = "R", slot = 3}
    },
    ["zed"] = {
        {menuslot = "R", slot = 3}
    },
    ["vladimir"] = {
        {menuslot = "R", slot = 3}
    },
    ["syndra"] = {
        {menuslot = "R", slot = 3}
    },
    ["veigar"] = {
        {menuslot = "R", slot = 3}
    },
    ["leesin"] = {
        {menuslot = "R", slot = 3}
    },
    ["malzahar"] = {
        {menuslot = "R", slot = 3}
    },
    ["tristana"] = {
        {menuslot = "R", slot = 3}
    },
    ["chogath"] = {
        {menuslot = "R", slot = 3}
    },
    ["lissandra"] = {
        {menuslot = "R", slot = 3}
    },
    ["jarvaniv"] = {
        {menuslot = "R", slot = 3}
    },
    ["skarner"] = {
        {menuslot = "R", slot = 3}
    },
    ["kalista"] = {
        {menuslot = "E", slot = 2}
    },
    ["brand"] = {
        {menuslot = "R", slot = 3}
    },
    ["akali"] = {
        {menuslot = "R", slot = 3}
    },
    ["diana"] = {
        {menuslot = "R", slot = 3}
    },
    ["khazix"] = {
        {menuslot = "Q", slot = 0}
    },
    ["nocturne"] = {
        {menuslot = "R", slot = 3}
    },
    ["volibear"] = {
        {menuslot = "W", slot = 1}
    },
    ["singed"] = {
        {menuslot = "E", slot = 2}
    },
    ["nautilus"] = {
        {menuslot = "R", slot = 3}
    },
    ["morgana"] = {
        {menuslot = "R", slot = 3}
    },
    ["nocturne"] = {
        {menuslot = "R", slot = 3}
    },
    ["vayne"] = {
        {menuslot = "E", slot = 2}
    },
    ["warwick"] = {
        {menuslot = "Q", slot = 0}
    },
    ["vayne"] = {
        {menuslot = "E", slot = 2}
    },
    ["caitlyn"] = {
        {menuslot = "R", slot = 3}
    },
    ["fiddlesticks"] = {
        {menuslot = "E", slot = 2}
    },
    ["fiddlesticks"] = {
        {menuslot = "Q", slot = 0}
    },
    ["kayle"] = {
        {menuslot = "Q", slot = 0}
    },
    ["pantheon"] = {
        {menuslot = "W", slot = 1}
    },
    ["ryze"] = {
        {menuslot = "W", slot = 1}
    },
    ["teemo"] = {
        {menuslot = "Q", slot = 0}
    },
    ["twistedfate"] = {
        {menuslot = "W", slot = 1}
    },
    ["alistar"] = {
        {menuslot = "W", slot = 1}
    },
    ["camille"] = {
        {menuslot = "R", slot = 3}
    },
    ["lulu"] = {
        {menuslot = "W", slot = 1}
    },
    ["poppy"] = {
        {menuslot = "E", slot = 2}
    },
    ["rammus"] = {
        {menuslot = "E", slot = 2}
    },
    ["tahmkench"] = {
        {menuslot = "W", slot = 1}
    },
    ["vi"] = {
        {menuslot = "R", slot = 3}
    }
}
local Spells = {
    ["Pulverize"] = {
        charName = "Alistar",
        slot = 0,
        type = "circular",
        speed = math.huge,
        range = 0,
        delay = 0.25,
        radius = 365,
        hitbox = true,
        aoe = true,
        cc = true,
        collision = false
    },
    ["InfernalGuardian"] = {
        charName = "Annie",
        slot = 3,
        type = "circular",
        speed = math.huge,
        range = 600,
        delay = 0.25,
        radius = 290,
        hitbox = true,
        aoe = true,
        cc = false,
        collision = false
    },
    ["EkkoR"] = {
        charName = "Ekko",
        slot = 3,
        type = "circular",
        speed = 1650,
        range = 1600,
        delay = 0.25,
        radius = 375,
        hitbox = false,
        aoe = true,
        cc = false,
        collision = false
    },
    ["ZoeQ"] = {
        charName = "Zoe",
        slot = 0,
        type = "linear",
        speed = 1280,
        range = 800,
        delay = 0.25,
        radius = 40,
        hitbox = true,
        aoe = false,
        cc = false,
        collision = true
    },
    ["ZoeQRecast"] = {
        charName = "Zoe",
        slot = 0,
        type = "linear",
        speed = 2370,
        range = 1600,
        delay = 0,
        radius = 40,
        hitbox = true,
        aoe = false,
        cc = false,
        collision = true
    },
    ["CurseoftheSadMummy"] = {
        charName = "Amumu",
        slot = 3,
        type = "circular",
        speed = math.huge,
        range = 0,
        delay = 0.25,
        radius = 550,
        hitbox = false,
        aoe = true,
        cc = true,
        collision = false
    },
    ["AurelionSolR"] = {
        charName = "AurelionSol",
        slot = 3,
        type = "linear",
        speed = 4285,
        range = 1500,
        delay = 0.35,
        radius = 120,
        hitbox = true,
        aoe = true,
        cc = true,
        collision = false
    },
    ["StaticField"] = {
        charName = "Blitzcrank",
        slot = 3,
        type = "circular",
        speed = math.huge,
        range = 0,
        delay = 0.25,
        radius = 600,
        hitbox = false,
        aoe = true,
        cc = true,
        collision = false
    },
    ["GalioE"] = {
        charName = "Galio",
        slot = 2,
        type = "linear",
        speeds = 1400,
        range = 650,
        delay = 0.45,
        radius = 160,
        hitbox = true,
        aoe = true,
        cc = true,
        collision = false
    },
    ["EvelynnR"] = {
        charName = "Evelynn",
        slot = 3,
        type = "conic",
        speed = math.huge,
        range = 450,
        delay = 0.35,
        angle = 180,
        hitbox = false,
        aoe = true,
        cc = false,
        collision = false
    },
    ["ZacE"] = {
        charName = "Zac",
        slot = 2,
        type = "circular",
        speeds = 1330,
        range = 1800,
        delay = 0,
        radius = 300,
        hitbox = false,
        aoe = true,
        cc = true,
        collision = false
    },
    ["ZacR"] = {
        charName = "Zac",
        slot = 3,
        type = "circular",
        speeds = math.huge,
        range = 1000,
        delay = 0,
        radius = 300,
        hitbox = false,
        aoe = true,
        cc = true,
        collision = false
    },
    ["GnarR"] = {
        charName = "Gnar",
        slot = 3,
        type = "linear",
        speed = math.huge,
        range = 475,
        delay = 0.25,
        radius = 475,
        hitbox = true,
        aoe = true,
        cc = true,
        collision = false
    },
    ["UFSlash"] = {
        charName = "Malphite",
        slot = 3,
        type = "circular",
        speed = 2170,
        range = 1000,
        delay = 0,
        radius = 300,
        hitbox = true,
        aoe = true,
        cc = true,
        collision = false
    },
    ["RivenIzunaBlade"] = {
        charName = "Riven",
        slot = 3,
        type = "conic",
        speed = 1600,
        range = 900,
        delay = 0.25,
        angle = 50,
        hitbox = true,
        aoe = true,
        cc = false,
        collision = false
    },
    ["LuxLightBinding"] = {
        charName = "Lux",
        slot = 0,
        type = "linear",
        speeds = 1200,
        range = 1175,
        delay = 0.25,
        radius = 60,
        hitbox = true,
        aoe = true,
        cc = true,
        collision = true
    },
    ["NautilusAnchorDrag"] = {
        charName = "Nautilus",
        slot = 0,
        type = "linear",
        speeds = 2000,
        range = 1100,
        delay = 0.25,
        radius = 75,
        hitbox = true,
        aoe = false,
        cc = true,
        collision = true
    },
    ["GnarBigW"] = {
        charName = "Gnar",
        slot = 1,
        type = "linear",
        speeds = math.huge,
        range = 550,
        delay = 0.6,
        radius = 100,
        hitbox = true,
        aoe = true,
        cc = true,
        collision = false
    },
    ["CamilleE"] = {
        charName = "Camille",
        slot = 2,
        type = "linear",
        speeds = 1350,
        range = 800,
        delay = 0.25,
        radius = 45,
        hitbox = true,
        aoe = false,
        cc = true,
        collision = false
    },
    ["SonaR"] = {
        charName = "Sona",
        slot = 3,
        type = "linear",
        speed = 2250,
        range = 900,
        delay = 0.25,
        radius = 120,
        hitbox = true,
        aoe = true,
        cc = true,
        collision = false
    },
    ["GravesChargeShot"] = {
        charName = "Graves",
        slot = 3,
        type = "linear",
        speed = 1950,
        range = 1000,
        delay = 0.25,
        radius = 100,
        hitbox = true,
        aoe = true,
        cc = false,
        collision = false
    },
    ["CassiopeiaR"] = {
        charName = "Cassiopeia",
        slot = 3,
        type = "conic",
        speed = math.huge,
        range = 825,
        delay = 0.5,
        angle = 80,
        hitbox = false,
        aoe = true,
        cc = true,
        collision = false
    },
    ["GravesChargeShotFxMissile"] = {
        charName = "Graves",
        slot = 3,
        type = "conic",
        speed = math.huge,
        range = 800,
        delay = 0.3,
        angle = 80,
        hitbox = true,
        aoe = true,
        cc = false,
        collision = false
    },
    ["GragasR"] = {
        charName = "Gragas",
        slot = 3,
        type = "circular",
        speed = 1800,
        range = 1000,
        delay = 0.25,
        radius = 400,
        hitbox = true,
        aoe = true,
        cc = true,
        collision = false
    },
    ["TalonR"] = {
        charName = "Talon",
        slot = 3,
        type = "circular",
        speed = math.huge,
        range = 0,
        delay = 0.25,
        radius = 550,
        hitbox = false,
        aoe = true,
        cc = false,
        collision = false
    },
    ["ZiggsR"] = {
        charName = "Ziggs",
        slot = 3,
        type = "circular",
        speed = 1500,
        range = 5300,
        delay = 0.375,
        radius = 550,
        hitbox = true,
        aoe = true,
        cc = false,
        collision = false
    },
    ["OrianaDetonateCommand"] = {
        charName = "Orianna",
        slot = 3,
        type = "circular",
        speed = math.huge,
        range = 0,
        delay = 0.5,
        radius = 325,
        hitbox = false,
        aoe = true,
        cc = true,
        collision = false
    },
    ["VarusR"] = {
        charName = "Varus",
        slot = 3,
        type = "linear",
        speed = 1850,
        range = 1075,
        delay = 0.242,
        radius = 120,
        hitbox = true,
        aoe = true,
        cc = true,
        collision = false
    }
}

local str = {[-1] = "P", [0] = "Q", [1] = "W", [2] = "E", [3] = "R"}

local menu = menu("Trent_Yilel", "Trent Master Yi")

menu:header("header_keys", "Combat")
menu:keybind("combat", "Combat Key", "Space", nil)
menu:keybind("farm", "Farm Key", "V", nil)

menu:menu("q", "Q")
menu.q:dropdown("qusage", "Q Mode", 2, {"Always", "Smart"})
menu.q:boolean("qfarm", "Q Jungle Mobs", true)
menu.q:slider("mana_farmq", "Q Farm Mana  <= ", 50, 1, 100, 5)

menu:menu("w", "W")
menu.w:boolean("wcombo", "Use W for AA Reset", true)
menu.w:keybind("wtoggle", " ^- Toggle", "G", nil)

menu:menu("e", "E")
menu.e:boolean("enable_e", "Use E", true)
menu.e:boolean("efarm", "E Jungle Mobs", true)
menu.e:slider("mana_farme", "E Farm Mana  <=", 50, 1, 100, 5)

menu:menu("r", "R")
menu.r:boolean("enable_r", "Use R", false)

menu:menu("killsteal", "Killsteal")
menu.killsteal:boolean("ksq", "Killsteal with Q", true)

menu:menu("dodgew", "Q / W Dodge")
menu.dodgew:boolean("enableq", "Enable Q Dodge", true)
menu.dodgew:boolean("enablew", "Enable W on Targeted Spells", true)

menu.dodgew:header("hello", " -- Enemy Skillshots -- ")
for _, i in pairs(Spells) do
    for l, k in pairs(common.GetEnemyHeroes()) do
        -- k = myHero
        if not Spells[_] then
            return
        end
        if i.charName == k.charName then
            if i.displayname == "" then
                i.displayname = _
            end
            if i.danger == 0 then
                i.danger = 1
            end
            if (menu.dodgew[i.charName] == nil) then
                menu.dodgew:menu(i.charName, i.charName)
            end
            menu.dodgew[i.charName]:menu(_, "" .. i.charName .. " | " .. (str[i.slot] or "?") .. " " .. _)

            menu.dodgew[i.charName][_]:boolean("Dodge", "Dodge", true)

            menu.dodgew[i.charName][_]:slider("hp", "HP to Dodge", 100, 1, 100, 5)
        end
    end
end

for i = 1, #common.GetEnemyHeroes() do
    local enemy = common.GetEnemyHeroes()[i]
    local name = string.lower(enemy.charName)
    if enemy and dodgeWs[name] then
        for v = 1, #dodgeWs[name] do
            local spell = dodgeWs[name][v]
            menu.dodgew:boolean(
                string.format(tostring(enemy.charName) .. tostring(spell.menuslot)),
                "Dodge: " .. tostring(enemy.charName) .. " " .. tostring(spell.menuslot),
                true
            )
        end
    end
end

local uhh2 = false
local something2 = 0
local function Toggle()
    if menu.w.wtoggle:get() then
        if (uhh2 == false and os.clock() > something2) then
            uhh2 = true
            something2 = os.clock() + 0.3
        end
        if (uhh2 == true and os.clock() > something2) then
            uhh2 = false
            something2 = os.clock() + 0.3
        end
    end
end

local delayyyyyyy = 0

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

local QLevelDamage = {25, 60, 95, 130, 165}
function QDamage(target)
    local damage = 0
    if player:spellSlot(0).level > 0 then
        damage =
            common.CalculatePhysicalDamage(
            target,
            (QLevelDamage[player:spellSlot(0).level] + (common.GetTotalAD() * 1)),
            player
        )
    end
    return damage
end

local waiting = 0
local chargingW = 0
local uhhh = 0
local enemy = nil
local attacked = 0
local function AutoInterrupt(spell)
    if
        spell and spell.owner.type == TYPE_HERO and spell.owner == player and spell.owner.team == TEAM_ALLY and
            not (spell.name:find("BasicAttack") or spell.name:find("crit"))
     then
        if (spell.name == "Meditate") then
        end
    end
    if spell and spell.owner.type == TYPE_HERO and spell.owner.team == TEAM_ENEMY and spell.target == player then
        if spell.owner.charName == "TwistedFate" then
            local enemyName = string.lower(spell.owner.charName)
            if dodgeWs[enemyName] then
                for i = 1, #dodgeWs[enemyName] do
                    local spellCheck = dodgeWs[enemyName][i]

                    if menu.dodgew[spell.owner.charName .. spellCheck.menuslot]:get() then
                        if spell.name == "GoldCardPreAttack" then
                            for i = 0, objManager.enemies_n - 1 do
                                local enemies = objManager.enemies[i]
                                if
                                    enemies and not enemies.isDead and enemies.isVisible and enemies.isTargetable and
                                        player.pos:dist(enemies) < spellQ.range
                                 then
                                    if menu.dodgew.enableq:get() then
                                        player:castSpell("obj", 0, enemies)
                                    end
                                end
                            end
                            if #count_enemies_in_range(player.pos, spellQ.range) == 0 then
                                for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
                                    local minion = objManager.minions[TEAM_ENEMY][i]
                                    if
                                        minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and
                                            not minion.isDead and
                                            minion.pos:dist(player.pos) < spellQ.range
                                     then
                                        if menu.dodgew.enableq:get() then
                                            player:castSpell("obj", 0, minion)
                                        end
                                    end
                                end
                            end
                            if #count_enemies_in_range(player.pos, spellQ.range) == 0 or player:spellSlot(0).state ~= 0 then
                                if menu.dodgew.enablew:get() then
                                    player:castSpell("self", 1)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if
        spell and spell.owner.type == TYPE_HERO and spell.owner.team == TEAM_ENEMY and spell.target == player and
            not (spell.name:find("BasicAttack") or spell.name:find("crit") and not spell.owner.charName == "Karthus")
     then
        if not player.buff["meditate"] then
            local enemyName = string.lower(spell.owner.charName)
            if dodgeWs[enemyName] then
                for i = 1, #dodgeWs[enemyName] do
                    local spellCheck = dodgeWs[enemyName][i]

                    if
                        menu.dodgew[spell.owner.charName .. spellCheck.menuslot]:get() and spell.slot == spellCheck.slot and
                            spell.owner.charName ~= "Vladimir" and
                            spell.owner.charName ~= "Karthus" and
                            spell.owner.charName ~= "Zed"
                     then
                        for i = 0, objManager.enemies_n - 1 do
                            local enemies = objManager.enemies[i]
                            if
                                enemies and not enemies.isDead and enemies.isVisible and enemies.isTargetable and
                                    player.pos:dist(enemies) < spellQ.range
                             then
                                if menu.dodgew.enableq:get() then
                                    player:castSpell("obj", 0, enemies)
                                end
                            end
                        end
                        if #count_enemies_in_range(player.pos, spellQ.range) == 0 then
                            for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
                                local minion = objManager.minions[TEAM_ENEMY][i]
                                if
                                    minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and
                                        not minion.isDead and
                                        minion.pos:dist(player.pos) < spellQ.range
                                 then
                                    if menu.dodgew.enableq:get() then
                                        player:castSpell("obj", 0, minion)
                                    end
                                end
                            end
                        end
                        if #count_enemies_in_range(player.pos, spellQ.range) == 0 or player:spellSlot(0).state ~= 0 then
                            if menu.dodgew.enablew:get() then
                                player:castSpell("self", 1)
                            end
                        end
                    end
                end
            end
        end
    end
end

local function updatebuff(buff)
    if buff.name == "Meditate" then
        if orb.combat.target then
            if
                orb.combat.target and common.IsValidTarget(orb.combat.target) and
                    player.pos:dist(orb.combat.target.pos) < common.GetAARange(orb.combat.target)
             then
                orb.core.set_server_pause()
                player:attack(orb.combat.target)
            end
        end
    end
end

local uhhmeow = 0
orb.combat.register_f_after_attack(
    function()
        if not orb.core.can_attack() and menu.combat:get() then
            if orb.combat.target then
                if
                    orb.combat.target and common.IsValidTarget(orb.combat.target) and
                        player.pos:dist(orb.combat.target.pos) < common.GetAARange(orb.combat.target)
                 then
                    if menu.w.wcombo:get() and not uhh2 and player:spellSlot(1).state == 0 then
                        player:castSpell("self", 1)
                        orb.combat.set_invoke_after_attack(false)
                        return "waa"
                    end
                end
            end
        end
    end
)

local function combo()
    local target = GetTarget()
    if menu.q.qusage:get() == 1 then
		if common.IsValidTarget(target) then
			if (target.pos:dist(player) <= spellQ.range) then
				player:castSpell("obj", 0, target)
			end
		end
	end

	if menu.q.qusage:get() == 2 then
		if common.IsValidTarget(target) then
			if (target.pos:dist(player) <= spellQ.range) then
				if target.path.isActive and target.path.isDashing then
					player:castSpell("obj", 0, target)
				end
				if (target.health / target.maxHealth) * 100 <= 30 then
					player:castSpell("obj", 0, target)
				end
				if (player.health / player.maxHealth) * 100 <= 30 then
					player:castSpell("obj", 0, target)
				end

				if QDamage(target) > target.health and not common.CheckBuffType(target, 17) then
					player:castSpell("obj", 0, target)
				end
				if target.pos:dist(player.pos) > 400 then
					player:castSpell("obj", 0, target)
				end
			end
		end
	end
	if menu.e.enable_e:get() then
		if orb.combat.target then
			if
				common.IsValidTarget(orb.combat.target) and
					player.pos:dist(orb.combat.target.pos) < common.GetAARange(orb.combat.target)
			 then
				player:castSpell("self", 2)
			end
		end
	end
	if menu.r.enable_r:get() then
		if common.IsValidTarget(target) then
			if (target.pos:dist(player) <= 1200) then
				player:castSpell("self", 3)
			end
		end
	end
end

local function JungleClear()
	if menu.q.qfarm:get() and player:spellSlot(0).state == 0 then
		for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
			local minion = objManager.minions[TEAM_NEUTRAL][i]
			if
				minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
					minion.pos:dist(player.pos) < spellQ.range
			 then
				player:castSpell("obj", 0, minion)
			end
		end
	end
	if menu.e.efarm:get() and player:spellSlot(2).state == 0 then
		for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
			local minion = objManager.minions[TEAM_NEUTRAL][i]
			if
				minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
					minion.pos:dist(player.pos) < common.GetAARange(minion)
			 then
				player:castSpell("self", 2)
			end
		end
	end
end

local function KillSteal()
	local enemy = common.GetEnemyHeroes()
	for i, enemies in ipairs(enemy) do
		if enemies and common.IsValidTarget(enemies) and not common.CheckBuffType(enemies, 17) then
			local hp = common.GetShieldedHealth("AD", enemies)
			if menu.killsteal.ksq:get() then
				if
					player:spellSlot(0).state == 0 and vec3(enemies.x, enemies.y, enemies.z):dist(player) < spellQ.range and
						QDamage(enemies) >= hp
				 then
					player:castSpell("obj", 0, enemies)
				end
			end
		end
	end
end

local function OnTick()
	for i = 1, #evade.core.active_spells do
		local spell = evade.core.active_spells[i]

		if
			spell.polygon and spell.polygon:Contains(player.path.serverPos) ~= 0 and
				(not spell.data.collision or #spell.data.collision == 0)
		 then
			for _, k in pairs(Spells) do
				if menu.dodgew[k.charName] then
					if
						spell.name:find(_:lower()) and menu.dodgew[k.charName][_].Dodge:get() and
							menu.dodgew[k.charName][_].hp:get() >= (player.health / player.maxHealth) * 100
					 then
						if spell.missile then
							if (player.pos:dist(spell.missile.pos) / spell.data.speed < network.latency + 0.35) then
								for i = 0, objManager.enemies_n - 1 do
									local enemies = objManager.enemies[i]
									if
										enemies and not enemies.isDead and enemies.isVisible and enemies.isTargetable and
											player.pos:dist(enemies) < spellQ.range
									 then
										if menu.dodgew.enableq:get() then
											player:castSpell("obj", 0, enemies)
										end
									end
								end
								if #count_enemies_in_range(player.pos, spellQ.range) == 0 then
									for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
										local minion = objManager.minions[TEAM_ENEMY][i]
										if
											minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
												minion.pos:dist(player.pos) < spellQ.range
										 then
											if menu.dodgew.enableq:get() then
												player:castSpell("obj", 0, minion)
											end
										end
									end
								end
								if #count_enemies_in_range(player.pos, spellQ.range) == 0 or player:spellSlot(0).state ~= 0 then
									if menu.dodgew.enablew:get() then
										player:castSpell("self", 1)
									end
								end
							end
						end
						if spell.name:find(_:lower()) then
							if k.speeds == math.huge or spell.data.spell_type == "Circular" then
								for i = 0, objManager.enemies_n - 1 do
									local enemies = objManager.enemies[i]
									if
										enemies and not enemies.isDead and enemies.isVisible and enemies.isTargetable and
											player.pos:dist(enemies) < spellQ.range
									 then
										if menu.dodgew.enableq:get() then
											player:castSpell("obj", 0, enemies)
										end
									end
								end
								if #count_enemies_in_range(player.pos, spellQ.range) == 0 then
									for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
										local minion = objManager.minions[TEAM_ENEMY][i]
										if
											minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
												minion.pos:dist(player.pos) < spellQ.range
										 then
											if menu.dodgew.enableq:get() then
												player:castSpell("obj", 0, minion)
											end
										end
									end
								end
								if #count_enemies_in_range(player.pos, spellQ.range) == 0 or player:spellSlot(0).state ~= 0 then
									if menu.dodgew.enablew:get() then
										player:castSpell("self", 1)
									end
								end
							end
						end
						if spell.data.speed == math.huge or spell.data.spell_type == "Circular" then
							for i = 0, objManager.enemies_n - 1 do
								local enemies = objManager.enemies[i]
								if
									enemies and not enemies.isDead and enemies.isVisible and enemies.isTargetable and
										player.pos:dist(enemies) < spellQ.range
								 then
									if menu.dodgew.enableq:get() then
										player:castSpell("obj", 0, enemies)
									end
								end
							end
							if #count_enemies_in_range(player.pos, spellQ.range) == 0 then
								for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
									local minion = objManager.minions[TEAM_ENEMY][i]
									if
										minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
											minion.pos:dist(player.pos) < spellQ.range
									 then
										if menu.dodgew.enableq:get() then
											player:castSpell("obj", 0, minion)
										end
									end
								end
							end
							if #count_enemies_in_range(player.pos, spellQ.range) == 0 or player:spellSlot(0).state ~= 0 then
								if menu.dodgew.enablew:get() then
									player:castSpell("self", 1)
								end
							end
						end
					end
				end
			end
		end
	end

	if not player.buff["meditate"] then
		if
			menu.dodgew["Karthus" .. "R"] and menu.dodgew["Karthus" .. "R"]:get() and player.buff["karthusfallenonetarget"] and
				(player.buff["karthusfallenonetarget"].endTime - game.time) * 1000 <= 300
		 then
			for i = 0, objManager.enemies_n - 1 do
				local enemies = objManager.enemies[i]
				if
					enemies and not enemies.isDead and enemies.isVisible and enemies.isTargetable and
						player.pos:dist(enemies) < spellQ.range
				 then
					if menu.dodgew.enableq:get() then
						player:castSpell("obj", 0, enemies)
					end
				end
			end
			if #count_enemies_in_range(player.pos, spellQ.range) == 0 then
				for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
					local minion = objManager.minions[TEAM_ENEMY][i]
					if
						minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
							minion.pos:dist(player.pos) < spellQ.range
					 then
						if menu.dodgew.enableq:get() then
							player:castSpell("obj", 0, minion)
						end
					end
				end
			end
			if #count_enemies_in_range(player.pos, spellQ.range) == 0 or player:spellSlot(0).state ~= 0 then
				if menu.dodgew.enablew:get() then
					player:castSpell("self", 1)
				end
			end
		end
		if
			menu.dodgew["Zed" .. "R"] and menu.dodgew["Zed" .. "R"]:get() and player.buff["zedrdeathmark"] and
				(player.buff["zedrdeathmark"].endTime - game.time) * 1000 <= 300
		 then
			for i = 0, objManager.enemies_n - 1 do
				local enemies = objManager.enemies[i]
				if
					enemies and not enemies.isDead and enemies.isVisible and enemies.isTargetable and
						player.pos:dist(enemies) < spellQ.range
				 then
					if menu.dodgew.enableq:get() then
						player:castSpell("obj", 0, enemies)
					end
				end
			end
			if #count_enemies_in_range(player.pos, spellQ.range) == 0 then
				for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
					local minion = objManager.minions[TEAM_ENEMY][i]
					if
						minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
							minion.pos:dist(player.pos) < spellQ.range
					 then
						if menu.dodgew.enableq:get() then
							player:castSpell("obj", 0, minion)
						end
					end
				end
			end
			if #count_enemies_in_range(player.pos, spellQ.range) == 0 or player:spellSlot(0).state ~= 0 then
				if menu.dodgew.enablew:get() then
					player:castSpell("self", 1)
				end
			end
		end
		if
			menu.dodgew["Vladimir" .. "R"] and menu.dodgew["Vladimir" .. "R"]:get() and player.buff["vladimirhemoplaguedebuff"] and
				(player.buff["vladimirhemoplaguedebuff"].endTime - game.time) * 1000 <= 300
		 then
			for i = 0, objManager.enemies_n - 1 do
				local enemies = objManager.enemies[i]
				if
					enemies and not enemies.isDead and enemies.isVisible and enemies.isTargetable and
						player.pos:dist(enemies) < spellQ.range
				 then
					if menu.dodgew.enableq:get() then
						player:castSpell("obj", 0, enemies)
					end
				end
			end
			if #count_enemies_in_range(player.pos, spellQ.range) == 0 then
				for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
					local minion = objManager.minions[TEAM_ENEMY][i]
					if
						minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
							minion.pos:dist(player.pos) < spellQ.range
					 then
						if menu.dodgew.enableq:get() then
							player:castSpell("obj", 0, minion)
						end
					end
				end
			end
			if #count_enemies_in_range(player.pos, spellQ.range) == 0 or player:spellSlot(0).state ~= 0 then
				if menu.dodgew.enablew:get() then
					player:castSpell("self", 1)
				end
			end
		end
		if
			menu.dodgew["Nautilus" .. "R"] and menu.dodgew["Nautilus" .. "R"]:get() and player.buff["nautilusgrandlinetarget"] and
				(player.buff["nautilusgrandlinetarget"].endTime - game.time) * 1000 <= 300
		 then
			for i = 0, objManager.enemies_n - 1 do
				local enemies = objManager.enemies[i]
				if
					enemies and not enemies.isDead and enemies.isVisible and enemies.isTargetable and
						player.pos:dist(enemies) < spellQ.range
				 then
					if menu.dodgew.enableq:get() then
						player:castSpell("obj", 0, enemies)
					end
				end
			end
			if #count_enemies_in_range(player.pos, spellQ.range) == 0 then
				for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
					local minion = objManager.minions[TEAM_ENEMY][i]
					if
						minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
							minion.pos:dist(player.pos) < spellQ.range
					 then
						if menu.dodgew.enableq:get() then
							player:castSpell("obj", 0, minion)
						end
					end
				end
			end
			if #count_enemies_in_range(player.pos, spellQ.range) == 0 or player:spellSlot(0).state ~= 0 then
				if menu.dodgew.enablew:get() then
					player:castSpell("self", 1)
				end
			end
		end

		if
			menu.dodgew["Nocturne" .. "R"] and menu.dodgew["Nocturne" .. "R"]:get() and player.buff["nocturneparanoiadash"] and
				(player.buff["nocturneparanoiadash"].endTime - game.time) * 1000 <= 300
		 then
			for i = 0, objManager.enemies_n - 1 do
				local enemies = objManager.enemies[i]
				if
					enemies and not enemies.isDead and enemies.isVisible and enemies.isTargetable and
						player.pos:dist(enemies) < spellQ.range
				 then
					if menu.dodgew.enableq:get() then
						player:castSpell("obj", 0, enemies)
					end
				end
			end
			if #count_enemies_in_range(player.pos, spellQ.range) == 0 then
				for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
					local minion = objManager.minions[TEAM_ENEMY][i]
					if
						minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
							minion.pos:dist(player.pos) < spellQ.range
					 then
						if menu.dodgew.enableq:get() then
							player:castSpell("obj", 0, minion)
						end
					end
				end
			end
			if #count_enemies_in_range(player.pos, spellQ.range) == 0 or player:spellSlot(0).state ~= 0 then
				if menu.dodgew.enablew:get() then
					player:castSpell("self", 1)
				end
			end
		end
	end

    Toggle()

    KillSteal()

    if menu.combat:get() then
        combo()
    end

    if menu.farm:get() then
        JungleClear()
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
                         600, 2,
                         color1, 55)
end
end)

cb.add(cb.spell, AutoInterrupt)
orb.combat.register_f_pre_tick(OnTick)
--cb.add(cb.updatebuff, updatebuff)

