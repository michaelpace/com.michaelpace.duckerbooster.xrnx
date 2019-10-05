renoise.tool():add_menu_entry {
	name = "Main Menu:Tools:New duckerbooster",
	invoke = function() create_new_duckerbooster() end
}

renoise.tool():add_keybinding {
	name = "Pattern Editor:Track Control:New duckerbooster",
	invoke = function(repeated)
		if (not repeated)
		then
			create_new_duckerbooster()
		end
	end
}

function create_new_duckerbooster()
	-- create wrapper group
	local main_group = renoise.song():insert_group_at(1)
	main_group.name = "duckerbooster"

	-- create duckerbooster group and add it to the wrapper group
	local duckerbooster_group = renoise.song():insert_group_at(1)
	duckerbooster_group.name = "ducker, booster"
	renoise.song():add_track_to_group(1, 2)

	-- add a track to duckerbooster group
	local duckerbooster_track = renoise.song():insert_track_at(1)
	renoise.song():add_track_to_group(1, 2)

	-- create ducked group and add it to the wrapper group
	local ducked_group = renoise.song():insert_group_at(1)
	ducked_group.name = "ducked"
	renoise.song():add_track_to_group(1, 4)

	-- add a track to ducked group
	local ducked_track = renoise.song():insert_track_at(1)
	renoise.song():add_track_to_group(1, 4)

	-- create boosted group and add it to the wrapper group
	local boosted_group = renoise.song():insert_group_at(1)
	boosted_group.name = "boosted"
	renoise.song():add_track_to_group(1, 6)

	-- add a track to boosted group
	local boosted_track = renoise.song():insert_track_at(1)
	renoise.song():add_track_to_group(1, 6)

	make_ducker(ducked_group, duckerbooster_group)
	make_booster(boosted_group, duckerbooster_group)
end

function make_ducker(ducked_group, duckerbooster_group)
	-- create ducker signal follower and gainer
	local ducked_gainer = ducked_group:insert_device_at("Audio/Effects/Native/Gainer", 2)
	local duckerbooster_ducker = duckerbooster_group:insert_device_at("Audio/Effects/Native/*Signal Follower", 2)

	-- set ducker's dest track to ducked group
	duckerbooster_ducker:parameter(1):record_value(3)
	-- set ducker's dest device to ducked group's gainer
	duckerbooster_ducker:parameter(2):record_value(1)
	-- set ducker's dest parameter to gainer's gain
	duckerbooster_ducker:parameter(3):record_value(1)
	-- set ducker's min to 0
	duckerbooster_ducker:parameter(4):record_value(0.25)
	-- set ducker's max to -inf
	duckerbooster_ducker:parameter(5):record_value(0)
	-- set ducker's sensitivity to 0.5
	duckerbooster_ducker:parameter(9):record_value(0.5)
end

function make_booster(boosted_group, duckerbooster_group)
	-- create booster signal follower and gainer
	local boosted_gainer = boosted_group:insert_device_at("Audio/Effects/Native/Gainer", 2)
	local duckerbooster_booster = duckerbooster_group:insert_device_at("Audio/Effects/Native/*Signal Follower", 3)

	-- set booster's dest track to boosted group
	duckerbooster_booster:parameter(1):record_value(5)
	-- set booster's dest device to boosted group's gainer
	duckerbooster_booster:parameter(2):record_value(1)
	-- set booster's dest parameter to gainer's gain
	duckerbooster_booster:parameter(3):record_value(1)
	-- set booster's min to -inf
	duckerbooster_booster:parameter(4):record_value(0)
	-- set booster's max to 0
	duckerbooster_booster:parameter(5):record_value(0.25)
	-- set ducker's sensitivity to 0.75
	duckerbooster_booster:parameter(9):record_value(0.75)
end
