local AIO = {
  Evelynn = true,
  Hecarim = true,
  Khazix = true,
  Diana = true,
  Nidalee = false,
  Nasus = false,
  MasterYi = true,
  Kayn = true,
  Udyr = true,
  Irelia = false,
  Katarina = true,
  RekSai = true,
  Gnar = false,
  Rengar = true,
  Shyvana = true,
  Leblanc = true,
  Nidalee = true,
}
return {
    id = "trent_aio",
    name = "Trent AIO",
    author = "Trent",
    description = [[Evelynn, Hecarim, Kha'Zix, Diana, MasterYi, Kayn, Udyr, Katarina, RekSai]],
    shard = {'main', 'Champions/Evelynn', 'Champions/Nidalee','Champions/Leblanc', 'Champions/Shyvana', 'Champions/Rengar', 'Champions/Hecarim', 'Champions/Khazix', 'Champions/Katarina', 'Champions/Kayn', 'Champions/Diana', 'Champions/Udyr', 'Champions/MasterYi', 'Champions/RekSai', 'common2', 'crashreporter'},
    discord_url = 'https://discord.gg/t2FVr9uhsZ',

    load = function() return AIO[player.charName] end
}
