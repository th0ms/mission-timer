return {
	run = function()
		fassert(rawget(_G, "new_mod"), "Mission timer must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("Mission timer", {
			mod_script       = "scripts/mods/Mission timer/Mission timer",
			mod_data         = "scripts/mods/Mission timer/Mission timer_data",
			mod_localization = "scripts/mods/Mission timer/Mission timer_localization"
		})
	end,
	packages = {
		"resource_packages/Mission timer/Mission timer"
	}
}
