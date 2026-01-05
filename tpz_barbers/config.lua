Config = {}

Config.Debug = false

Config.Keys = { 
    ["A"] = 0x7065027D, ["D"] = 0xB4E465B4, ['R'] = 0xE30CD707, ['G'] = 0x760A9C6F, ["ENTER"] = 0xC7B5340A, 
    ["SPACEBAR"] = 0xD9D0E1C0, ['BACKSPACE'] = 0x156F7119, ["W"] = 0x8FD015D8, ["S"] = 0xD27782E3,
    ["CursorScrollDown"] = 0x8BDE7443, ["CursorScrollUp"] = 0x62800C92, ["X"] = 0x8CC9CD42,
}

-----------------------------------------------------------
--[[ Prompts  ]]--
-----------------------------------------------------------

-- (!) You can't have the same key in multiple prompts but must be used only once.
Config.Prompts = {
    ['OPEN_STORE']  = {label = 'Press',  key = 'G' },
}

-----------------------------------------------------------
--[[ General Settings  ]]--
-----------------------------------------------------------

-- CASH ONLY.
Config.Prices = {
	['HAIR']         = 2.0,
	['BEARD']        = 1.0,
	['BEARDSTABBLE'] = 0.3, -- Beard Stabble (Beard Shaving Style) 
}

-----------------------------------------------------------
--[[ Locations ]]--
-----------------------------------------------------------

-- REMOVE HATS AND MASKS IF SOMEONE WEARS

Config.Stores = {

	['VALENTINE'] = {
		Coords = { x = -306.6778564453125, y = 813.5701904296875, z = 118.81075439453125 },

		CameraCoords = { x = -307.749, y = 813.2838, z = 119.38, h = 280.51296997, roty = 0.0, rotz = 280.0, zoom = 35.0},
		TeleportOutOfChairCoords = { x = -305.591, y = 813.7388, z = 117.98, h = 105.42394256},

        BlipData = {
            Enabled = true,
            Title   = "Barber Store",
            Sprite  = -2090472724,

            OpenBlipModifier = 'BLIP_MODIFIER_MP_COLOR_32',
            DisplayClosedHours = { Enabled = true, Sprite = -2090472724, BlipModifier = "BLIP_MODIFIER_MP_COLOR_2" },
        },

		Hours = { Allowed = true, Opening = 7, Closing = 23 },

        ActionMarkers = {
            Enabled = true,

            Distance = 10.0,
            RGBA = {r = 255, g = 255, b = 255, a = 155},
        },

        Lighting = vector3(-307.39, 813.43, 119.51),

		ActionDistance = 1.5,
	},
	
	['BLACKWATER'] = {
		
		Coords = { x = -815.3865356445312, y = -1367.056640625, z = 43.75 },
		CameraCoords = { x = -816.726, y = -1367.10, z = 44.150, h = 266.201263427, roty = 0.0, rotz = 265.0, zoom = 30.0},
     
		TeleportOutOfChairCoords = {x = -814.286, y = -1367.03, z = 42.750, h = 101.26686859},

        BlipData = {
            Enabled = true,
            Title   = "Barber Store",
            Sprite  = -2090472724,

            OpenBlipModifier = 'BLIP_MODIFIER_MP_COLOR_32',
            DisplayClosedHours = { Enabled = true, Sprite = -2090472724, BlipModifier = "BLIP_MODIFIER_MP_COLOR_2" },
        },

		Hours = { Allowed = true, Opening = 7, Closing = 23 },

        ActionMarkers = {
            Enabled = true,

            Distance = 10.0,
            RGBA = {r = 255, g = 255, b = 255, a = 155},
        },

        Lighting = vector3(-816.46, -1368.77, 44.26),

		ActionDistance = 1.2,
	},

	['SAINT_DENIS'] = {
		Coords = { x = 2655.335693359375, y = -1180.9898681640625, z = 53.21807403564453 },

		CameraCoords = { x = 2655.424, y = -1182.20, z = 53.678, h = 359.49063110, roty = 0.0, rotz = 3.0, zoom = 30.0},
		TeleportOutOfChairCoords = {x = 2655.350, y = -1179.92, z = 52.278, h = 185.249176025 },

        BlipData = {
            Enabled = true,
            Title   = "Barber Store",
            Sprite  = -2090472724,

            OpenBlipModifier = 'BLIP_MODIFIER_MP_COLOR_32',
            DisplayClosedHours = { Enabled = true, Sprite = -2090472724, BlipModifier = "BLIP_MODIFIER_MP_COLOR_2" },
        },

		Hours = { Allowed = true, Opening = 7, Closing = 23 },

        ActionMarkers = {
            Enabled = true,

            Distance = 10.0,
            RGBA = {r = 255, g = 255, b = 255, a = 155},
        },

        Lighting = vector3(2655.35, -1182.23, 54.07),

		ActionDistance = 1.5,
	},

}

-----------------------------------------------------------
--[[ Chair Removals ]]--
-----------------------------------------------------------

-- The wait time for checking the configured objects.
Config.WaitTime = 2000 -- Time in milliseconds.

-- The specified feature allows you to remove completely unwanted chairs.
-- This is not a requirement but its a must, otherwise when there are more than (1) chairs,
-- the player can sit on an unwanted chair than the one that must sit.

-- (!) SOME IN-GAME CHAIRS CANNOT BE FOUND AND BE REMOVED, ONLY THE ONES WE CAN.
Config.Chairs = { -- Set Config.Chairs = false TO DISABLE

	-- saint denis

	{ 
        Object = 'p_barberchair01x', -- left side chair
        Coords = { x = 2656.9677734375, y = -1180.96142578125, z = 52.27922439575195 },
        ObjectRenderDistance = 20.0,
    },

    { 
        Object = 'p_barberchair01x', -- right side chair
        Coords = { x = 2653.71337890625, y = -1180.9615478515625, z = 52.27922439575195 },
        ObjectRenderDistance = 20.0,
    },
}

-----------------------------------------------------------
--[[ Notification Functions  ]]--
-----------------------------------------------------------

-- @param source : The source always null when called from client.
-- @param type   : returns "error", "success", "info"
-- @param duration : the notification duration in milliseconds
function SendNotification(source, message, type, duration)

	if not duration then
		duration = 3000
	end

    if not source then
        TriggerEvent('tpz_core:sendBottomTipNotification', message, duration)
    else
        TriggerClientEvent('tpz_core:sendBottomTipNotification', source, message, duration)
    end
  
end

-----------------------------------------------------------
--[[ DO NOT TOUCH WITHOUT KNOWLEDGE ]]--
-----------------------------------------------------------

local palettes = {
    joaat("METAPED_TINT_MAKEUP"),
    joaat("METAPED_TINT_SKIRT_CLEAN"),
    joaat("METAPED_TINT_HAT_WORN"),
    joaat("METAPED_TINT_SWATCH_002"),
    joaat("METAPED_TINT_HAT_CLEAN"),
    joaat("METAPED_TINT_SWATCH_003"),
    joaat("METAPED_TINT_GENERIC_CLEAN"),
    joaat("METAPED_TINT_HAT_WEATHERED"),
    joaat("METAPED_TINT_COMBINED"),
    joaat("METAPED_TINT_HORSE_LEATHER"),
    joaat("METAPED_TINT_ANIMAL"),
    joaat("METAPED_TINT_SWATCH_001"),
    joaat("METAPED_TINT_HORSE"),
    joaat("METAPED_TINT_EYE"),
    joaat("METAPED_TINT_GENERIC_CLEAN"),
    joaat("METAPED_TINT_GENERIC_WORN"),
    joaat("METAPED_TINT_SKIRT_WEATHERED"),
    joaat("METAPED_TINT_SWATCH_000"),
    joaat("METAPED_TINT_LEATHER"),
    joaat("METAPED_TINT_MPADV"),
    joaat("METAPED_TINT_SKIRT_WORN"),
    joaat("METAPED_TINT_HAIR"),
    joaat("METAPED_TINT_COMBINED_LEATHER"),
    joaat("METAPED_TINT_GENERIC_WEATHERED"),
    joaat("METAPED_TINT_HAT"),
    joaat("WEAPON_TINT_WOOD"),
    joaat("WEAPON_TINT_WOOD_WORKING"),
}

Config.color_palettes = {
    beardstabble = palettes,
    hair = palettes,
}

Config.overlays_info = {

    beardstabble = {
        { id = 0x375D4807, albedo = 0xB5827817, normal = 0x5041B648, ma = 0x83F42340, },
    },

    hair = {
        { id = 0x39051515, albedo = 0x60A4A360, normal = 0x8D65EFF2, ma = 0x62759D82, },
        { id = 0x5E71DFEE, albedo = 0x71147B90, ma = 0xD8EB57BC, },
        { id = 0xDD735DEF, albedo = 0x493214E4, ma = 0x6613D121, },
        { id = 0x69622EAD, albedo = 0xA6E819C4, ma = 0xE581D851, },
    },
}


Config.ComponentCategories = {
    beardsmustache = `BEARDS_MUSTACHE`,
    hair = `HAIR`,
    beard = `BEARDS_COMPLETE`,
}


Config.texture_types = {
    ['Male'] = {
        albedo = joaat("mp_head_mr1_sc08_c0_000_ab"),
        normal = joaat("mp_head_mr1_008_nm"),
        material = joaat("mp_head_mr1_000_m"),
        color_type = 1,
        texture_opacity = 1.0,
        unk_arg = 0,
    },
    ['Female'] = {
        albedo = joaat("mp_head_fr1_sc08_c0_000_ab"),
        normal = joaat("mp_head_fr1_008_nm"),
        material = joaat("mp_head_fr1_000_m"),
        color_type = 1,
        texture_opacity = 1.0,
        unk_arg = 0,
    }
}

Config.overlay_all_layers = {

    {
        name = "beardstabble",
        visibility = 0,
        tx_id = 1,
        tx_normal = 0,
        tx_material = 0,
        tx_color_type = 0,
        tx_opacity = 1.0,
        tx_unk = 0,
        palette = 0,
        palette_color_primary = 0,
        palette_color_secondary = 0,
        palette_color_tertiary = 0,
        var = 0,
        opacity = 1.0,
    },

    {
        name = "hair",
        visibility = 0,
        tx_id = 1,
        tx_normal = 0,
        tx_material = 0,
        tx_color_type = 0,
        tx_opacity = 1.0,
        tx_unk = 0,
        palette = 0,
        palette_color_primary = 0,
        palette_color_secondary = 0,
        palette_color_tertiary = 0,
        var = 0,
        opacity = 1.0,
    },

}
