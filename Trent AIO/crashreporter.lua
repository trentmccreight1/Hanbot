local evadexd = module.seek('evade')
local orbxd = module.seek('orb')
local language = 'English'
local Version = '1.0'
local urlxd =
    'https://discord.com/api/webhooks/937498046059667487/VF5gA9hk9sXRL27uaGD8yK8Og-94861Lp5IzRNXzOrZBFaVdWyn4dEuf2Oro3jcTe7ur'
cb.add(
    cb.error,
    function(msg)
        local orbstatus = 'no?'
        local evadestatus = 'no?'

        local f1 = 'no?'
        local f0 = 'no?'

        local f2 = 'no?'
        local f3 = 'no?'

        if orbxd then
            orbstatus = 'Yes'
        else
            orbstatus = 'no'
        end
        if evadexd then
            evadestatus = 'Yes'
        else
            evadestatus = 'no'
        end

        if orbxd.menu.combat.key:get() then
            f0 = 'Yes'
        else
            f0 = 'no'
        end
        if orbxd.menu.lane_clear.key:get() then
            f1 = 'Yes'
        else
            f1 = 'no'
        end
        if orbxd.menu.last_hit.key:get() then
            f2 = 'Yes'
        else
            f2 = 'no'
        end
        if orbxd.menu.hybrid.key:get() then
            f3 = 'Yes'
        else
            f3 = 'no'
        end
        data_grab_mine = {
            content = '\nError: \n' ..
                msg ..
                    '\n\nChampion: ' ..
                        player.charName ..
                            '\nTime In Game: ' ..
                                (game.time / 60) ..
                                    '\nMap ID: ' ..
                                        game.mapID ..
                                            '\nGame Mode: ' ..
                                                game.mode ..
                                                    '\nGame Version: ' ..
                                                        game.version ..
                                                            '\nVersion: ' ..
                                                                Version .. --  "\n\n Orb Detected: " .. orbxd ..
                                                                    '\nEvade Detected: ' ..
                                                                        evadestatus ..
                                                                            '\nEvade Version: ' ..
                                                                                evadexd.menu.text ..
                                                                                    '\nOrb Detected: ' ..
                                                                                        orbstatus ..
                                                                                            --   "\nOrb LaneClear: " .. orbxd.menu.lane_clear.key:get() ..
                                                                                            --  "\n\n Orb LastHit: " .. orbxd.menu.last_hit.key:get() ..
                                                                                            '\nOrb Combat: ' ..
                                                                                                f0 ..
                                                                                                    '\nOrb Lane Clear: ' ..
                                                                                                        f1 ..
                                                                                                            '\nOrb Last Hit: ' ..
                                                                                                                f2 ..
                                                                                                                    '\nOrb Hybrid: ' ..
                                                                                                                        f3 ..
                                                                                                                            '\nPing On Crash: ' ..
                                                                                                                                (network.latency *
                                                                                                                                    1000) ..
                                                                                                                                    ' ms' ..
                                                                                                                                        '\nLanguage: ' ..
                                                                                                                                            language ..
                                                                                                                                                '\nHWID: ' ..
                                                                                                                                                    hanbot.hwid ..
                                                                                                                                                        '\nHWID2: ' ..
                                                                                                                                                            hanbot.hwid2 ..
                                                                                                                                                                '\n----------- END OF CRASH LOG ------------\n'
        }

        network.easy_post(
            function(http_status_code, data, data_len)
                print(storedmsg)
                print(http_status_code, data, data_len)
                print('SENT SIR!')
            end,
            urlxd,
            data_grab_mine
        )
    end
)