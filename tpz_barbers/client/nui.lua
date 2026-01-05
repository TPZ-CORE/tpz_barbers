local TPZ = exports.tpz_core:getCoreAPI()

local CameraHandler   = {coords = nil, zoom = 0, z = 0 }
local COORDS_TO_TELEPORT_OUT  = nil
local SELECTED_CATEGORY_TYPE = nil

local DefaultPlayerSkin  = {} -- The skin (hair, beard, beardstabble) when entering the store (required for resets).
local SelectedPlayerSkin = {} -- The selected skin (hair, beard, beardstabble)
local Groom              = nil


-----------------------------------------------------------
--[[ Local Functions ]]--
-----------------------------------------------------------

local ToggleUI = function(display, data)

    local PlayerData = GetPlayerData()

    if not display then 

        while not IsScreenFadedOut() do
            Wait(50)
            DoScreenFadeOut(2000)
        end

        DestroyAllCams(true)

        SetNuiFocus(display, display)

        SendNUIMessage({ type = "enable", enable = display })

        PlayerData.HasNUIActive = false
        
        FreezeEntityPosition(PlayerPedId(), false)
        ClearPedTasksImmediately(PlayerPedId(), true)
        local coords = COORDS_TO_TELEPORT_OUT
        TPZ.TeleportToCoords(coords.x, coords.y, coords.z, coords.h)

        Wait(2000)
        DoScreenFadeIn(2000)

    else
        SetNuiFocus(display, display)
    
        SendNUIMessage({ type = "enable", enable = display })

    end
end

local function SetGroomTexture(data)   
    
    local actionType, texture_id, color = data.type, data.texture_id, data.color

    local ClientData = exports.tpz_core:getCoreAPI().GetPlayerClientData()
    local PlayerSkin = ClientData.skinComp
    
    PlayerSkin = json.decode(PlayerSkin)
    
    if SELECTED_CATEGORY_TYPE == 'hair' or SELECTED_CATEGORY_TYPE == 'beard' then
    
        if Config.Debug then
            print('[UPDATE] : Character Groom Modification Request:', "Category: " .. SELECTED_CATEGORY_TYPE, "Type: " .. actionType, "Texture ID: " .. texture_id, "Color: " .. color)
        end
    
        if SelectedPlayerSkin[SELECTED_CATEGORY_TYPE] == nil then
            SelectedPlayerSkin[SELECTED_CATEGORY_TYPE] = {}
        end
    
        local visibility = texture_id == 0 and 0 or 1
    
        SelectedPlayerSkin[SELECTED_CATEGORY_TYPE] = { 
            id         = texture_id, 
            color      = color, 
        }

        if SelectedPlayerSkin[SELECTED_CATEGORY_TYPE] and PlayerSkin[SELECTED_CATEGORY_TYPE] then
            -- We remove selected player skin in case its the same as the default one when opened the store.
            if tonumber(SelectedPlayerSkin[SELECTED_CATEGORY_TYPE].id) == tonumber(PlayerSkin[SELECTED_CATEGORY_TYPE].id) and tonumber(SelectedPlayerSkin[SELECTED_CATEGORY_TYPE].color) == tonumber(PlayerSkin[SELECTED_CATEGORY_TYPE].color) then
                SelectedPlayerSkin[SELECTED_CATEGORY_TYPE] = nil
            end
            
        end

        local modules = TPZ.modules()
    
        modules.IsPedReadyToRender()
    
        if texture_id > 0 then 
    
            local hash = Groom[SELECTED_CATEGORY_TYPE][texture_id][color].hex
    
            modules.ApplyShopItemToPed(hash)
        else
            local capitalizedCategoryName = TPZ.Capitalize(SELECTED_CATEGORY_TYPE)
            RemoveTagFromMetaPed(PlayerPedId(), Config.ComponentCategories[capitalizedCategoryName])
        end
    
        if actionType == 'texture_id' then 
    
            SendNUIMessage({
                action = 'updateGroomSpecificData',
                max_colors = Groom[SELECTED_CATEGORY_TYPE][texture_id] ~= nil and #Groom[SELECTED_CATEGORY_TYPE][texture_id] or 1,
                category   = SELECTED_CATEGORY_TYPE,
            })
    
        end
    
        modules.UpdatePedVariation()
    else 
    
        local opacity   = tonumber(data.opacity)
        local _category = SELECTED_CATEGORY_TYPE == 'overlay' and 'hair_overlay' or SELECTED_CATEGORY_TYPE
        category = SELECTED_CATEGORY_TYPE == 'overlay' and 'hair' or SELECTED_CATEGORY_TYPE
    
        if Config.Debug then
            print('[UPDATE] : Character Groom Modification Request:', "Category: " .. _category, "Type: " .. actionType, "Texture ID: " .. texture_id, "Color: " .. color, "Opacity: " .. opacity)
        end
    
        if SelectedPlayerSkin[_category] == nil then
            SelectedPlayerSkin[_category] = {}
        end
    
        local newOpacity = math.type(opacity) == "integer" and (opacity > 0 and opacity / 10 or 0.0) or opacity 
       
        SelectedPlayerSkin[_category] = { 
            id         = texture_id, 
            color      = color, 
            visibility = data.visibility or 1, 
            opacity    = newOpacity
        }

        local visibility = (SelectedPlayerSkin[_category].id ~= 0 and SelectedPlayerSkin[_category].opacity > 0.0) and 1 or 0
        SelectedPlayerSkin[_category].visibility = visibility
    
        ApplyOverlay(category, visibility, SelectedPlayerSkin[_category].id, 1, 0, 0, 1.0, 0, 1, SelectedPlayerSkin[_category].color, 0, 0, 1, SelectedPlayerSkin[_category].opacity, PlayerSkin.albedo)
    
        if actionType == 'texture_id' then 
    
            SendNUIMessage({
                action = 'updateGroomSpecificData',
                max_colors = #Config.color_palettes[category],
                category   = SELECTED_CATEGORY_TYPE,
            })
    
        end
    
        if SelectedPlayerSkin[_category] and PlayerSkin[_category] then

            -- We remove selected player skin in case its the same as the default one when opened the store.
            if tonumber(SelectedPlayerSkin[_category].id) == tonumber(PlayerSkin[_category].id) and tonumber(SelectedPlayerSkin[_category].color) == tonumber(PlayerSkin[_category].color) then
               
                if tonumber(SelectedPlayerSkin[_category].visibility) == tonumber(PlayerSkin[_category].visibility) and tonumber(SelectedPlayerSkin[_category].opacity) == tonumber(PlayerSkin[_category].opacity) then
                    SelectedPlayerSkin[_category] = nil
                end
        
            end

        end
    
    end

end

-----------------------------------------------------------
--[[ Functions ]]--
-----------------------------------------------------------

function GetCameraHandler()
    return CameraHandler
end

function OpenCharacterCustomization(locationIndex)
    local PlayerData   = GetPlayerData()
    local LocationData = Config.Stores[locationIndex]
    
    while not IsScreenFadedOut() do
        Wait(50)
        DoScreenFadeOut(2000)
    end

    Wait(2000)

    COORDS_TO_TELEPORT_OUT = LocationData.TeleportOutOfChairCoords

    Citizen.InvokeNative(0xD710A5007C2AC539, PlayerPedId(), 0x9925C067, 0)
    Citizen.InvokeNative(0xCC8CA3E88256E58F, PlayerPedId(), 0, 1, 1, 1, 0)

    local cameraCoords = LocationData.CameraCoords
    StartCam(cameraCoords.x, cameraCoords.y, cameraCoords.z, cameraCoords.rotx, cameraCoords.roty, cameraCoords.rotz, cameraCoords.zoom)
    CameraHandler.coords = { x = cameraCoords.x, y = cameraCoords.y, z = cameraCoords.z, rotx = cameraCoords.rotx, roty = cameraCoords.roty, rotz = cameraCoords.rotz, fov = cameraCoords.fov }
    CameraHandler.z    = cameraCoords.z
    CameraHandler.zoom = cameraCoords.zoom 

    PlayerData.HasNUIActive = true

    Citizen.CreateThread(function()
        
        while PlayerData.HasNUIActive do 
            Wait(0)
            DisplayRadar(false)
            
            FreezeEntityPosition(PlayerPedId(), true)
            DrawLightWithRange(LocationData.Lighting, 255, 255, 255, 2.5, 50.0)
        end
    
    end)

    Wait(2000)
    DoScreenFadeIn(2000)
    ToggleUI(true)

    SendNUIMessage({ action = 'set_information', title = Locales['TITLE'], locales = Locales, ismale = (IsPedMale(PlayerPedId()) and 1 or 0) } )

    if Groom == nil then 
        local gender  = IsPedMale(PlayerPedId()) == 1 and "Male" or "Female"
        Groom = LoadGroomData(gender)
    end

    SelectedPlayerSkin = {} -- reset

    local skin = exports.tpz_core:getCoreAPI().GetPlayerClientData().skinComp
    DefaultPlayerSkin  = json.decode(skin) -- reset

end

function CloseNUI()
    if GetPlayerData().HasNUIActive then SendNUIMessage({action = 'close'}) end
end

-----------------------------------------------------------
--[[ General NUI Callbacks ]]--
-----------------------------------------------------------

RegisterNUICallback('close', function()
	ToggleUI(false)
end)

-----------------------------------------------------------
--[[ Clothing Store NUI Callbacks ]]--
-----------------------------------------------------------

-- @data.category, @data.title
RegisterNUICallback('request_selected_groom_data', function(data)
    local category, title = data.category, data.title

    SELECTED_CATEGORY_TYPE = category

	SendNUIMessage({ action = 'reset_components_list' })

    local ClientData = exports.tpz_core:getCoreAPI().GetPlayerClientData()
    local PlayerSkin = ClientData.skinComp

    PlayerSkin = json.decode(PlayerSkin)

	if category == 'hair' or category == 'beard' then

		local current_component = PlayerSkin[category] and PlayerSkin[category].id or 1
		local current_color     = PlayerSkin[category] and PlayerSkin[category].color or 1
	
		-- texture_id
		SendNUIMessage({
			action = 'insertGroomCategoryElements',

			result = { 
				label    = Locales['NUI_GROOM_' .. string.upper(SELECTED_CATEGORY_TYPE) .. '_DESC'],
				category = SELECTED_CATEGORY_TYPE,
				type     = 'texture_id',
				current  = current_component,
				max      = #Groom[category],
			},
		})

		-- primary color.
		SendNUIMessage({
			action = 'insertGroomCategoryElements',

			result = { 
				label    = Locales['NUI_GROOM_' .. string.upper(SELECTED_CATEGORY_TYPE) .. '_COLORS'], 
				category = SELECTED_CATEGORY_TYPE,
				type     = 'color',
				current  = current_color,
				max      = Groom[category][current_component] ~= nil and #Groom[category][current_component] or 1,
			},

		})

		SendNUIMessage( { action = 'selectedGroomCategory', 
		
            result = {
				title              = title,
				description        = Locales['NUI_GROOM_' .. string.upper(SELECTED_CATEGORY_TYPE) .. '_INFO'],
				max                = max_elements,
	
				current_texture_id = current_component,
				max_texture_id     = #Groom[category],
	
				current_color      = current_color,
				max_colors         = Groom[category][current_component] ~= nil and #Groom[category][current_component] or 1,
			}
		})

	else -- beardstabble

		category                = category == 'overlay' and 'hair' or category
		local _category         = category == 'hair' and 'hair_overlay' or category
		local current_component = PlayerSkin[_category] and PlayerSkin[_category].id or 1
		local current_color     = PlayerSkin[_category] and PlayerSkin[_category].color or 1
		local current_opacity   = PlayerSkin[_category] and PlayerSkin[_category].opacity or 10

		local max_texture_id    = #Config.overlays_info[category]
		local max_colors        = #Config.color_palettes[category]

		-- texture_id
		SendNUIMessage({
			action = 'insertGroomCategoryElements',

			result = { 
				label    = Locales['NUI_GROOM_' .. string.upper(SELECTED_CATEGORY_TYPE) .. '_DESC'],
				category = SELECTED_CATEGORY_TYPE,
				type     = 'texture_id',
				current  = current_component,
				max      = max_texture_id,
			},
		})

		-- primary color.
		SendNUIMessage({
			action = 'insertGroomCategoryElements',

			result = { 
				label    = Locales['NUI_GROOM_' .. string.upper(SELECTED_CATEGORY_TYPE) .. '_COLORS'], 
				category = SELECTED_CATEGORY_TYPE,
				type     = 'color',
				current  = current_color,
				max      = max_colors
			},

		})


		-- opacity
		SendNUIMessage({
			action = 'insertGroomCategoryElements',

			result = { 
				label    = Locales['NUI_GROOM_' .. string.upper(SELECTED_CATEGORY_TYPE) .. '_OPACITY'],
				category = SELECTED_CATEGORY_TYPE,
				type     = 'opacity',
				current  = current_opacity,
				max      = 10,
			},
		})

		SendNUIMessage( { action = 'selectedGroomCategory', 
		
		    result = {
				title              = title,
				description        = Locales['NUI_GROOM_' .. string.upper(SELECTED_CATEGORY_TYPE) .. '_INFO'],
				max                = 3,
	
				current_texture_id = current_component,
				max_texture_id     = max_texture_id,
	
				current_color      = current_color,
				max_colors         = max_colors,
	
				current_opacity    = current_opacity,
			}
		})
	
	end
	
end)

RegisterNUICallback('set_groom_textures', function(data)
    SetGroomTexture(data)
end)

RegisterNUICallback('back', function()
    
    local cost = SelectedPlayerSkin[SELECTED_CATEGORY_TYPE] == nil and 0 or Config.Prices[string.upper(SELECTED_CATEGORY_TYPE)]

    if cost == 0 then 
        return
    end

    local inputData = {
        title = Locales[string.upper(SELECTED_CATEGORY_TYPE)],
        desc = string.format(Locales['COST_DESCRIPTION'], cost),
        buttonparam1 = Locales['CONFIRM_BUTTON'],
        buttonparam2 = Locales['CANCEL_BUTTON'],
    }
                                
    TriggerEvent("tpz_inputs:getButtonInput", inputData, function(cb)
    
        local await = true
        local reset = true

        if cb == "ACCEPT" then

            -- data required for the callback and only.
            local data    = SelectedPlayerSkin[SELECTED_CATEGORY_TYPE]
            data.amount   = cost
            data.category = SELECTED_CATEGORY_TYPE

            local cb = exports.tpz_core:ClientRpcCall().Callback.TriggerAwait("tpz_barbers:canPurchase", data )

            if cb then 
                reset = false 

                DefaultPlayerSkin[SELECTED_CATEGORY_TYPE] = SelectedPlayerSkin[SELECTED_CATEGORY_TYPE]
            end

            await = false
        else 
            await = false 
        end

        while await do 
            Wait(10)
        end

        if reset then

            SetGroomTexture({ 
                actionType = SELECTED_CATEGORY_TYPE,
                texture_id = DefaultPlayerSkin[SELECTED_CATEGORY_TYPE].id,
                color      = DefaultPlayerSkin[SELECTED_CATEGORY_TYPE].color,
                opacity    = DefaultPlayerSkin[SELECTED_CATEGORY_TYPE].opacity or 1.0,
                visibility = DefaultPlayerSkin[SELECTED_CATEGORY_TYPE].visibility or 0,
            })   
    
        end

    end) 

end)
