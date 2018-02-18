if minetest.get_current_modname() ~= "music_devices" then
   error("Mod directory must be named 'music_devices'");
end

dofile(minetest.get_modpath("music_devices") .. "/portable.lua")
dofile(minetest.get_modpath("music_devices") .. "/boombox.lua")

--[[
minetest.register_node("radio:radio", {
    description = "Radio",
    drawtype = "nodebox",
    tiles = {"radio_top.png", "radio_bottom.png", "radio_left.png",
        "radio_right.png", "radio_back.png", "radio_front.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    stack_max = 1,
    groups = {choppy=2,oddly_breakable_by_hand=2,flammable=2},
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
    local meta = minetest.env:get_meta(pos)
    if string.len(meta:get_string("hwnd")) > 0 then
        minetest.sound_stop(meta:get_string("hwnd"))
        meta:set_string("hwnd",nil)
	minetest.chat_send_all("Sound should be stopping now.")
    else
        meta:set_string("hwnd",minetest.sound_play(songs[math.random(1, #songs)], {pos = pos, gain = 1.0, max_hear_distance = 3, loop = true}))
	minetest.chat_send_all("Sound should be playing now.")
    end
    end,
    on_destruct = function(pos)
    local meta = minetest.env:get_meta(pos)
    if string.len(meta:get_string("hwnd")) > 0 then minetest.sound_stop(meta:get_string("hwnd")) end
    end,
})
]]


--[[
minetest.register_craft({
    output = "radio:radio",
    recipe = {
        {"default:steel_ingot", "default:steel_ingot", "default:steel_ingot", },
        {"default:steel_ingot", "default:chest", "default:steel_ingot", },
        {"default:stick", "", "default:stick", }
    }
})
]]

--minetest.register_abm(
--	{nodenames = {"radio:radio"},
--	interval = 2.0,
--	chance = 1,
--	--play audio to nearby players
--	action = function(pos)
--	local objects = minetest.get_objects_inside_radius(pos, 5)
--	local is_playing
--	for i, obj in ipairs(objects) do
--		if (obj:is_player()) then
--			if is_playing == nil then
--				minetest.sound_play(songs[math.random(1, #songs)], {pos = pos, gain = 1.0, max_hear_distance = 3})
--				is_playing = true
--			elseif is_playing ~= nil then
--				is_playing = nil
--			end
--		end
--	end
--end,
--})



-- BUG music plays to all players, but pressing back |< stops for others and leaves playing for correct player. (or just aligns for both)
