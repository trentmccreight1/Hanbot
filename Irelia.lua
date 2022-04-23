local orb = module.internal("orb")
local evade = module.seek("evade")
local preds = module.internal("pred")
local ts = module.internal("TS")
local common = module.load(header.id, "common2")
--local crashreporter = module.load(header.id, 'crashreporter')
if player.charName ~= "Irelia" then
    print("not using Irelia not loading")
    return
end
local menu = menu("Trent_Irelialel", "Trent Irelia")

menu:header("header_keys", "Combat")
menu:keybind("combat", "Combat Key", "Space", nil)
menu:keybind("farm", "Farm Key", "V", nil)
menu:keybind("lasthitt", "Last Hit Key", "X", nil)

local spellQ = {
    range = 625
}

local spellW = {
    range = 825,
    width = 120,
    speed = 2300,
    boundingRadiusMod = 1,
    delay = 0.25
}

local spellE = {
    range = 900,
    delay = 0.25,
    speed = 1800,
    width = 120,
    boundingRadiusMod = 1
}
local spellEA = {
    range = 900,
    delay = 0.25,
    speed = 3100,
    width = 120,
    boundingRadiusMod = 1
}
local spellES = {
    range = 900,
    delay = 0.25,
    speed = 100000,
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
    ["renekton"] = {
        {menuslot = "W", slot = 1}
    },
    ["diana"] = {
        {menuslot = "Third Auto Attack", slot = -1}
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
    ["KledEDash"] = {
        charName = "Kled",
        slot = 2,
        type = "linear",
        speeds = 1100,
        range = 550,
        delay = 0,
        radius = 90,
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
    ["EvelynnQ"] = {
        charName = "Evelynn",
        slot = 0,
        type = "linear",
        speeds = 2200,
        range = 800,
        delay = 0.25,
        radius = 35,
        hitbox = true,
        aoe = false,
        cc = false,
        collision = true
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
    ["LeblancW"] = {
        charName = "Leblanc",
        slot = 1,
        type = "circular",
        speeds = 1600,
        range = 600,
        delay = 0.25,
        radius = 260,
        hitbox = true,
        aoe = true,
        cc = false,
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
    ["MonkeyKingSpinToWin"] = {
        charName = "MonkeyKing",
        slot = 3,
        type = "circular",
        speed = math.huge,
        range = 0,
        delay = 0,
        radius = 325,
        hitbox = false,
        aoe = true,
        cc = true,
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
local allowwwwww = false
local interruptableSpells = {
    ["anivia"] = {
        {menuslot = "R", slot = 3, spellname = "glacialstorm", channelduration = 6}
    },
    ["caitlyn"] = {
        {menuslot = "R", slot = 3, spellname = "caitlynaceinthehole", channelduration = 1}
    },
    ["ezreal"] = {
        {menuslot = "R", slot = 3, spellname = "ezrealtrueshotbarrage", channelduration = 1}
    },
    ["fiddlesticks"] = {
        {menuslot = "W", slot = 1, spellname = "drain", channelduration = 5},
        {menuslot = "R", slot = 3, spellname = "crowstorm", channelduration = 1.5}
    },
    ["gragas"] = {
        {menuslot = "W", slot = 1, spellname = "gragasw", channelduration = 0.75}
    },
    ["janna"] = {
        {menuslot = "R", slot = 3, spellname = "reapthewhirlwind", channelduration = 3}
    },
    ["karthus"] = {
        {menuslot = "R", slot = 3, spellname = "karthusfallenone", channelduration = 3}
    }, --common.IsValidTargetTarget will prevent from casting @ karthus while he's zombie
    ["katarina"] = {
        {menuslot = "R", slot = 3, spellname = "katarinar", channelduration = 2.5}
    },
    ["lucian"] = {
        {menuslot = "R", slot = 3, spellname = "lucianr", channelduration = 2}
    },
    ["lux"] = {
        {menuslot = "R", slot = 3, spellname = "luxmalicecannon", channelduration = 0.5}
    },
    ["malzahar"] = {
        {menuslot = "R", slot = 3, spellname = "malzaharr", channelduration = 2.5}
    },
    ["masteryi"] = {
        {menuslot = "W", slot = 1, spellname = "meditate", channelduration = 4}
    },
    ["missfortune"] = {
        {menuslot = "R", slot = 3, spellname = "missfortunebullettime", channelduration = 3}
    },
    ["nunu"] = {
        {menuslot = "R", slot = 3, spellname = "absolutezero", channelduration = 3}
    },
    --excluding Orn's Forge Channel since it can be cancelled just by attacking him
    ["pantheon"] = {
        {menuslot = "R", slot = 3, spellname = "pantheonrjump", channelduration = 2}
    },
    ["shen"] = {
        {menuslot = "R", slot = 3, spellname = "shenr", channelduration = 3}
    },
    ["twistedfate"] = {
        {menuslot = "R", slot = 3, spellname = "gate", channelduration = 1.5}
    },
    ["varus"] = {
        {menuslot = "Q", slot = 0, spellname = "varusq", channelduration = 4}
    },
    ["warwick"] = {
        {menuslot = "R", slot = 3, spellname = "warwickr", channelduration = 1.5}
    },
    ["xerath"] = {
        {menuslot = "R", slot = 3, spellname = "xerathlocusofpower2", channelduration = 3}
    }
}

local str = {[-1] = "P", [0] = "Q", [1] = "W", [2] = "E", [3] = "R"}

menu:menu("combo", "Combo")
menu.combo:menu("qset", "Q Settings")
menu.combo.qset:boolean("qcombo", "Use Q in Combo", true)
menu.combo.qset:slider("minq", " ^- Min. Q Range", 300, 0, 500, 1)
menu.combo.qset:keybind("qmarked", "Only if Marked Toggle", "A", nil)
menu.combo.qset:boolean("gapq", "Use Q for Gapclose on Minion", true)
menu.combo.qset:boolean("outofq", " ^-Only if out of Q Range", false)
menu.combo.qset:boolean("jumparound", "Use Q to Jump-Around Enemy on Minions", false)
menu.combo.qset:slider("jumpmana", " ^- Mana Manager", 50, 0, 100, 1)
menu.combo:menu("wset", "W Settings")
menu.combo.wset:boolean("wcombo", "Use W in Combo", false)
menu.combo.wset:slider("chargew", " ^- Charge Timer", 100, 1, 1500, 1)
menu.combo.wset:boolean("forcew", " ^- Force W if Enemy leaving range", true)
menu.combo:menu("eset", "E Settings")
menu.combo.eset:boolean("ecombo", "Use E in Combo", true)
menu.combo.eset:dropdown("emode", "E Mode", 2, {"First", "Second"})
menu.combo.eset:boolean("slowe", "Slow Predictions", false)
menu.combo:menu("rset", "R Settings")
menu.combo.rset:dropdown("rusage", "R Usage", 2, {"Always", "Only if Killable", "Never"})
menu.combo.rset:slider("hitr", " ^- If Hits X Enemies", 2, 1, 5, 1)
menu.combo.rset:slider("saver", "Don't waste R if Enemy Health Percent <=", 10, 1, 100, 1)
menu.combo.rset:boolean("dontr", "Don't use R if Q is on Cooldown", false)
menu.combo:keybind("semir", "Semi-R", "T", nil)

menu:menu("farming", "Farming")
menu.farming:menu("laneclear", "Lane Clear")
menu.farming.laneclear:keybind("toggle", "Farm Toggle", "G", nil)
menu.farming.laneclear:slider("mana", "Mana Manager", 30, 0, 100, 1)
menu.farming.laneclear:header("qset", " -- Q Settings --")
menu.farming.laneclear:boolean("farmq", "Use Q to Farm", true)
menu.farming.laneclear:boolean("lastq", " ^- Only for Last Hit", true)
menu.farming.laneclear:boolean("turret", " ^- Don't use Q Under the Turret", true)
menu.farming.laneclear:boolean("qaa", "  ^- Don't use Q in AA Range", true)
menu.farming.laneclear:header("qset", " -- E Settings --")
menu.farming.laneclear:boolean("farme", "Use E in Lane Clear", false)
menu.farming:menu("jungleclear", "Jungle Clear")
menu.farming.jungleclear:boolean("useq", "Use Q in Jungle Clear", true)
menu.farming.jungleclear:boolean("markedq", " ^- Only if Marked", true)
menu.farming.jungleclear:boolean("usee", "Use E in Jungle Clear", true)

menu:menu("lasthit", "Last Hit")
menu.lasthit:slider("mana", "Mana Manager", 30, 0, 100, 1)
menu.lasthit:boolean("useq", "Use Q to Last Hit", true)
menu.lasthit:boolean("qaa", " ^- Don't use Q in AA Range", true)
menu.lasthit:boolean("turret", " ^- Don't use Q Under the Turret", true)

menu:menu("killsteal", "Killsteal")
menu.killsteal:boolean("ksq", "Killsteal with Q", true)
--menu.killsteal:boolean("kse", "Killsteal with E", true)
menu.killsteal:boolean("ksr", "Killsteal with R", true)
menu.killsteal:boolean("gapq", "Use Smart Q Gapclose", true)
menu.killsteal:header("uhhh", "Q on Killable Minion > Enemy", true)

menu:menu("draws", "Draw Settings")
menu.draws:boolean("drawq", "Draw Q Range", true)
menu.draws:color("colorq", "  ^- Color", 255, 255, 255, 255)
menu.draws:boolean("draww", "Draw W Range", true)
menu.draws:color("colorw", "  ^- Color", 255, 255, 255, 255)
menu.draws:boolean("drawe", "Draw E Range", true)
menu.draws:color("colore", "  ^- Color", 255, 0x66, 0x33, 0x00)
menu.draws:boolean("drawr", "Draw R Range", true)
menu.draws:color("colorr", "  ^- Color", 255, 0x66, 0x33, 0x00)
menu.draws:boolean("drawtoggle", "Draw Farm Toggle", true)
menu.draws:boolean("drawkill", "Draw Minions Killable with Q", true)
menu.draws:boolean("drawgapclose", "Draw Gapclose Lines", true)
--menu.draws:boolean("drawdamage", "Draw Damage", true)

menu:menu("Gap", "Gapcloser Settings")
menu.Gap:boolean("GapA", "Use E for Anti-Gapclose", true)
menu:menu("interrupt", "Interrupt Settings")
menu.interrupt:boolean("inte", "Use E to Interrupt if Possible", true)
menu.interrupt:menu("interruptmenu", "Interrupt Settings")
for i = 1, #common.GetEnemyHeroes() do
    local enemy = common.GetEnemyHeroes()[i]
    local name = string.lower(enemy.charName)
    if enemy and interruptableSpells[name] then
        for v = 1, #interruptableSpells[name] do
            local spell = interruptableSpells[name][v]
            menu.interrupt.interruptmenu:boolean(
                string.format(tostring(enemy.charName) .. tostring(spell.menuslot)),
                "Interrupt " .. tostring(enemy.charName) .. " " .. tostring(spell.menuslot),
                true
            )
        end
    end
end

menu:menu("dodgew", "W Dodge")
menu.dodgew:header("hello", " -- Enemy Skillshots -- ")
if not evade then
    menu.dodgew:header("uhh", "Enable 'Evade 2.0' to block Skillshots")
end
if evade then
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

                menu.dodgew[i.charName][_]:boolean("Dodge", "Enable Block", true)

                menu.dodgew[i.charName][_]:slider("hp", "HP to Dodge", 100, 1, 100, 5)
            end
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
                "Reduce Damage: " .. tostring(enemy.charName) .. " " .. tostring(spell.menuslot),
                true
            )
        end
    end
end

menu:menu("flee", "Flee")
menu.flee:boolean("fleeq", "Use Q to Flee", true)
menu.flee:boolean("fleekill", " ^- Only if Minion is Killable/Marked", true)
menu.flee:keybind("fleekey", "Flee Key", "G", nil)
menu.flee:boolean("fleee", "Use E in Flee", true)

local TargetSelection = function(res, obj, dist)
    if dist < spellR.range then
        res.obj = obj
        return true
    end
end

local blade = {}
function size()
    local count = 0
    for _ in pairs(blade) do
        count = count + 1
    end
    return count
end
local first = 0
local function DeleteObj(object)
    if object and object.name:find("E_Blades") then
        blade[object.ptr] = nil
    end
end
local function CreateObj(object)
    if object and object.name:find("E_Blades") then
        if allowwwwww == true then
            allowwwwww = false
            blade[object.ptr] = object
            if (first == 0) then
                first = 1
                return
            end
            if first == 1 then
                common.DelayAction(
                    function()
                        first = 0
                    end,
                    0.36
                )
            end
        end
    end
end
local TargetSelectionGap = function(res, obj, dist)
    if dist < (spellQ.range * 2) - 70 then
        res.obj = obj
        return true
    end
end

local TargetSelection = function(res, obj, dist)
    if dist < spellR.range then
        res.obj = obj
        return true
    end
end

local GetTarget = function()
    return ts.get_result(TargetSelection).obj
end
local GetTargetGap = function()
    return ts.get_result(TargetSelectionGap).obj
end
local uhh = false
local something = 0
local function Toggle()
    if menu.farming.laneclear.toggle:get() then
        if (uhh == false and os.clock() > something) then
            uhh = true
            something = os.clock() + 0.3
        end
        if (uhh == true and os.clock() > something) then
            uhh = false
            something = os.clock() + 0.3
        end
    end
end
local uhh5 = false
local something2 = 0
local function Toggle2()
    if menu.combo.qset.qmarked:get() then
        if (uhh5 == false and os.clock() > something2) then
            uhh5 = true
            something2 = os.clock() + 0.3
        end
        if (uhh5 == true and os.clock() > something2) then
            uhh5 = false
            something2 = os.clock() + 0.3
        end
    end
end
local delayyyyyyy = 0

passiveBaseScale = {
    4
}
passiveADScale = {2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4}
sheenTimer = os.clock()
local function count_enemies_in_range(pos, range)
    local pos = pos or player
    local range = range or 1500
    local enemies_in_range = {}
    for i = 0, objManager.enemies_n - 1 do
        local enemy = objManager.enemies[i]
        if pos:dist(enemy.pos) < range and common.IsValidTarget(enemy) then
            enemies_in_range[#enemies_in_range + 1] = enemy
        end
    end
    return enemies_in_range
end

local last_item_update = 0
local hasSheen = false
local hasTF = false
local hasBOTRK = false
local hasTitanic = false
local hasWitsEnd = false
local hasRecurve = false
local hasGuinsoo = false
function GetQDamage(target)
    local totalPhysical = 0
    local totalMagical = 0

    local flat = 5 + 20 * player:spellSlot(0).level
    local ratio = common.GetTotalAD() * 0.6
    local total = flat + ratio
    if target.type == TYPE_MINION and target.team ~= TEAM_NEUTRAL then
        total = total * 1.7
    end
    totalPhysical = total + totalPhysical
    if os.clock() > last_item_update then
        hasSheen = false
        hasTF = false
        hasBOTRK = false
        hasWitsEnd = false
        hasRecurve = false
        hasGuinsoo = false
        for i = 0, 5 do
            if player:itemID(i) == 3078 then
                hasTF = true
            end
            if player:itemID(i) == 3057 then
                hasSheen = true
            end
            if player:itemID(i) == 3153 then
                hasBOTRK = true
            end
            if player:itemID(i) == 1043 then
                hasRecurve = true
            end
        end
        last_item_update = os.clock() + 5
    end

    local onhitPhysical = 0
    local onhitMagical = 0

    if hasTF and (os.clock() >= sheenTimer or player.buff[sheen]) then
        onhitPhysical = onhitPhysical + 2.00 * player.baseAttackDamage
    end
    if hasSheen and not hasTF and (os.clock() >= sheenTimer or player.buff[sheen]) then
        onhitPhysical = onhitPhysical + player.baseAttackDamage
    end
    if hasBOTRK then
        if target.type == TYPE_MINION then
            onhitPhysical = onhitPhysical + math.min(math.max(15, target.health * 0.12), 60)
        else
            onhitPhysical = onhitPhysical + math.max(15, target.health * 0.12)
        end
    end
    if hasRecurve then
        onhitPhysical = onhitPhysical + 15
    end

    --passive
    if player.buff["ireliapassivestacks"] then
        local passiveTotalDmg = 1.5 + (common.GetTotalAD() - 10) * passiveADScale[player.levelRef] / 100
        passiveTotalDmg = (player.buff["ireliapassivestacks"].stacks2 + 1) * passiveTotalDmg - 10
        onhitMagical = onhitMagical + passiveTotalDmg
    end

    totalPhysical = totalPhysical + onhitPhysical
    totalMagical = totalMagical + onhitMagical

    if target.type == TYPE_HERO then
        --Conqueror
        --Other Reductions
        totalPhysical = totalPhysical
        totalMagical = totalMagical
    end
    return (totalPhysical * common.PhysicalReduction(target) + totalMagical * common.MagicReduction(target)) - 20
end

local RLevelDamage = {125, 225, 325}
function RDamage(target)
    local damage = 0
    if player:spellSlot(3).level > 0 then
        damage = CalcADmg(target, (RLevelDamage[player:spellSlot(3).level] + (common.GetTotalAP() * .7)))
    end
    return damage
end
local ELevelDamage = {80, 120, 160, 200, 240}
function EDamage(target)
    local damage = 0
    if player:spellSlot(2).level > 0 then
        damage = CalcADmg(target, (ELevelDamage[player:spellSlot(2).level] + (common.GetTotalAP() * .8)))
    end
    return damage
end
function CalcMagicDmg(target, amount, from)
    local from = from or player
    local target = target or orb.combat.target
    local amount = amount or 0
    local targetMR = target.spellBlock * math.ceil(from.percentMagicPenetration) - from.flatMagicPenetration
    local dmgMul = 100 / (100 + targetMR)
    if dmgMul < 0 then
        dmgMul = 2 - (100 / (100 - magicResist))
    end
    amount = amount * dmgMul
    return math.floor(amount)
end
function CalcADmg(target, amount, from)
    local from = from or player or objmanager.player
    local target = target or orb.combat.target
    local amount = amount or 0
    local targetD = target.armor * math.ceil(from.percentBonusArmorPenetration)
    local dmgMul = 100 / (100 + targetD)
    amount = amount * dmgMul
    return math.floor(amount)
end

local function GetClosestMobToEnemyForGap()
    local closestMinion = nil
    local closestMinionDistance = 9999
    local enemy = common.GetEnemyHeroes()
    for i, enemies in ipairs(enemy) do
        if enemies and common.IsValidTarget(enemies) then
            for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
                local minion = objManager.minions[TEAM_ENEMY][i]
                if
                    minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
                        minion.pos:dist(player.pos) < spellQ.range and
                        minion.type == TYPE_MINION
                 then
                    if minion.health < GetQDamage(minion) or minion.buff["ireliamark"] then
                        local minionPos = vec3(minion.x, minion.y, minion.z)
                        if minionPos:dist(enemies) < spellQ.range then
                            local minionDistanceToMouse = minionPos:dist(enemies)

                            if minionDistanceToMouse < closestMinionDistance then
                                closestMinion = minion
                                closestMinionDistance = minionDistanceToMouse
                            end
                        end
                    end
                end
            end
        end
    end

    return closestMinion
end

local function GetClosestJungleEnemy()
    local closestMinion = nil
    local closestMinionDistance = 9999
    local enemy = common.GetEnemyHeroes()
    for i, enemies in ipairs(enemy) do
        if enemies and common.IsValidTarget(enemies) and not common.HasBuffType(enemies, 17) then
            local hp = common.GetShieldedHealth("ad", enemies)

            for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
                local minion = objManager.minions[TEAM_NEUTRAL][i]
                if
                    minion and minion.isVisible and not minion.isDead and minion.pos:dist(player.pos) < spellQ.range and
                        (minion.health < GetQDamage(minion) or minion.buff["ireliamark"])
                 then
                    local minionPos = vec3(minion.x, minion.y, minion.z)
                    if minionPos:dist(enemies) < spellQ.range then
                        local minionDistanceToMouse = minionPos:dist(enemies)

                        if minionDistanceToMouse < closestMinionDistance then
                            closestMinion = minion
                            closestMinionDistance = minionDistanceToMouse
                        end
                    end
                end
            end
        end
    end

    return closestMinion
end

local trace_filter = function(input, segment, target)
    if preds.trace.linear.hardlock(input, segment, target) then
        return true
    end
    if preds.trace.linear.hardlockmove(input, segment, target) then
        return true
    end
    if
        target and common.IsValidTarget(target) and
            (player.pos:dist(target) <= (player.attackRange + player.boundingRadius + target.boundingRadius) or
                (player:spellSlot(0).state == 0 and segment.startPos:dist(segment.endPos) <= 625))
     then
        return true
    end
    if segment.startPos:dist(segment.endPos) <= 625 and preds.trace.newpath(target, 0.033, 0.05) then
        return true
    end
    if preds.trace.newpath(target, 0.033, 0.4) then
        return true
    end
end

local function GetClosestJungleEnemyToGap()
    local closestMinion = nil
    local closestMinionDistance = 9999
    local enemy = common.GetEnemyHeroes()
    for i, enemies in ipairs(enemy) do
        if enemies and common.IsValidTarget(enemies) and not common.HasBuffType(enemies, 17) then
            local hp = common.GetShieldedHealth("ad", enemies)
            for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
                local minion = objManager.minions[TEAM_NEUTRAL][i]
                if
                    minion and minion.isVisible and not minion.isDead and minion.pos:dist(player.pos) < spellQ.range and
                        (minion.health < GetQDamage(minion) or minion.buff["ireliamark"]) and
                        minion.type == TYPE_MINION
                 then
                    local minionPos = vec3(minion.x, minion.y, minion.z)
                    if minionPos:dist(enemies) < spellQ.range then
                        local minionDistanceToMouse = minionPos:dist(enemies)

                        if minionDistanceToMouse < closestMinionDistance then
                            closestMinion = minion
                            closestMinionDistance = minionDistanceToMouse
                        end
                    end
                end
            end
        end
    end

    return closestMinion
end

local waiting = 0
local chargingW = 0
local uhhh = 0
local enemy = nil
local helooooooooooooo = 0
local function AutoInterrupt(spell) -- Thank you Dew for this <3
    if spell.owner == player and spell.name:find("IreliaE") then
        allowwwwww = true
    end
    if
        spell and spell.owner.type == TYPE_HERO and spell.owner.team == TEAM_ENEMY and spell.target == player and
            not (spell.name:find("BasicAttack") or
                spell.name:find("crit") and (spell.owner.charName ~= "Karthus" or spell.owner.charName ~= "Diana"))
     then
        if not player.buff["ireliawdefense"] then
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
                        if spell.owner.charName ~= "Renekton" then
                            player:castSpell("pos", 1, player.pos)
                        end
                    end
                    if
                        menu.dodgew[spell.owner.charName .. spellCheck.menuslot]:get() and
                            spell.owner.charName == "Renekton"
                     then
                        if spell.name == "RenektonExecute" then
                            player:castSpell("pos", 1, player.pos)
                        end
                    end
                end
            end
        end
    end
    if
        spell and spell.owner.type == TYPE_HERO and spell.owner.team == TEAM_ENEMY and spell.target == player and
            spell.name:find("BasicAttack3") and
            spell.owner.charName == "Diana"
     then
        if not player.buff["ireliawdefense"] then
            local enemyName = string.lower(spell.owner.charName)
            if dodgeWs[enemyName] then
                for i = 1, #dodgeWs[enemyName] do
                    local spellCheck = dodgeWs[enemyName][i]

                    if
                        menu.dodgew[spell.owner.charName .. spellCheck.menuslot]:get() and
                            spell.owner.charName == "Diana"
                     then
                        player:castSpell("pos", 1, player.pos)
                    end
                end
            end
        end
    end

    if menu.interrupt.inte:get() then
        if spell.owner.type == TYPE_HERO and spell.owner.team == TEAM_ENEMY then
            local enemyName = string.lower(spell.owner.charName)
            if interruptableSpells[enemyName] then
                for i = 1, #interruptableSpells[enemyName] do
                    local spellCheck = interruptableSpells[enemyName][i]
                    if
                        menu.interrupt.interruptmenu[spell.owner.charName .. spellCheck.menuslot]:get() and
                            string.lower(spell.name) == spellCheck.spellname
                     then
                        if player.pos2D:dist(spell.owner.pos2D) < spellE.range and common.IsValidTarget(spell.owner) then
                            common.DelayAction(
                                function()
                                    for _, objsq in pairs(blade) do
                                        if objsq and objsq.x and objsq.z and enemy then
                                            local pos =
                                                preds.linear.get_prediction(spellE, enemy, vec2(objsq.x, objsq.z))
                                            if pos and player:spellSlot(2).name == "IreliaE2" then
                                                local EPOS =
                                                    objsq.pos +
                                                    (vec3(pos.endPos.x, mousePos.y, pos.endPos.y) - objsq.pos):norm() *
                                                        (objsq.pos:dist(vec3(pos.endPos.x, mousePos.y, pos.endPos.y)) +
                                                            420)
                                                if (enemy.pos:dist(objsq.pos) > 300) then
                                                    spellE.speed = EPOS:dist(objsq.pos)
                                                end

                                                local pos2 =
                                                    preds.linear.get_prediction(spellE, enemy, vec2(objsq.x, objsq.z))
                                                if
                                                    pos2 and
                                                        vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y):dist(player.pos) <
                                                            930
                                                 then
                                                    local EPOS2 =
                                                        objsq.pos +
                                                        (vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y) - objsq.pos):norm(

                                                        ) *
                                                            (objsq.pos:dist(
                                                                vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y)
                                                            ) +
                                                                420)
                                                    player:castSpell("pos", 2, EPOS2)

                                                    enemy = nil
                                                end
                                            end
                                        end
                                    end
                                end,
                                0.35
                            )

                            if aaaaaaaaaa < os.clock() and player:spellSlot(2).name == "IreliaE" then
                                local pos2 = preds.linear.get_prediction(spellEA, spell.owner)
                                if (pos2) and vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y):dist(player.pos) < 900 then
                                    local EPOS2 =
                                        spell.owner.path.serverPos +
                                        (((player.pos:dist(spell.owner.pos)) * -0.5 + 200 +
                                            spell.owner.path.serverPos:dist(player.path.serverPos)) /
                                            spell.owner.path.serverPos:dist(player.path.serverPos)) *
                                            (player.path.serverPos - spell.owner.path.serverPos)
                                    player:castSpell("pos", 2, EPOS2)
                                    enemy = spell.owner
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if spell.owner.charName == "Irelia" then
        if spell.name == "IreliaE" then
            aaaaaaaaaa = os.clock() + 1
            waiting = os.clock() + 1
            uhhh = os.clock() + 0.8
            helooooooooooooo = os.clock() + 0.3
        end
        if spell.name == "IreliaW" then
            chargingW = os.clock()
        end
        if spell.name == "IreliaR" then
            waiting = os.clock() + 1
        end
    end
end

local function WGapcloser()
    if menu.Gap.GapA:get() then
        for i = 0, objManager.enemies_n - 1 do
            local dasher = objManager.enemies[i]
            if dasher.type == TYPE_HERO and dasher.team == TEAM_ENEMY then
                if
                    dasher and common.IsValidTarget(dasher) and dasher.path.isActive and dasher.path.isDashing and
                        player.pos:dist(dasher.path.point[1]) < spellE.range
                 then
                    if player.pos2D:dist(dasher.path.point2D[1]) < player.pos2D:dist(dasher.path.point2D[0]) then
                        common.DelayAction(
                            function()
                                for _, objsq in pairs(blade) do
                                    if objsq and objsq.x and objsq.z and enemy then
                                        local pos = preds.linear.get_prediction(spellE, enemy, vec2(objsq.x, objsq.z))
                                        if pos and player:spellSlot(2).name == "IreliaE2" then
                                            local EPOS =
                                                objsq.pos +
                                                (vec3(pos.endPos.x, mousePos.y, pos.endPos.y) - objsq.pos):norm() *
                                                    (objsq.pos:dist(vec3(pos.endPos.x, mousePos.y, pos.endPos.y)) + 420)
                                            if (enemy.pos:dist(objsq.pos) > 300) then
                                                spellE.speed = EPOS:dist(objsq.pos)
                                            end

                                            local pos2 =
                                                preds.linear.get_prediction(spellE, enemy, vec2(objsq.x, objsq.z))
                                            if
                                                pos2 and
                                                    vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y):dist(player.pos) <
                                                        930
                                             then
                                                local EPOS2 =
                                                    objsq.pos +
                                                    (vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y) - objsq.pos):norm() *
                                                        (objsq.pos:dist(vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y)) +
                                                            420)
                                                player:castSpell("pos", 2, EPOS2)

                                                enemy = nil
                                            end
                                        end
                                    end
                                end
                            end,
                            0.4
                        )

                        if aaaaaaaaaa < os.clock() and player:spellSlot(2).name == "IreliaE" then
                            local pos2 = preds.linear.get_prediction(spellEA, dasher)
                            if (pos2) and vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y):dist(player.pos) < 900 then
                                local EPOS2 =
                                    dasher.path.serverPos +
                                    (((player.pos:dist(dasher.pos)) * -0.5 + 200 +
                                        dasher.path.serverPos:dist(player.path.serverPos)) /
                                        dasher.path.serverPos:dist(player.path.serverPos)) *
                                        (player.path.serverPos - dasher.path.serverPos)
                                player:castSpell("pos", 2, EPOS2)
                                enemy = dasher
                            end
                        end
                    end
                end
            end
        end
    end
end

local function GetClosestMobKill()
    local closestMinion = nil
    local closestMinionDistance = 9999

    for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
        local minion = objManager.minions[TEAM_ENEMY][i]
        if
            minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
                minion.pos:dist(player.pos) < spellQ.range and
                minion.pos:dist(mousePos) < player.pos:dist(mousePos) and
                minion.type == TYPE_MINION
         then
            if minion.health < GetQDamage(minion) then
                local minionPos = vec3(minion.x, minion.y, minion.z)
                if minionPos:dist(player.pos) < spellQ.range then
                    local minionDistanceToMouse = minionPos:dist(mousePos)

                    if minionDistanceToMouse < closestMinionDistance then
                        closestMinion = minion
                        closestMinionDistance = minionDistanceToMouse
                    end
                end
            end
        end
    end

    return closestMinion
end

local function GetClosestJungleKill()
    local closestMinion = nil
    local closestMinionDistance = 9999

    for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
        local minion = objManager.minions[TEAM_NEUTRAL][i]
        if
            minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
                minion.pos:dist(player.pos) < spellQ.range and
                minion.pos:dist(mousePos) < player.pos:dist(mousePos) and
                minion.type == TYPE_MINION
         then
            if minion.health < GetQDamage(minion) then
                local minionPos = vec3(minion.x, minion.y, minion.z)
                if minionPos:dist(player.pos) < spellQ.range then
                    local minionDistanceToMouse = minionPos:dist(mousePos)

                    if minionDistanceToMouse < closestMinionDistance then
                        closestMinion = minion
                        closestMinionDistance = minionDistanceToMouse
                    end
                end
            end
        end
    end

    return closestMinion
end

local function GetClosestMobMark()
    local closestMinion = nil
    local closestMinionDistance = 9999

    for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
        local minion = objManager.minions[TEAM_NEUTRAL][i]
        if
            minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
                minion.pos:dist(player.pos) < spellQ.range and
                minion.pos:dist(mousePos) < player.pos:dist(mousePos) and
                minion.type == TYPE_MINION
         then
            if minion.buff["ireliamark"] then
                local minionPos = vec3(minion.x, minion.y, minion.z)
                if minionPos:dist(player.pos) < spellQ.range then
                    local minionDistanceToMouse = minionPos:dist(mousePos)

                    if minionDistanceToMouse < closestMinionDistance then
                        closestMinion = minion
                        closestMinionDistance = minionDistanceToMouse
                    end
                end
            end
        end
    end

    return closestMinion
end

local function GetClosestJungleMark()
	local closestMinion = nil
	local closestMinionDistance = 9999

	for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
		local minion = objManager.minions[TEAM_NEUTRAL][i]
		if
			minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
				minion.pos:dist(player.pos) < spellQ.range and
				minion.pos:dist(mousePos) < player.pos:dist(mousePos) and
				minion.type == TYPE_MINION
		 then
			if minion.buff["ireliamark"] then
				local minionPos = vec3(minion.x, minion.y, minion.z)
				if minionPos:dist(player.pos) < spellQ.range then
					local minionDistanceToMouse = minionPos:dist(mousePos)

					if minionDistanceToMouse < closestMinionDistance then
						closestMinion = minion
						closestMinionDistance = minionDistanceToMouse
					end
				end
			end
		end
	end
end

local function GetClosestMob()
    local closestMinion = nil
    local closestMinionDistance = 9999

    for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
        local minion = objManager.minions[TEAM_ENEMY][i]
        if
            minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
                minion.pos:dist(player.pos) < spellQ.range and
                minion.pos:dist(mousePos) < player.pos:dist(mousePos) and
                minion.type == TYPE_MINION
         then
            local minionPos = vec3(minion.x, minion.y, minion.z)
            if minionPos:dist(player.pos) < spellQ.range then
                local minionDistanceToMouse = minionPos:dist(mousePos)

                if minionDistanceToMouse < closestMinionDistance then
                    closestMinion = minion
                    closestMinionDistance = minionDistanceToMouse
                end
            end
        end
    end

    return closestMinion
end

local function GetClosestJungle()
    local closestMinion = nil
    local closestMinionDistance = 9999

    for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
        local minion = objManager.minions[TEAM_NEUTRAL][i]
        if
            minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
                minion.pos:dist(player.pos) < spellQ.range and
                minion.pos:dist(mousePos) < player.pos:dist(mousePos) and
                minion.type == TYPE_MINION
         then
            local minionPos = vec3(minion.x, minion.y, minion.z)
            if minionPos:dist(player.pos) < spellQ.range then
                local minionDistanceToMouse = minionPos:dist(mousePos)

                if minionDistanceToMouse < closestMinionDistance then
                    closestMinion = minion
                    closestMinionDistance = minionDistanceToMouse
                end
            end
        end
    end

    return closestMinion
end

local fleedelay = 0
local function Flee()
    if menu.flee.fleekey:get() then
        local target = GetTarget()
        player:move(vec3(mousePos.x, mousePos.y, mousePos.z))
        if menu.flee.fleeq:get() then
            if not menu.flee.fleekill:get() then
                local minion = GetClosestMob()
                if minion then
                    player:castSpell("obj", 0, minion)
                end
                local jungleeeee = GetClosestJungle()
                if jungleeeee then
                    player:castSpell("obj", 0, jungleeeee)
                end
            end
        end
        if menu.flee.fleeq:get() then
            if menu.flee.fleekill:get() then
                local minion = GetClosestMobKill()
                if minion then
                    player:castSpell("obj", 0, minion)
                end
                local jungleeeee = GetClosestJungleKill()
                if jungleeeee then
                    player:castSpell("obj", 0, jungleeeee)
                end
                local minionm = GetClosestMobMark()
                if minionm then
                    player:castSpell("obj", 0, minionm)
                end
                local jungleeeeem = GetClosestJungleMark()
                if jungleeeeem then
                    player:castSpell("obj", 0, jungleeeeem)
                end
            end
        end
        if menu.flee.fleee:get() then
            if common.IsValidTarget(target) then
                if (target.pos:dist(player) <= spellE.range) then
                    if
                        aaaaaaaaaa < os.clock() and player:spellSlot(2).name == "IreliaE" and
                            player:spellSlot(2).state == 0
                     then
                        if menu.combo.eset.emode:get() == 1 then
                            local pos2 = preds.linear.get_prediction(spellEA, target)
                            if (pos2) and vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y):dist(player.pos) < 900 then
                                local EPOS2 =
                                    target.path.serverPos +
                                    (((player.pos:dist(target.pos)) * -0.5 + 600 +
                                        target.path.serverPos:dist(player.path.serverPos)) /
                                        target.path.serverPos:dist(player.path.serverPos)) *
                                        (player.path.serverPos - target.path.serverPos)
                                player:castSpell("pos", 2, EPOS2)
                                delayyyyyyy = os.clock() + 0.5
                            end
                        end
                        if menu.combo.eset.emode:get() == 2 and aaaaaaaaaa < os.clock() and fleedelay < os.clock() then
                            -- Thanks to asdf. ♡
                            if not target.path.isActive then
                                if target.pos:dist(player.pos) <= 900 then
                                    local cast1 = player.pos + (target.pos - player.pos):norm() * 900
                                    player:castSpell("pos", 2, cast1)
                                    fleedelay = os.clock() + 1
                                end
                            else
                                local pathStartPos = target.path.point[0]
                                local pathEndPos = target.path.point[target.path.count]
                                local pathNorm = (pathEndPos - pathStartPos):norm()
                                local tempPred = common.GetPredictedPos(target, 1)
                                if tempPred then
                                    local dist1 = player.pos:dist(tempPred)
                                    if dist1 <= 900 then
                                        local dist2 = player.pos:dist(target.pos)
                                        if dist1 < dist2 then
                                            pathNorm = pathNorm * -1
                                        end
                                        local cast2 = RaySetDist(target.pos, pathNorm, player.pos, 900)
                                        player:castSpell("pos", 2, cast2)

                                        fleedelay = os.clock() + 1
                                    end
                                end
                            end
                            delayyyyyyy = os.clock() + 0.5
                        end
                    end
                end
            end
            if common.IsValidTarget(target) then
                if (target.pos:dist(player) <= spellE.range) then
                    for _, objsq in pairs(blade) do
                        if objsq and objsq.x and objsq.z then
                            local pos = preds.linear.get_prediction(spellE, target, vec2(objsq.x, objsq.z))
                            if pos and player:spellSlot(2).name == "IreliaE2" then
                                local EPOS =
                                    objsq.pos +
                                    (vec3(pos.endPos.x, mousePos.y, pos.endPos.y) - objsq.pos):norm() *
                                        (objsq.pos:dist(vec3(pos.endPos.x, mousePos.y, pos.endPos.y)) + 420)
                                if (target.pos:dist(objsq.pos) > 300) then
                                    spellE.speed = EPOS:dist(objsq.pos)
                                end

                                local pos2 = preds.linear.get_prediction(spellE, target, vec2(objsq.x, objsq.z))
                                if
                                    pos2 and vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y):dist(player.pos) < 930 and
                                        trace_filter(spellE, pos, target)
                                 then
                                    local EPOS2 =
                                        objsq.pos +
                                        (vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y) - objsq.pos):norm() *
                                            (objsq.pos:dist(vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y)) + 420)

                                    player:castSpell("pos", 2, EPOS2)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function RaySetDist(start, path, center, dist)
    local a = start.x - center.x
    local b = start.y - center.y
    local c = start.z - center.z
    local x = path.x
    local y = path.y
    local z = path.z

    local n1 = a * x + b * y + c * z
    local n2 =
        z ^ 2 * dist ^ 2 - a ^ 2 * z ^ 2 - b ^ 2 * z ^ 2 + 2 * a * c * x * z + 2 * b * c * y * z + 2 * a * b * x * y +
        dist ^ 2 * x ^ 2 +
        dist ^ 2 * y ^ 2 -
        a ^ 2 * y ^ 2 -
        b ^ 2 * x ^ 2 -
        c ^ 2 * x ^ 2 -
        c ^ 2 * y ^ 2
    local n3 = x ^ 2 + y ^ 2 + z ^ 2

    local r1 = -(n1 + math.sqrt(n2)) / n3
    local r2 = -(n1 - math.sqrt(n2)) / n3
    local r = math.max(r1, r2)

    return start + r * path
end

local meowwwwwwwww = 0
local test = nil
local function Combo()
    local target = GetTarget()
    local mode = menu.combo.rset.rusage:get()

    --[[if common.IsValidTarget(target) then
        if menu.combo.items:get() then
            if (target.pos:dist(player) <= 650) then
            end
        end
    end--]]
    local delayyyyyyy = 0
    local meow = 0
    if (meow < os.clock()) then
        if common.IsValidTarget(target) then
            if menu.combo.qset.qcombo:get() then
                if common.IsValidTarget(target) then
                    if target.buff["ireliamark"] or target.health <= GetQDamage(target) then
                        player:castSpell("obj", 0, target)
                        meow = os.clock() + 1
                    end
                end
            end
        end
    end

    if
        menu.combo.qset.jumparound:get() and menu.combo.qset.jumpmana:get() <= (player.mana / player.maxMana) * 100 and
            (player.health / player.maxHealth) * 100 <= 80 and
            (first == 0)
     then
        if common.IsValidTarget(target) then
            if menu.combo.qset.qcombo:get() then
                if common.IsValidTarget(target) then
                    for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
                        local minion = objManager.minions[TEAM_ENEMY][i]
                        if
                            minion and minion.isVisible and not minion.isDead and minion.type == TYPE_MINION and
                                minion.pos:dist(player.pos) < spellQ.range and
                                minion.pos:dist(target.pos) < spellQ.range - 150
                         then
                            if
                                (GetQDamage(minion) >= minion.health) and
                                    not common.IsUnderTurret(vec3(minion.x, minion.y, minion.z))
                             then
                                player:castSpell("obj", 0, minion)
                            end
                        end
                    end
                end
            end
        end
    end
    if common.IsValidTarget(target) then
        if menu.combo.eset.ecombo:get() then
            if common.IsValidTarget(target) then
                if (target.pos:dist(player) <= spellE.range - 50) then
                    if
                        aaaaaaaaaa < os.clock() and player:spellSlot(2).name == "IreliaE" and
                            player:spellSlot(2).state == 0
                     then
                        if menu.combo.eset.emode:get() == 1 then
                            local pos2 = preds.linear.get_prediction(spellEA, target)
                            local meowmeowwa = 0
                            if target.path.isActive then
                                if player.pos:dist(target.path.point[1]) > player.pos:dist(target.path.point[0]) then
                                    meowmeowwa = 50
                                end
                            end

                            if
                                (pos2) and
                                    vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y):dist(player.pos) < 900 + meowmeowwa and
                                    delayyyyyyy < os.clock()
                             then
                                local EPOS2 =
                                    target.path.serverPos +
                                    (((player.pos:dist(target.pos)) * -0.5 + 600 +
                                        target.path.serverPos:dist(player.path.serverPos)) /
                                        target.path.serverPos:dist(player.path.serverPos)) *
                                        (player.path.serverPos - target.path.serverPos)
                                local pos3 = preds.linear.get_prediction(spellE, target, vec2(EPOS2.x, EPOS2.z))
                                if pos3 then
                                    if not menu.combo.eset.slowe:get() then
                                        if
                                            (pos3) and
                                                vec3(pos3.endPos.x, mousePos.y, pos3.endPos.y):dist(player.pos) <
                                                    900 - meowmeowwa
                                         then
                                            player:castSpell("pos", 2, EPOS2)
                                            delayyyyyyy = os.clock() + 0.5
                                        end
                                    end
                                    if menu.combo.eset.slowe:get() then
                                        if
                                            (pos3) and
                                                vec3(pos3.endPos.x, mousePos.y, pos3.endPos.y):dist(player.pos) <
                                                    900 + meowmeowwa and
                                                trace_filter(spellE, pos3, target)
                                         then
                                            player:castSpell("pos", 2, EPOS2)
                                            delayyyyyyy = os.clock() + 0.5
                                        end
                                    end
                                end
                            end
                        end
                        if menu.combo.eset.emode:get() == 2 and meowwwwwwwww < os.clock() then
                            local pathStartPos = target.path.point[0]
                            local pathEndPos = target.path.point[target.path.count]
                            local pathNorm = (pathEndPos - pathStartPos):norm()
                            local tempPred = common.GetPredictedPos(target, 1.2)
                            -- Thanks to asdf. ♡

                            if not target.path.isActive then
                                if target.pos:dist(player.pos) <= 830 then
                                    local cast1 = player.pos + (target.pos - player.pos):norm() * 900

                                    player:castSpell("pos", 2, cast1)
                                    meowwwwwwwww = os.clock() + 1
                                end
                            else
                                if tempPred then
                                    local dist1 = player.pos:dist(tempPred)
                                    if dist1 <= 900 then
                                        local dist2 = player.pos:dist(target.pos)
                                        if dist1 < dist2 then
                                            pathNorm = pathNorm * -1
                                        end
                                        local cast2 = RaySetDist(target.pos, pathNorm, player.pos, 900)
                                        player:castSpell("pos", 2, cast2)
                                        meowwwwwwwww = os.clock() + 1
                                    end
                                end
                            end
                            delayyyyyyy = os.clock() + 0.5
                        end
                    end
                end
            end
        end
    end
    if common.IsValidTarget(target) and target then
        if not menu.combo.rset.dontr:get() then
            if mode == 1 then
                if (target.pos:dist(player) < spellR.range) then
                    local pos = preds.linear.get_prediction(spellR, target)
                    if
                        pos and pos.startPos:dist(pos.endPos) < spellR.range and
                            menu.combo.rset.hitr:get() <= #count_enemies_in_range(target.pos, 400)
                     then
                        player:castSpell("pos", 3, vec3(pos.endPos.x, mousePos.y, pos.endPos.y))
                    end
                end
            end
            if mode == 2 then
                if (GetQDamage(target) + RDamage(target) * 2 + EDamage(target) >= target.health) then
                    if (target.pos:dist(player) < spellR.range) then
                        local pos = preds.linear.get_prediction(spellR, target)
                        if
                            pos and pos.startPos:dist(pos.endPos) < spellR.range and
                                (target.health / target.maxHealth) * 100 >= menu.combo.rset.saver:get()
                         then
                            player:castSpell("pos", 3, vec3(pos.endPos.x, mousePos.y, pos.endPos.y))
                        end
                    end
                end
            end
        end
        if menu.combo.rset.dontr:get() and player:spellSlot(0).state == 0 then
            if mode == 1 then
                if (target.pos:dist(player) < spellR.range) then
                    local pos = preds.linear.get_prediction(spellR, target)
                    if
                        pos and pos.startPos:dist(pos.endPos) < spellR.range and
                            menu.combo.rset.hitr:get() <= #count_enemies_in_range(target.pos, 400)
                     then
                        player:castSpell("pos", 3, vec3(pos.endPos.x, mousePos.y, pos.endPos.y))
                    end
                end
            end
            if mode == 2 then
                if (GetQDamage(target) + RDamage(target) * 2 + EDamage(target) >= target.health) then
                    if (target.pos:dist(player) < spellR.range) then
                        local pos = preds.linear.get_prediction(spellR, target)
                        if
                            pos and pos.startPos:dist(pos.endPos) < spellR.range and
                                (target.health / target.maxHealth) * 100 >= menu.combo.rset.saver:get()
                         then
                            player:castSpell("pos", 3, vec3(pos.endPos.x, mousePos.y, pos.endPos.y))
                        end
                    end
                end
            end
        end
    end

    if common.IsValidTarget(target) then
        if menu.combo.eset.ecombo:get() then
            if common.IsValidTarget(target) then
                if (target.pos:dist(player) <= spellE.range) then
                    for _, objsq in pairs(blade) do
                        if objsq and objsq.x and objsq.z and not target.buff["ireliamark"] then
                            local pos = preds.linear.get_prediction(spellE, target, vec2(objsq.x, objsq.z))

                            if pos and player:spellSlot(2).name == "IreliaE2" and helooooooooooooo < os.clock() then
                                local meowmeowwa = 0
                                if target.path.isActive then
                                    if player.pos:dist(target.path.point[1]) > player.pos:dist(target.path.point[0]) then
                                        meowmeowwa = 10
                                    end
                                end

                                local EPOS =
                                    objsq.pos +
                                    (vec3(pos.endPos.x, mousePos.y, pos.endPos.y) - objsq.pos):norm() *
                                        (objsq.pos:dist(vec3(pos.endPos.x, mousePos.y, pos.endPos.y)) + 500)
                                if (target.pos:dist(objsq.pos) > 300) then
                                    spellE.speed = EPOS:dist(objsq.pos)
                                end

                                local pos2 = preds.linear.get_prediction(spellE, target, vec2(objsq.x, objsq.z))
                                if
                                    pos2 and
                                        vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y):dist(player.pos) <
                                            930 + meowmeowwa
                                 then
                                    local EPOS2 =
                                        objsq.pos +
                                        (vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y) - objsq.pos):norm() *
                                            (objsq.pos:dist(vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y)) + 500)
                                    if not menu.combo.eset.slowe:get() then
                                        player:castSpell("pos", 2, EPOS2)
                                    end

                                    if menu.combo.eset.slowe:get() and trace_filter(spellE, pos2, target) then
                                        player:castSpell("pos", 2, EPOS2)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    local targets = GetTargetGap()
    if menu.combo.qset.gapq:get() and menu.combo.qset.outofq:get() then
        if common.IsValidTarget(targets) and targets then
            if (targets.pos:dist(player) > spellQ.range) then
                local minion = GetClosestMobToEnemyForGap()
                if minion and vec3(minion.x, minion.y, minion.z):dist(player.pos) <= spellQ.range then
                    if player.mana > player.manaCost0 and GetQDamage(minion) >= minion.health then
                        player:castSpell("obj", 0, minion)
                    end
                end
            end
        end
    end
    if menu.combo.qset.gapq:get() and not menu.combo.qset.outofq:get() then
        if common.IsValidTarget(targets) and targets then
            if (targets.pos:dist(player) < spellQ.range * 2) then
                local minion = GetClosestMobToEnemyForGap(targets)
                if minion and vec3(minion.x, minion.y, minion.z):dist(player.pos) <= spellQ.range then
                    if player.mana > player.manaCost0 and GetQDamage(minion) >= minion.health then
                        if
                            (vec3(minion.x, minion.y, minion.z):dist(targets.pos) <
                                vec3(targets.x, targets.y, targets.z):dist(player.pos))
                         then
                            player:castSpell("obj", 0, minion)
                        end
                    end
                end
            end
        end
    end
    if (delayyyyyyy < os.clock()) then
        if common.IsValidTarget(target) then
            if menu.combo.qset.qcombo:get() and uhh5 then
                if common.IsValidTarget(target) then
                    --[[if not menu.combo.waitq:get() then
					if (target.pos:dist(player) < spellQ.range) then
						if target.buff["ireliamark"] then
							player:castSpell("obj", 0, target)
						end
						if (target.pos:dist(player)) > menu.combo.minq:get() then
							player:castSpell("obj", 0, target)
						end
					end
				end]]
                    if not target.buff["ireliamark"] then
                        if (os.clock() > waiting) then
                            if (target.pos:dist(player) < spellQ.range) then
                                if (target.pos:dist(player)) > menu.combo.qset.minq:get() then
                                    if (first == 0) then
                                        player:castSpell("obj", 0, target)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if common.IsValidTarget(target) then
        if
            player:spellSlot(0).state ~= 0 or
                (player:spellSlot(0).state == 0 and target.pos:dist(player.pos) < menu.combo.qset.minq:get())
         then
            if menu.combo.wset.wcombo:get() then
                if common.IsValidTarget(target) then
                    if (target.pos:dist(player) <= spellW.range) then
                        if not player.buff["ireliawdefense"] and target.pos:dist(player) < spellW.range - 180 then
                            local pos = preds.linear.get_prediction(spellW, target)
                            if pos and pos.startPos:dist(pos.endPos) < spellW.range then
                                player:castSpell("pos", 1, player.pos)
                            end
                        end

                        if
                            player.buff["ireliawdefense"] and
                                os.clock() - chargingW > menu.combo.wset.chargew:get() / 1000
                         then
                            local pos = preds.linear.get_prediction(spellW, target)
                            if pos and pos.startPos:dist(pos.endPos) <= spellW.range then
                                player:castSpell("release", 1, vec3(pos.endPos.x, mousePos.y, pos.endPos.y))
                            end
                        end
                        if menu.combo.wset.forcew:get() then
                            if player.buff["ireliawdefense"] then
                                if (target.pos:dist(player) > spellW.range - 150) then
                                    local pos = preds.linear.get_prediction(spellW, target)
                                    if pos and pos.startPos:dist(pos.endPos) <= spellW.range + 100 then
                                        player:castSpell("release", 1, vec3(pos.endPos.x, mousePos.y, pos.endPos.y))
                                    end
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
    local meow = 0
    if menu.farming.jungleclear.useq:get() then
        local enemyMinionsQ = common.GetMinionsInRange(spellQ.range, TEAM_NEUTRAL)
        for i, minion in pairs(enemyMinionsQ) do
            if
                minion and not minion.isDead and minion.moveSpeed > 0 and minion.isTargetable and
                    common.IsValidTarget(minion)
             then
                local minionPos = vec3(minion.x, minion.y, minion.z)
                if minionPos:dist(player.pos) <= spellQ.range then
                    if (meow < os.clock()) then
                        if minion.buff["ireliamark"] or minion.health <= GetQDamage(minion) then
                            player:castSpell("obj", 0, minion)
                            meow = os.clock() + 1
                        end
                    end
                end
            end
        end
    end
    if menu.farming.jungleclear.usee:get() then
        for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
            local minion = objManager.minions[TEAM_NEUTRAL][i]
            if
                minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
                    minion.pos:dist(player.pos) < spellE.range
             then
                local minionPos = vec3(minion.x, minion.y, minion.z)
                if minionPos:dist(player.pos) <= spellE.range then
                    if
                        aaaaaaaaaa < os.clock() and player:spellSlot(2).name == "IreliaE" and
                            player:spellSlot(2).state == 0
                     then
                        -- Thanks to asdf. ♡
                        if not minion.path.isActive then
                            if minion.pos:dist(player.pos) <= 900 then
                                local cast1 = player.pos + (minion.pos - player.pos):norm() * 900

                                player:castSpell("pos", 2, cast1)
                            end
                        else
                            local pathStartPos = minion.path.point[0]
                            local pathEndPos = minion.path.point[minion.path.count]
                            local pathNorm = (pathEndPos - pathStartPos):norm()
                            local tempPred = common.GetPredictedPos(minion, 1.2)
                            if tempPred then
                                local dist1 = player.pos:dist(tempPred)
                                if dist1 <= 900 then
                                    local dist2 = player.pos:dist(minion.pos)
                                    if dist1 < dist2 then
                                        pathNorm = pathNorm * -1
                                    end
                                    local cast2 = RaySetDist(minion.pos, pathNorm, player.pos, 900)
                                    player:castSpell("pos", 2, cast2)
                                end
                            end
                        end
                        delayyyyyyy = os.clock() + 0.5
                    end

                    for _, objsq in pairs(blade) do
                        if objsq and objsq.x and objsq.z and not minion.buff["ireliamark"] then
                            local pos = preds.linear.get_prediction(spellE, minion, vec2(objsq.x, objsq.z))

                            if pos and player:spellSlot(2).name == "IreliaE2" then
                                local EPOS =
                                    objsq.pos +
                                    (vec3(pos.endPos.x, mousePos.y, pos.endPos.y) - objsq.pos):norm() *
                                        (objsq.pos:dist(vec3(pos.endPos.x, mousePos.y, pos.endPos.y)) + 420)
                                if (minion.pos:dist(objsq.pos) > 300) then
                                    spellE.speed = EPOS:dist(objsq.pos)
                                end

                                local pos2 = preds.linear.get_prediction(spellE, minion, vec2(objsq.x, objsq.z))
                                if pos2 and vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y):dist(player.pos) < 930 then
                                    local EPOS2 =
                                        objsq.pos +
                                        (vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y) - objsq.pos):norm() *
                                            (objsq.pos:dist(vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y)) + 420)
                                    player:castSpell("pos", 2, EPOS2)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if menu.farming.jungleclear.useq:get() then
        local enemyMinionsQ = common.GetMinionsInRange(spellQ.range, TEAM_NEUTRAL)
        for i, minion in pairs(enemyMinionsQ) do
            if minion and not minion.isDead and common.IsValidTarget(minion) then
                local minionPos = vec3(minion.x, minion.y, minion.z)
                if minionPos:dist(player.pos) <= spellQ.range then
                    if (delayyyyyyy < os.clock()) then
                        if menu.farming.jungleclear.markedq:get() then
                            if minion.buff["ireliamark"] then
                                if (os.clock() > waiting) then
                                    if (meow < os.clock()) then
                                        if minion.buff["ireliamark"] or minion.health <= GetQDamage(minion) then
                                            player:castSpell("obj", 0, minion)
                                            meow = os.clock() + 1
                                        end
                                    end
                                end
                            end
                        end
                        if not menu.farming.jungleclear.markedq:get() then
                            if not minion.buff["ireliamark"] then
                                if (os.clock() > waiting) then
                                    player:castSpell("obj", 0, minion)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

--[[local function KillSteal()
    local target = GetTarget()
    local enemy = common.GetEnemyHeroes()
    for i, enemies in ipairs(enemy) do
        if enemies and common.IsValidTarget(enemies) and not common.CheckBuffType(enemies, 17) then
            local hp = common.GetShieldedHealth("AD", enemies)
            if menu.killsteal.ksq:get() then
                if
                    player:spellSlot(0).state == 0 and vec3(enemies.x, enemies.y, enemies.z):dist(player) < spellQ.range and
                        GetQDamage(enemies) >= hp
                 then
                    player:castSpell("obj", 0, enemies)
                end
            end

            if (enemies.pos:dist(player) <= spellE.range) then
                for _, objsq in pairs(blade) do
                    if objsq and objsq.x and objsq.z then
                        local pos = preds.linear.get_prediction(spellE, enemies, vec2(objsq.x, objsq.z))
                        if pos and player:spellSlot(2).name == "IreliaE2" then
                            local EPOS =
                                objsq.pos +
                                (vec3(pos.endPos.x, mousePos.y, pos.endPos.y) - objsq.pos):norm() *
                                    (objsq.pos:dist(vec3(pos.endPos.x, mousePos.y, pos.endPos.y)) + 420)
                            if (enemies.pos:dist(objsq.pos) > 300) then
                                spellE.speed = EPOS:dist(objsq.pos)
                            end

                            local pos2 = preds.linear.get_prediction(spellE, enemies, vec2(objsq.x, objsq.z))
                            if pos2 and vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y):dist(player.pos) < 930 then
                                local EPOS2 =
                                    objsq.pos +
                                    (vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y) - objsq.pos):norm() *
                                        (objsq.pos:dist(vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y)) + 420)
                                player:castSpell("pos", 2, EPOS2)
                            end
                        end
                    end
                end
            end
        end
        if menu.killsteal.ksr:get() then
            if
                player:spellSlot(3).state == 0 and target.pos:dist(player.pos) < spellR.range and
                    RDamage(enemies) > hp
             then
                local pos = preds.linear.get_prediction(spellR, enemies)
                if pos and pos.startPos:dist(pos.endPos) < spellR.range then
                    player:castSpell("pos", 3, vec3(pos.endPos.x, mousePos.y, pos.endPos.y))
                end
            end
        end
        if menu.killsteal.gapq:get() then
            if
                player:spellSlot(0).state == 0 and target.pos:dist(player.pos) > spellQ.range and
                target.pos:dist(player.pos) < spellQ.range * 2 - 70 and
                    GetQDamage(enemies) > hp
             then
                local minion = GetClosestMobToEnemyForGap()
                if minion and minion.health < GetQDamage(minion) then
                    player:castSpell("obj", 0, minion)
                end

                local minios = GetClosestMobToEnemyForGap()
                if minios and minion.health < GetQDamage(minion) then
                    player:castSpell("obj", 0, minios)
                end
            end
        end
    end
end--]]

local function LaneClear()
    if uhh then
        return
    end
    if (player.mana / player.maxMana) * 100 >= menu.farming.laneclear.mana:get() then
        if menu.farming.laneclear.farmq:get() then
            local enemyMinionsQ = common.GetMinionsInRange(spellQ.range, TEAM_ENEMY)
            for i, minion in pairs(enemyMinionsQ) do
                if
                    minion and not minion.isDead and common.IsValidTarget(minion) and
                        #count_enemies_in_range(minion.pos) == 0
                 then
                    local minionPos = vec3(minion.x, minion.y, minion.z)
                    if minionPos:dist(player.pos) <= spellQ.range then
                        if not menu.farming.laneclear.lastq:get() then
                            if
                                menu.farming.laneclear.turret:get() and
                                    not common.is_under_tower(vec3(minion.x, minion.y, minion.z))
                             then
                                player:castSpell("obj", 0, minion)
                            end
                            if not menu.farming.laneclear.turret:get() then
                                player:castSpell("obj", 0, minion)
                            end
                        end
                        if menu.farming.laneclear.lastq:get() and GetQDamage(minion) > minion.health then
                            if
                                menu.farming.laneclear.turret:get() and
                                    not common.IsUnderTurret(vec3(minion.x, minion.y, minion.z))
                             then
                                if not menu.farming.laneclear.qaa:get() then
                                    player:castSpell("obj", 0, minion)
                                end
                                if menu.farming.laneclear.qaa:get() then
                                    if player.pos:dist(minion.pos) > 200 then
                                        player:castSpell("obj", 0, minion)
                                    end
                                end
                            end
                            if not menu.farming.laneclear.turret:get() then
                                if not menu.farming.laneclear.qaa:get() then
                                    player:castSpell("obj", 0, minion)
                                end
                                if menu.farming.laneclear.qaa:get() then
                                    if player.pos:dist(minion.pos) > 200 then
                                        player:castSpell("obj", 0, minion)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if menu.farming.laneclear.farme:get() then
            for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
                local minion = objManager.minions[TEAM_ENEMY][i]
                if
                    minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
                        minion.pos:dist(player.pos) < spellE.range
                 then
                    local minionPos = vec3(minion.x, minion.y, minion.z)
                    if minionPos:dist(player.pos) <= spellE.range then
                        if
                            aaaaaaaaaa < os.clock() and player:spellSlot(2).name == "IreliaE" and
                                player:spellSlot(2).state == 0
                         then
                            -- Thanks to asdf. ♡
                            if not minion.path.isActive then
                                if minion.pos:dist(player.pos) <= 900 then
                                    local cast1 = player.pos + (minion.pos - player.pos):norm() * 900

                                    player:castSpell("pos", 2, cast1)
                                end
                            else
                                local pathStartPos = minion.path.point[0]
                                local pathEndPos = minion.path.point[minion.path.count]
                                local pathNorm = (pathEndPos - pathStartPos):norm()
                                local tempPred = common.GetPredictedPos(minion, 1)

                                if tempPred then
                                    local dist1 = player.pos:dist(tempPred)
                                    if dist1 <= 900 then
                                        local dist2 = player.pos:dist(minion.pos)
                                        if dist1 < dist2 then
                                            pathNorm = pathNorm * -1
                                        end
                                        local cast2 = RaySetDist(minion.pos, pathNorm, player.pos, 900)
                                        player:castSpell("pos", 2, cast2)
                                    end
                                end
                            end
                            delayyyyyyy = os.clock() + 0.5
                        end

                        for _, objsq in pairs(blade) do
                            if objsq and objsq.x and objsq.z and not minion.buff["ireliamark"] then
                                local pos = preds.linear.get_prediction(spellE, minion, vec2(objsq.x, objsq.z))

                                if pos and player:spellSlot(2).name == "IreliaE2" then
                                    local EPOS =
                                        objsq.pos +
                                        (vec3(pos.endPos.x, mousePos.y, pos.endPos.y) - objsq.pos):norm() *
                                            (objsq.pos:dist(vec3(pos.endPos.x, mousePos.y, pos.endPos.y)) + 420)
                                    if (minion.pos:dist(objsq.pos) > 300) then
                                        spellE.speed = EPOS:dist(objsq.pos)
                                    end

                                    local pos2 = preds.linear.get_prediction(spellE, minion, vec2(objsq.x, objsq.z))
                                    if pos2 and vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y):dist(player.pos) < 930 then
                                        local EPOS2 =
                                            objsq.pos +
                                            (vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y) - objsq.pos):norm() *
                                                (objsq.pos:dist(vec3(pos2.endPos.x, mousePos.y, pos2.endPos.y)) + 420)
                                        player:castSpell("pos", 2, EPOS2)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
local function LastHit()
    if (player.mana / player.maxMana) * 100 >= menu.lasthit.mana:get() then
        if menu.lasthit.useq:get() then
            local enemyMinions = common.GetMinionsInRange(spellQ.range, TEAM_ENEMY)
            for i, minion in pairs(enemyMinions) do
                if
                    minion and not minion.isDead and minion.isVisible and player.pos:dist(minion.pos) < spellQ.range and
                        #count_enemies_in_range(minion.pos, menu.lasthit.suicidalq:get()) == 0 and
                        GetQDamage(minion) >= minion.health
                 then
                    if menu.lasthit.turret:get() and not common.is_under_tower(vec3(minion.x, minion.y, minion.z)) then
                        if not menu.lasthit.qaa:get() then
                            player:castSpell("obj", 0, minion)
                        end
                        if menu.lasthit.qaa:get() then
                            if player.pos:dist(minion.pos) > 200 then
                                player:castSpell("obj", 0, minion)
                            end
                        end
                    end
                    if not menu.lasthit.turret:get() then
                        if not menu.lasthit.qaa:get() then
                            player:castSpell("obj", 0, minion)
                        end
                        if menu.lasthit.qaa:get() then
                            if player.pos:dist(minion.pos) > 200 then
                                player:castSpell("obj", 0, minion)
                            end
                        end
                    end
                end
            end
        end
    end
end

local function OnDraw()
    if player.isOnScreen then
        if menu.draws.drawq:get() then
            graphics.draw_circle(player.pos, spellQ.range, 2, menu.draws.colorq:get(), 50)
        end
        if menu.draws.drawe:get() then
            graphics.draw_circle(player.pos, spellE.range, 2, menu.draws.colore:get(), 50)
        end
        if menu.draws.drawr:get() then
            graphics.draw_circle(player.pos, spellR.range, 2, menu.draws.colorr:get(), 50)
        end
        if menu.draws.draww:get() then
            graphics.draw_circle(player.pos, spellW.range, 2, menu.draws.colorw:get(), 50)
        end
        if menu.draws.drawkill:get() and player:spellSlot(0).state == 0 then
            for i = 0, objManager.minions.size[TEAM_ENEMY] - 1 do
                local minion = objManager.minions[TEAM_ENEMY][i]
                if
                    minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
                        minion.type == TYPE_MINION and
                        minion.pos:dist(player.pos) < spellQ.range + 300
                 then
                    local minionPos = vec3(minion.x, minion.y, minion.z)
                    local targets = GetTargetGap()
                    if (GetQDamage(minion) >= minion.health) then
                        graphics.draw_circle(minionPos, 100, 2, graphics.argb(255, 255, 255, 0), 50)
                    end
                end
            end
            for i = 0, objManager.minions.size[TEAM_NEUTRAL] - 1 do
                local minion = objManager.minions[TEAM_NEUTRAL][i]
                if
                    minion and minion.isVisible and minion.moveSpeed > 0 and minion.isTargetable and not minion.isDead and
                        minion.type == TYPE_MINION and
                        minion.pos:dist(player.pos) < spellQ.range + 300
                 then
                    local minionPos = vec3(minion.x, minion.y, minion.z)
                    local targets = GetTargetGap()
                    if (GetQDamage(minion) >= minion.health) then
                        graphics.draw_circle(minionPos, 100, 2, graphics.argb(255, 255, 255, 0), 50)
                    end
                end
            end
        end
    end
    if menu.draws.drawtoggle:get() then
        local pos = graphics.world_to_screen(vec3(player.x, player.y, player.z))

        if uhh == true then
            graphics.draw_text_2D("Farm: OFF", 18, pos.x - 20, pos.y + 40, graphics.argb(255, 218, 34, 34))
        else
            graphics.draw_text_2D("Farm: ON", 18, pos.x - 20, pos.y + 40, graphics.argb(255, 128, 255, 0))
        end
        if uhh5 == true then
            graphics.draw_text_2D("Only Marked: OFF", 18, pos.x - 20, pos.y + 20, graphics.argb(255, 218, 34, 34))
        else
            graphics.draw_text_2D("Only Marked: ON", 18, pos.x - 20, pos.y + 20, graphics.argb(255, 128, 255, 0))
        end
    end

    --if menu.draws.drawdamage:get() then
    --for i = 0, objManager.enemies_n - 1 do
    --local enemies = objManager.enemies[i]
    --if enemies and not enemies.isDead and enemies.isVisible and enemies.isTargetable and player.pos:dist(enemies) < 2000 then
    --DrawDamagesE(enemies)
    --end
    --end
    --end
    if menu.draws.drawgapclose:get() and player:spellSlot(0).state == 0 then
        local minion = GetClosestMobToEnemyForGap()
        local targets = GetTargetGap()
        if targets then
            if common.IsValidTarget(targets) and minion then
                if
                    targets and (targets.pos:dist(player) < spellQ.range + spellQ.range - 50) and
                        (targets.pos:dist(player)) > spellQ.range
                 then
                    if player.mana > player.manaCost0 and GetQDamage(minion) >= minion.health then
                        graphics.draw_line(player, minion, 4, graphics.argb(255, 218, 34, 34))
                        graphics.draw_line(minion, targets, 4, graphics.argb(255, 218, 34, 34))
                    end
                end

                if
                    targets and (targets.pos:dist(player) < spellQ.range + spellQ.range) and
                        (targets.pos:dist(player)) < spellQ.range
                 then
                    if player.mana > player.manaCost0 then
                        if GetQDamage(minion) >= minion.health or minion.buff["ireliamark"] then
                            if
                                (vec3(minion.x, minion.y, minion.z):dist(targets.pos) <
                                    vec3(targets.x, targets.y, targets.z):dist(player.pos))
                             then
                                graphics.draw_line(player, minion, 4, graphics.argb(255, 218, 34, 34))
                                graphics.draw_line(minion, targets, 4, graphics.argb(255, 218, 34, 34))
                            end
                        end
                    end
                end
            end
        end
    end
end

--[[local function OnTick()
	if evade then
		for i = 1, #evade.core.active_spells do
			local spell = evade.core.active_spells[i]

			if
				spell.polygon and spell.polygon:Contains(player.path.serverPos) ~= 0 and
					(not spell.data.collision or #spell.data.collision == 0)
			 then
				for _, k in pairs(Spells) do
					if menu.dodgew[k.charName] then
						if k.charName == "Evelynn" and player.buff["EvelynnW"] then
							if
								spell.name:find(_:lower()) and menu.dodgew[k.charName][_].Dodge:get() and
									menu.dodgew[k.charName][_].hp:get() >= (player.health / player.maxHealth) * 100
							 then
								if spell.missile then
									if (player.pos:dist(spell.missile.pos) / spell.data.speed < network.latency + 0.35) then
										player:castSpell("pos", 1, player.pos)
									end
								end
								if k.speed == math.huge or spell.data.spell_type == "Circular" then
									player:castSpell("pos", 1, player.pos)
								end
							end
						else
							if
								spell.name:find(_:lower()) and menu.dodgew[k.charName][_].Dodge:get() and
									menu.dodgew[k.charName][_].hp:get() >= (player.health / player.maxHealth) * 100
							 then
								if spell.missile then
									if (player.pos:dist(spell.missile.pos) / spell.data.speed < network.latency + 0.35) then
										player:castSpell("pos", 1, player.pos)
									end
								end
								if k.speed == math.huge or spell.data.spell_type == "Circular" then
									player:castSpell("pos", 1, player.pos)
								end
							end
						end
					end
				end
			end
		end
	end

	if menu.combo.semir:get() then
		local target = GetTarget()
		if common.IsValidTarget(target) and target then
			if (target.pos:dist(player) < spellR.range) then
				local pos = preds.linear.get_prediction(spellR, target)
				if pos and pos.startPos:dist(pos.endPos) < spellR.range then
					player:castSpell("pos", 3, vec3(pos.endPos.x, mousePos.y, pos.endPos.y))
				end
			end
		end
	end
	if not player.buff["ireliawdefense"] then
		if
			menu.dodgew["Karthus" .. "R"] and menu.dodgew["Karthus" .. "R"]:get() and player.buff["karthusfallenonetarget"] and
				(player.buff["karthusfallenonetarget"].endTime - game.time) * 1000 <= 300
		 then
			player:castSpell("pos", 1, player.pos)
		end
		if
			menu.dodgew["Zed" .. "R"] and menu.dodgew["Zed" .. "R"]:get() and player.buff["zedrdeathmark"] and
				(player.buff["zedrdeathmark"].endTime - game.time) * 1000 <= 300
		 then
			player:castSpell("pos", 1, player.pos)
		end
		if
			menu.dodgew["Vladimir" .. "R"] and menu.dodgew["Vladimir" .. "R"]:get() and player.buff["vladimirhemoplaguedebuff"] and
				(player.buff["vladimirhemoplaguedebuff"].endTime - game.time) * 1000 <= 300
		 then
			player:castSpell("pos", 1, player.pos)
		end
	end
	local target = GetTarget()
	if common.IsValidTarget(target) then
		if common.IsValidTarget(target) then
			if (target.pos:dist(player) < spellE.range) then
				for _, objsq in pairs(blade) do
					if objsq and objsq.x and objsq.z then
						local pos = preds.linear.get_prediction(spellE, target, vec2(objsq.x, objsq.z))

						local EPOS =
							objsq.pos +
							(vec3(pos.endPos.x, mousePos.y, pos.endPos.y) - objsq.pos):norm() *
								(objsq.pos:dist(vec3(pos.endPos.x, mousePos.y, pos.endPos.y)) + 300)
						if (target.pos:dist(objsq.pos) > 500) then
							spellE.speed = EPOS:dist(objsq.pos)
						end

						if (target.pos:dist(objsq.pos) < 500) then
							spellE.speed = EPOS:dist(objsq.pos) * 0.8
						end
					end
				end
			end
		end
	end--]]
cb.add(
    cb.tick,
    function()
        Flee()
        if menu.Gap.GapA:get() then
            WGapcloser()
        end
        Toggle()
        Toggle2()
        if menu.lasthitt:get() then
            LastHit()
        end
        --KillSteal()
        if menu.farm:get() then
            LaneClear()
            JungleClear()
        end
        if menu.combat:get() then
            Combo()
        end
    end
)

--local function OnRemoveBuff(buff)
--if buff.owner.ptr == player.ptr and buff.name == "sheen" then
--sheenTimer = os.clock() + 1.7
--end
--end
--cb.add(cb.removebuff, OnRemoveBuff)
--cb.add(cb.createobj, CreateObj)
--cb.add(cb.deleteobj, DeleteObj)
cb.add(cb.draw, OnDraw)
cb.add(cb.spell, AutoInterrupt)
