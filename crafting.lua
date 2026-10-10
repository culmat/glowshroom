local glass = xcompat.materials.glass
if glass and glass ~= "" then
	core.register_craft({
		output = "glowshroom:lamp",
		recipe = {
			{ "", "glowshroom:glowshroom", "" },
			{ "glowshroom:glowshroom", glass, "glowshroom:glowshroom" },
			{ "", "glowshroom:glowshroom", "" },
		},
	})
end

core.register_craft({
	type = "fuel",
	recipe = "glowshroom:glowshroom",
	burntime = 2,
})
