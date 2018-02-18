local tracks = {"Donkey_House",
"My_Cool_Boots",
"Late_Night_Height",
"Thatch_Fever",
"Two_Quarks"}
--[[
Deep House (Donkey House) by keinzweiter, freesound.org
Custom Groovy Beat (My Cool Boots) by monkeyman535, freesoung.org
b80 02 Freesound (Late Night Height) by milton., freesound.org
Safari Music Loop (Thatch Fever) by Sirkoto51, freesound.org
Short Loops 21 02 2015 (Two Quarks) by B_Lamerichs, freesound.org
]]

local current_track = tracks[math.random(1, #tracks)]
local handle
local is_playing = false

local stop_track = function()
	if is_playing == true then
		minetest.sound_stop(handle)
		is_playing = false
		minetest.chat_send_all("Stopping track")
	end
	if is_playing == false then
		minetest.chat_send_all("do nothing")
	end
end

local back_track = function()
	if is_playing == true then
		minetest.sound_stop(handle)
		handle = minetest.sound_play(current_track, {to_player = player, gain = 1.0})
		minetest.chat_send_all(current_track.. " should be playing now.")
	end
	if is_playing == false then
		minetest.chat_send_all("do nothing")
	end
end

local play_track = function(player)
	if is_playing == false then
		is_playing = true
		handle = minetest.sound_play(current_track, {to_player = player, gain = 1.0})
		minetest.chat_send_all(current_track.. " should be playing now.")		
	end
	if is_playing == true then
		minetest.chat_send_all(handle)
	end
end

local forward_track = function(player)
	-- Clear old entries from last "next_tracks" table
	local next_tracks = {}
	minetest.chat_send_all("Current track is: ".. tostring(current_track))
	-- Shuffle tracks for next track, excluding the one already playing
	for index, track in pairs(tracks) do
		if tostring(track) ~= tostring(current_track) then
			next_tracks[#next_tracks + 1] = tostring(track)
			minetest.chat_send_all(track.. " selected")
		end
	end
	-- Update the current track with new shuffle selection
	current_track = next_tracks[math.random(1, #next_tracks)]
	minetest.chat_send_all("Track changed to ".. tostring(current_track))
	-- Play newly selected track
	if is_playing == true then
		minetest.sound_stop(handle)
		handle = minetest.sound_play(current_track, {to_player = player, gain = 1.0})
	end
	if is_playing == false then
		minetest.chat_send_all("do nothing")
	end
end

local function ogg_portable_screen(player)
	local viewer = player:get_player_name()
	local text = "Ogg Portable"
	if is_playing == true then
		track_state = "Playing"
	elseif is_playing == false then
		track_state = "Selected"
	end
	local ogg_portable_form = "size[8.5,2.5]" ..
		"label[0.5,0;" ..text .. "]" ..
		"label[2.5,1;" ..track_state ..": " ..current_track .."]" ..
		"button[0.5,1.5;1.5,1.5;stop;■]" ..
		"button[2.5,1.5;1.5,1.5;back;|◄]" ..
		"button[4.5,1.5;1.5,1.5;play;►]" ..
		"button[6.5,1.5;1.5,1.5;forward;►|]" ..
		"button_exit[7,0;1,1;exit;X]"
	minetest.show_formspec(viewer, "interface", ogg_portable_form)
end

minetest.register_on_player_receive_fields(function(player, form, pressed)
	if form == "interface" then
		if pressed.stop then
			minetest.chat_send_all("Pressed stop")
			stop_track()
			ogg_portable_screen(player)
		end
		if pressed.back then
			minetest.chat_send_all("Pressed back")
			back_track()
		end
		if pressed.play then
			minetest.chat_send_all("Pressed play")
			play_track(player)
			ogg_portable_screen(player)
		end
		if pressed.forward then
			minetest.chat_send_all("Pressed forward")
			forward_track(player)
			ogg_portable_screen(player)
		end
	end
end)

minetest.register_craftitem("music_devices:ogg_portable", {
	description = "Portable Music Player",
	inventory_image = "ogg_portable.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
	minetest.chat_send_all("user is: ".. tostring(user:get_player_name()))
	player = tostring(user:get_player_name())
	ogg_portable_screen(user)
	end
})

minetest.register_craft({
	output = "music_devices:ogg_portable",
	recipe = {
		{"xpanes:pane", "farming:string",},
		{"default:nyancat_rainbow", "farming:string",},
		{"default:copper_ingot", "",}
	}
})
