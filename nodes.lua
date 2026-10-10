local S = glowshroom.S

-- Mineclonia and VoxeLibre dig by "handy" and need _mcl_* hardness values;
-- Minetest Game and most others use snappy/cracky. Giving both works everywhere.
core.register_node("glowshroom:glowshroom", {
	description = S("Glowshroom"),
	_doc_items_longdesc = S("A bioluminescent mushroom that grows on cave floors and slowly spreads in darkness."),
	drawtype = "plantlike",
	tiles = { "glowshroom_glowshroom.png" },
	inventory_image = "glowshroom_glowshroom.png",
	wield_image = "glowshroom_glowshroom.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	floodable = true,
	light_source = 6,
	selection_box = { type = "fixed", fixed = { -4 / 16, -0.5, -4 / 16, 4 / 16, 2 / 16, 4 / 16 } },
	groups = {
		snappy = 3,
		handy = 1,
		dig_immediate = 3,
		attached_node = 1,
		flammable = 2,
		dig_by_water = 1,
		deco_block = 1,
		glowshroom = 1,
	},
	sounds = xcompat.sounds.node_sound_leaves_defaults(),
	_mcl_hardness = 0,
	_mcl_blast_resistance = 0,
})

core.register_node("glowshroom:lamp", {
	description = S("Glowshroom Lamp"),
	_doc_items_longdesc = S("A glass block filled with glowshrooms. It gives off a soft, cold light."),
	tiles = { "glowshroom_lamp.png" },
	paramtype = "light",
	light_source = 13,
	groups = { cracky = 3, oddly_breakable_by_hand = 3, handy = 1, building_block = 1 },
	sounds = xcompat.sounds.node_sound_glass_defaults(),
	_mcl_hardness = 0.3,
	_mcl_blast_resistance = 0.3,
})
