local mod = get_mod("Mission timer")

return {
	name = "Mission timer",
	description = "Displays mission time ([minutes:seconds]) during and/or after mission.",
	is_togglable = true,
	options = {
		widgets = {
			{
				["setting_id"] = "ingame_timer",
				["type"] = "checkbox",
				["title"] = "ingame_timer_title",
				["tooltip"] = "ingame_timer_tooltip",
				["default_value"] = true
			}
		}
	}
}
