-- Placement works with any map generator: Lua generators such as Mineclonia's don't run the
-- engine's decorations, so mushrooms are placed in an on_generated pass instead.

local floor_names = {
	"default:stone",
	"default:desert_stone",
	"default:sandstone",
	"mcl_core:stone",
	"mcl_deepslate:deepslate",
	"mcl_core:granite",
	"mcl_core:diorite",
	"mcl_core:andesite",
	"mcl_core:tuff",
	"mcl_deepslate:tuff",
}

local floors = {}
local c_air, c_shroom

core.register_on_mods_loaded(function()
	for _, name in ipairs(floor_names) do
		if core.registered_nodes[name] then
			floors[core.get_content_id(name)] = true
		end
	end
	c_air = core.get_content_id("air")
	c_shroom = core.get_content_id("glowshroom:glowshroom")
end)

--- Can a glowshroom live at pos (air, with a cave-floor node below)?
function glowshroom.suitable(pos)
	if pos.y > glowshroom.max_y then
		return false
	end
	local here = core.get_node(pos).name
	local below = core.get_node(vector.offset(pos, 0, -1, 0)).name
	return here == "air" and floors[core.get_content_id(below)] == true
end

core.register_on_generated(function(minp, maxp, blockseed)
	if minp.y > glowshroom.max_y or not next(floors) then
		return
	end
	local vm, emin, emax = core.get_mapgen_object("voxelmanip")
	local area = VoxelArea(emin, emax)
	local data = vm:get_data()
	local rng = PcgRandom(blockseed)
	local threshold = math.floor(glowshroom.density * 1000000)
	local top = math.min(maxp.y, glowshroom.max_y)
	local placed = 0
	for z = minp.z, maxp.z do
		for y = minp.y + 1, top do
			local vi = area:index(minp.x, y, z)
			local below = area:index(minp.x, y - 1, z)
			for _ = minp.x, maxp.x do
				if data[vi] == c_air and floors[data[below]] and rng:next(0, 999999) < threshold then
					data[vi] = c_shroom
					placed = placed + 1
				end
				vi = vi + 1
				below = below + 1
			end
		end
	end
	if placed > 0 then
		vm:set_data(data)
		vm:calc_lighting()
		vm:write_to_map()
	end
end)

--- Try to spread from pos to a random neighbour; returns the new position or nil.
function glowshroom.try_spread(pos, rng)
	rng = rng or PcgRandom(core.hash_node_position(pos) + os.time())
	local target = vector.offset(pos, rng:next(-1, 1), rng:next(-1, 1), rng:next(-1, 1))
	if not glowshroom.suitable(target) then
		return nil
	end
	local light = core.get_node_light(target)
	if not light or light > 7 then
		return nil
	end
	local nearby = core.find_nodes_in_area(
		vector.offset(target, -3, -2, -3),
		vector.offset(target, 3, 2, 3),
		{ "group:glowshroom" }
	)
	if #nearby >= 6 then
		return nil
	end
	core.set_node(target, { name = "glowshroom:glowshroom" })
	return target
end

if glowshroom.spread then
	core.register_abm({
		label = "Glowshroom spreading",
		nodenames = { "glowshroom:glowshroom" },
		interval = 97,
		chance = 40,
		catch_up = false,
		action = function(pos)
			glowshroom.try_spread(pos)
		end,
	})
end
