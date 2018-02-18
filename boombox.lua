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

--EXAMPLE OF RECORDING AUDIO HANDLE TO KNOW WHEN TRACK ENDS?
--= function(pos, node, clicker, itemstack)
--    local meta = minetest.env:get_meta(pos)
--    if string.len(meta:get_string("hwnd")) > 0 then
--        minetest.sound_stop(meta:get_string("hwnd"))
 --       meta:set_string("hwnd",nil)
--	minetest.chat_send_all("Sound should be stopping now.")
 --   else
 --       meta:set_string("hwnd",minetest.sound_play(songs[math.random(1, #songs)], {pos = pos, gain = 1.0, max_hear_distance = 3, loop = true}))
--	minetest.chat_send_all("Sound should be playing now.")
  --  end
  --  end,
  --  on_destruct = function(pos)
 --   local meta = minetest.env:get_meta(pos)
 --   if string.len(meta:get_string("hwnd")) > 0 then minetest.sound_stop(meta:get_string("hwnd")) end
 --   end,
--})

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

minetest.register_craft({
	output = "music_devices:boom_box",
	recipe = {
		{"default:steel_ingot", "xpanes:pane", "default:steel_ingot", },
		{"default:steel_ingot", "default:nyancat_rainbow", "default:steel_ingot", },
		{"default:steel_ingot", "default:copper_ingot", "default:steel_ingot", }
	}
})

local function boom_box_player_screen(toodlepop)
	local viewer = tostring(toodlepop) --player:get_player_name()
	minetest.chat_send_all("bbps sees as: ", viewer)
	local text = "Ogg Boom Box"
	if is_playing == true then
		track_state = "Playing"
	elseif is_playing == false then
		track_state = "Selected"
	end
	local boom_box_form = "size[8.5,2.5]" ..
		"label[0.5,0;" ..text .. "]" ..
		"label[2.5,1;" ..track_state ..": " ..current_track .."]" ..
		"button[0.5,1.5;1.5,1.5;stop;■]" ..
		"button[2.5,1.5;1.5,1.5;back;|◄]" ..
		"button[4.5,1.5;1.5,1.5;play;►]" ..
		"button[6.5,1.5;1.5,1.5;forward;►|]" ..
		"button_exit[7,0;1,1;exit;X]"
	minetest.show_formspec(viewer, "boombox", boom_box_form)
end

minetest.register_on_player_receive_fields(function(player, form, pressed)
	if form == "boombox" then
		-- Magical shit that allows boom_box_player_screen to somehow recieve player ID.
		-- vvv I do not understand it's dark ways. vvv
		local listener = tostring(player:get_player_name())
		minetest.chat_send_all("recieve field sees player as: ", tostring(listener))
		if pressed.stop then
			minetest.chat_send_all("Pressed stop")
			stop_track()
			boom_box_player_screen(listener)
		end
		if pressed.back then
			minetest.chat_send_all("Pressed back")
			back_track()
		end
		if pressed.play then
			minetest.chat_send_all("Pressed play: ", listener)
			play_track(player)
			boom_box_player_screen(listener)
		end
		if pressed.forward then
			minetest.chat_send_all("Pressed forward: ", listener)
			forward_track(player)
			boom_box_player_screen(listener)
		end
	end
end)

minetest.register_node("music_devices:boom_box", {
	description = "Boom Box",
	drawtype = "nodebox",
	tiles = {"boombox_top.png", "boombox_bottom.png", "boombox_left.png",
		"boombox_right.png", "boombox_back.png", "boombox_front.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	stack_max = 1,
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=2}, --make non-flamable?
	sounds = default.node_sound_wood_defaults(),
	node_box = {
		type = "fixed",
	fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	},
	selection_box = {
		type = "fixed",
	fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	},
	on_rightclick = function(pos, node, clicker, itemstack)
		minetest.chat_send_all("user is: ".. tostring(clicker:get_player_name()))
		--player = tostring(clicker:get_player_name())
		boom_box_player_screen(clicker:get_player_name())
	end
})

-- once player detection is working, find way to make boom box play within area to nearby players

-- BUG boombox plays to all players simultaneously
