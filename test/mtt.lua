-- Integration tests, run inside the engine by `avanti test` (https://github.com/BuckarooBanzay/mtt).

mtt.register("glowshroom: nodes are registered", function(callback)
	assert(core.registered_nodes["glowshroom:glowshroom"], "glowshroom missing")
	assert(core.registered_nodes["glowshroom:lamp"], "lamp missing")
	assert(core.registered_nodes["glowshroom:glowshroom"].light_source > 0)
	callback()
end)

mtt.register("glowshroom: lamp recipe uses only existing items", function(callback)
	local recipe = core.get_craft_recipe("glowshroom:lamp")
	assert(recipe and recipe.items, "no lamp recipe in this game")
	for _, item in pairs(recipe.items) do
		assert(core.registered_items[item], "unknown item in recipe: " .. item)
	end
	callback()
end)

mtt.register_with_area("glowshroom: grows on a dark cave floor", {
	size = { x = 5, y = 4, z = 5 },
	emerged = true,
}, function(pos1, _, callback)
	local floor_name = core.registered_nodes["default:stone"] and "default:stone" or "mcl_core:stone"
	local base = vector.new(pos1.x, glowshroom.max_y - 20, pos1.z)
	core.load_area(vector.offset(base, -1, -1, -1), vector.offset(base, 1, 3, 1))
	core.set_node(base, { name = floor_name })
	local spot = vector.offset(base, 0, 1, 0)
	core.set_node(spot, { name = "air" })
	assert(glowshroom.suitable(spot), "a stone floor with air above should be suitable")
	core.set_node(spot, { name = "glowshroom:glowshroom" })
	assert(core.get_node(spot).name == "glowshroom:glowshroom")
	assert(not glowshroom.suitable(vector.new(base.x, glowshroom.max_y + 10, base.z)), "too high")
	callback()
end)

-- Generate a large underground area and check that caves get glowshrooms.
local area_min, area_max = vector.new(-160, -60, -160), vector.new(160, -20, 160)
mtt.emerge_area(area_min, area_max)

mtt.register("glowshroom: generates on cave floors", {
	timeout = 120,
	func = function(callback)
		local found = core.find_nodes_in_area(area_min, area_max, { "glowshroom:glowshroom" })
		core.log("action", "[glowshroom] generated " .. #found .. " glowshrooms in the test area")
		assert(#found > 0, "no glowshrooms generated in " .. core.pos_to_string(area_min) .. "–"
			.. core.pos_to_string(area_max))
		callback()
	end,
})
