local origin = vector.new(0, -200, 0)
local function build()
	local stone, air = { name = "default:stone" }, { name = "air" }
	for x = -7, 7 do
		for y = -1, 5 do
			for z = -7, 7 do
				local edge = math.abs(x) == 7 or math.abs(z) == 7 or y == -1 or y == 5
				core.set_node(vector.offset(origin, x, y, z), edge and stone or air)
			end
		end
	end
	-- a few boulders and a ledge for depth
	for _, p in ipairs({ { -3, 0, 2 }, { -4, 0, 3 }, { 3, 0, -1 }, { 4, 0, 4 }, { 4, 1, 4 }, { -5, 0, -3 } }) do
		core.set_node(vector.offset(origin, p[1], p[2], p[3]), stone)
	end
	local shrooms = { { -2, 0, 3 }, { -3, 1, 2 }, { -1, 0, 4 }, { 0, 0, 3 }, { 2, 0, 2 }, { 3, 1, -1 }, { 3, 0, 0 },
		{ 4, 2, 4 }, { 5, 0, 3 }, { -5, 1, -3 }, { -4, 0, -2 }, { 1, 0, 5 }, { -1, 0, 1 }, { 2, 0, 5 } }
	for _, p in ipairs(shrooms) do
		core.set_node(vector.offset(origin, p[1], p[2], p[3]), { name = "glowshroom:glowshroom" })
	end
	core.set_node(vector.offset(origin, 6, 0, 6), { name = "glowshroom:lamp" })
	core.set_node(vector.offset(origin, -6, 0, 6), { name = "glowshroom:lamp" })
end
core.register_on_joinplayer(function(player)
	core.emerge_area(vector.offset(origin, -10, -3, -10), vector.offset(origin, 10, 8, 10), function(_, _, remaining)
		if remaining > 0 then return end
		build()
		core.fix_light(vector.offset(origin, -8, -2, -8), vector.offset(origin, 8, 6, 8))
		player:set_pos(vector.offset(origin, 0, 0.5, -5))
		player:set_look_horizontal(0)
		player:set_look_vertical(0.25)
		player:hud_set_flags({ hotbar = false, healthbar = false, crosshair = false, wielditem = false,
			breathbar = false, minimap = false, basic_debug = false, chat = false })
		core.set_timeofday(0)
	end)
end)
