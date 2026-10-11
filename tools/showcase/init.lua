-- Inside the world in every game (MineClone-like games end at y = -64).
local origin = vector.new(0, -30, 0)
local stone_name = core.registered_nodes["default:stone"] and "default:stone" or "mcl_core:stone"
local function build()
	local stone, air = { name = stone_name }, { name = "air" }
	for x = -7, 7 do
		for y = -1, 5 do
			for z = -7, 7 do
				local edge = math.abs(x) == 7 or math.abs(z) == 7 or y == -1 or y == 5
				core.set_node(vector.offset(origin, x, y, z), edge and stone or air)
			end
		end
	end
	-- boulders and a ledge for depth
	for _, p in ipairs({ { -4, 0, 3 }, { -5, 0, 4 }, { -5, 1, 4 }, { 4, 0, 2 }, { 5, 0, 5 }, { 5, 1, 5 }, { 0, 0, 6 } }) do
		core.set_node(vector.offset(origin, p[1], p[2], p[3]), stone)
	end
	local shrooms = {
		-- foreground, lighting the floor in front of the camera
		{ -2, 0, -2 },
		{ 1, 0, -3 },
		{ 2, 0, -1 },
		{ -1, 0, 0 },
		-- the main patch
		{ -2, 0, 2 },
		{ -1, 0, 3 },
		{ 0, 0, 2 },
		{ 1, 0, 3 },
		{ 2, 0, 2 },
		{ 0, 0, 4 },
		{ -3, 0, 1 },
		-- on the boulders and in the corners
		{ -4, 1, 3 },
		{ -5, 2, 4 },
		{ 4, 1, 2 },
		{ 5, 2, 5 },
		{ 6, 0, 0 },
		{ -6, 0, -1 },
		{ 0, 1, 6 },
	}
	for _, p in ipairs(shrooms) do
		core.set_node(vector.offset(origin, p[1], p[2], p[3]), { name = "glowshroom:glowshroom" })
	end
	-- two lamps in plain view
	core.set_node(vector.offset(origin, -3, 0, 5), { name = "glowshroom:lamp" })
	core.set_node(vector.offset(origin, 3, 0, 4), { name = "glowshroom:lamp" })
end
core.register_on_joinplayer(function(player)
	core.emerge_area(vector.offset(origin, -10, -3, -10), vector.offset(origin, 10, 8, 10), function(_, _, remaining)
		if remaining > 0 then
			return
		end
		build()
		core.fix_light(vector.offset(origin, -8, -2, -8), vector.offset(origin, 8, 6, 8))
		player:set_pos(vector.offset(origin, 0, 0.5, -5))
		player:set_look_horizontal(0)
		player:set_look_vertical(0.32)
		player:hud_set_flags({
			hotbar = false,
			healthbar = false,
			crosshair = false,
			wielditem = false,
			breathbar = false,
			minimap = false,
			basic_debug = false,
			chat = false,
		})
		core.set_timeofday(0)
		if avanti_camera then -- avanti screenshot: the scene is ready for the shot list
			avanti_camera.scene_ready()
		end
	end)
end)
