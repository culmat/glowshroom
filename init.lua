-- Glowshrooms: bioluminescent mushrooms that grow in dark caves of any game.
local modname = core.get_current_modname()
local modpath = core.get_modpath(modname)

-- The mod's only global: its API table. Keep everything else local.
glowshroom = {
	S = core.get_translator(modname),
	-- Generation and spreading only happen below this height.
	max_y = tonumber(core.settings:get("glowshroom_max_y")) or -16,
	-- Chance per suitable cave-floor node in a generated chunk.
	density = tonumber(core.settings:get("glowshroom_density")) or 0.004,
	spread = core.settings:get_bool("glowshroom_spread", true),
}

dofile(modpath .. "/nodes.lua")
dofile(modpath .. "/mapgen.lua")
dofile(modpath .. "/crafting.lua")

if core.get_modpath("mtt") and mtt.enabled then
	dofile(modpath .. "/test/mtt.lua")
end
