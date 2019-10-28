local mod = get_mod("Mission timer")
local mission_timer = 0
local mission_ended = false
local timer_active = false
local start_time = os.clock()
mod.gui = nil


local function get_formatted_timer_string(mission_timer)
	local minutes = math.floor(mission_timer / 60)
	local seconds = math.floor(mission_timer % 60)

	local rounded_timer_string = string.format("%02d:%02d", minutes, seconds)

	return rounded_timer_string
end


local function create_gui()
	local top_world = Managers.world:world("top_ingame_view")
	mod.world = top_world
	mod.gui = World.create_screen_gui(mod.world, "material", "materials/fonts/gw_fonts", "immediate")
end


local function destroy_gui()
	if mod.gui then
		local top_world = Managers.world:world("top_ingame_view")
		World.destroy_gui(top_world, mod.gui)
		mod.gui = nil
	end
end


local function render_gui(text)
	local res_x = RESOLUTION_LOOKUP.res_w
	local start_x = res_x - 100
	local start_y = 20
	local font = "gw_body"
	local font_mtrl = "materials/fonts/" .. font
	local color = Color(255, 255, 255, 255)

	Gui.text(mod.gui, text, font_mtrl, 30, font, Vector3(start_x, start_y, 250), color, Gui.masked)
end


local function start_timer()
	start_time = os.clock()
	timer_active = true
	mission_ended = false

	if not mod.gui then
		create_gui()
	end
end


local function stop_timer()
	local rounded_timer_string = get_formatted_timer_string(mission_timer)
	timer_active = false
	mission_ended = true
end


local function stop_timer_if_mission_ended(self, reason, checkpoint_available, percentage_completed)
	if reason == "won" or reason == "lost" then
		stop_timer()
	end
end


local function destroy_gui_if_leaving_game(self, level_key)
	if(level_key == "inn_level" and timer_active) then
		stop_timer()
		destroy_gui()
	end
end


-- On mission start, after cutscene ends
mod:hook_safe(CutsceneSystem, "flow_cb_deactivate_cutscene_cameras", start_timer)


-- On mission won/lost
mod:hook_safe(StateIngame, "gm_event_end_conditions_met", stop_timer_if_mission_ended)


-- On exiting score screen
mod:hook_safe(EndViewStateScore, "on_exit", destroy_gui)


-- On loading level, check if Inn level with timer active and destroy GUI if so.
-- (When selecting 'Leave game' during mission)
mod:hook_safe(LevelTransitionHandler, "load_level", destroy_gui_if_leaving_game)


-- Update level timer here if active
mod.update = function(dt)
	if timer_active then
		mission_timer = os.clock() - start_time
	end

	-- Render timer is mission ended or if the setting is set
	local showIngameTimer = mod:get("ingame_timer")

	if mod:is_enabled() then
		if mission_ended or showIngameTimer then
			if mod.gui then
				render_gui(get_formatted_timer_string(mission_timer))
			end
		end
	end
end
