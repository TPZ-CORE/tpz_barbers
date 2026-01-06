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
    ['HAIR_OVERLAY'] = 0.3, -- Hair Overlays
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

            Distance = 5.0,
            RGBA = {r = 255, g = 255, b = 255, a = 100},
        },

        Lighting = vector3(-307.39, 813.43, 119.51),

		ActionDistance = 1.7,
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

            Distance = 5.0,
            RGBA = {r = 255, g = 255, b = 255, a = 100},
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

            Distance = 5.0,
            RGBA = {r = 255, g = 255, b = 255, a = 100},
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
    eyebrows = palettes,
    beardstabble = palettes,
    hair = palettes,
}

Config.overlays_info = {

    eyebrows     = {
        { id = 0x07844317, albedo = 0xF81B2E66, normal = 0x7BC4288B, ma = 0x202674A1, },
        { id = 0x0A83CA6E, albedo = 0x8FA4286B, normal = 0xBD811948, ma = 0xB82C8FBB, },
        { id = 0x139A5CA3, albedo = 0x487ABE5A, normal = 0x22A9DDF9, ma = 0x78AA9401, },
        { id = 0x1832E474, albedo = 0x96FBB931, normal = 0x32FA2683, ma = 0xA1775B18, },
        { id = 0x216EF84C, albedo = 0x269CD8F8, normal = 0x2F54C727, ma = 0xCCBD1939, },
        { id = 0x2594304D, albedo = 0xA5A23CD1, normal = 0x8611B42C, ma = 0x0238302B, },
        { id = 0x33C39BC5, albedo = 0xF928E29B, normal = 0x46C268BD, ma = 0x4B92F13E, },
        { id = 0x443E3CBA, albedo = 0x6C83B571, normal = 0x2B191070, ma = 0xD551E623, },
        { id = 0x4F5052DE, albedo = 0x827EEF46, normal = 0x70E8C702, ma = 0xD97518F9, },
        { id = 0x5C049D35, albedo = 0x41E90506, normal = 0x7E47D163, ma = 0x54100288, },
        { id = 0x77A1546E, albedo = 0x43C4AE44, normal = 0x290FC7F7, ma = 0xD8FC26A9, },
        { id = 0x8A4B79C2, albedo = 0xAE6ED4E6, normal = 0x89B29E5A, ma = 0xFA0476E4, },
        { id = 0x9728137B, albedo = 0x23E65D35, normal = 0xEE39073F, ma = 0x218DD4C8, },
        { id = 0xA6DE8325, albedo = 0x7A93F649, normal = 0x22B33B65, ma = 0xEE6CCF11, },
        { id = 0xA8CCB6C4, albedo = 0x29AD8BF9, normal = 0x34ABB09D, ma = 0xCF206860, },
        { id = 0xB3F74D19, albedo = 0x3E2F71B1, normal = 0xD4809D11, ma = 0x9ABFA640, },
        { id = 0xBD38AFD9, albedo = 0x058A698E, normal = 0x9A732F86, ma = 0x2EF1D769, },
        { id = 0xCD0A4F7C, albedo = 0xED46998E, normal = 0xB5B73A38, ma = 0x15C5FB78, },
        { id = 0xD0EC86FF, albedo = 0x81B462A2, normal = 0x894F8744, ma = 0x51551810, },
        { id = 0xEB088A20, albedo = 0x0C6CDBDC, normal = 0x91A2496E, ma = 0xE639F138, },
        { id = 0xF0CA96FC, albedo = 0xAC3BCA3F, normal = 0x667FEFF8, ma = 0xDD8E5EFF, },
        { id = 0xF3351BD9, albedo = 0xC3286EA4, normal = 0x8BB9158A, ma = 0xFBBAE4D8, },
        { id = 0xF9052779, albedo = 0x8AEADE78, normal = 0x21BB2D97, ma = 0x75A0B928, },
        { id = 0xFE183197, albedo = 0x92B508CD, normal = 0x6AA92A3E, ma = 0xB4A436DB, },
    },

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
    eyebrows = `EYEBROWS`,
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
        name = "eyebrows", -- dont change
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
        opacity = 0.0,
    },
    
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
