
local StoreLocationPrompts = GetRandomIntInRange(0, 0xffffff)
local StoreLocationPromptsList = {}

--[[-------------------------------------------------------
 Handlers
]]---------------------------------------------------------

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    Citizen.InvokeNative(0x00EDE88D4D13CF59, StoreLocationPrompts) -- UiPromptDelete

    local PlayerData = GetPlayerData()

    if PlayerData.IsBusy then
			
        local CameraHandler = GetCameraHandler()

        RenderScriptCams(false, true, 500, true, true)
        SetCamActive(CameraHandler.handler, false)
        DetachCam(CameraHandler.handler)
        DestroyCam(CameraHandler.handler, true)
			
        FreezeEntityPosition(PlayerPedId(), false)
    end

    for i, v in pairs(Config.Stores) do
        if v.BlipHandle then
            RemoveBlip(v.BlipHandle)
        end
    end

end)

--[[-------------------------------------------------------
 Prompts
]]---------------------------------------------------------

RegisterStoreLocationPrompts = function()

    local str = Config.Prompts["OPEN_STORE"].label
    local keyPress = Config.Keys[Config.Prompts["OPEN_STORE"].key]
    
    local _prompt = PromptRegisterBegin()
    PromptSetControlAction(_prompt, keyPress)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(_prompt, str)
    PromptSetEnabled(_prompt, 1)
    PromptSetVisible(_prompt, 1)
    PromptSetStandardMode(_prompt, 1)
    PromptSetHoldMode(_prompt, 500)
    PromptSetGroup(_prompt, StoreLocationPrompts)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, _prompt, true)
    PromptRegisterEnd(_prompt)
    
    StoreLocationPromptsList = _prompt

end

function GetPromptData()
    return StoreLocationPrompts, StoreLocationPromptsList
end


--[[-------------------------------------------------------
 Blips Management
]]---------------------------------------------------------

function AddBlip(Store, StatusType)

    if Config.Stores[Store].BlipData then

        local BlipData = Config.Stores[Store].BlipData

        local sprite, blipModifier = BlipData.Sprite, 'BLIP_MODIFIER_MP_COLOR_32'

        if BlipData.OpenBlipModifier then
            blipModifier = BlipData.OpenBlipModifier
        end

        if StatusType == 'CLOSED' then
            sprite = BlipData.DisplayClosedHours.Sprite
            blipModifier = BlipData.DisplayClosedHours.BlipModifier
        end
        
        Config.Stores[Store].BlipHandle = N_0x554d9d53f696d002(1664425300, Config.Stores[Store].Coords.x, Config.Stores[Store].Coords.y, Config.Stores[Store].Coords.z)

        SetBlipSprite(Config.Stores[Store].BlipHandle, sprite, 1)
        SetBlipScale(Config.Stores[Store].BlipHandle, 0.2)

        Citizen.InvokeNative(0x662D364ABF16DE2F, Config.Stores[Store].BlipHandle, GetHashKey(blipModifier))

        Config.Stores[Store].BlipHandleModifier = blipModifier

        Citizen.InvokeNative(0x9CB1A1623062F402, Config.Stores[Store].BlipHandle, BlipData.Title)

    end
end

--[[-------------------------------------------------------
 NPC Management
]]---------------------------------------------------------

LoadModel = function(model)
    local model = GetHashKey(model)
    RequestModel(model)

    while not HasModelLoaded(model) do RequestModel(model)
        Citizen.Wait(100)
    end
end
 
RemoveEntityProperly = function(entity, objectHash)
    DeleteEntity(entity)
    DeletePed(entity)

    SetEntityAsNoLongerNeeded( entity )

    if objectHash then
        SetModelAsNoLongerNeeded(objectHash)
    end
   
end

--[[-------------------------------------------------------
 General
]]---------------------------------------------------------

StartCam = function(x, y, z, rotx, roty, rotz, fov)

    local cameraHandler = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", x, y, z, rotx, roty, rotz, fov, true, 0)
	SetCamActive(cameraHandler, true)
	RenderScriptCams(true, true, 500, true, true)

end

AdjustEntityPedHeading = function(amount)
	CurrentHeading = CurrentHeading + amount
	SetPedDesiredHeading(PlayerPedId(), CurrentHeading)
end


LoadGroomData = function(gender)

    local Groom = {}

    local hairComponents = exports.tpz_core:getCoreAPI().modules().file.load("component.data.playerHairComponents")

    while hairComponents == nil do 
        Wait(100)
    end

    for category, value in pairs(hairComponents[gender]) do

        local categoryTable = {}

        for _, v in ipairs(value) do

            local typeTable = {}

            for _, va in ipairs(v) do
                table.insert(typeTable, { hex = va.hash })
            end

            table.insert(categoryTable, typeTable)
        end

        Groom[category] = categoryTable
    end
   
    return Groom

end


function ApplyOverlay(name, visibility, tx_id, tx_normal, tx_material, tx_color_type, tx_opacity, tx_unk, palette_id, palette_color_primary, palette_color_secondary, palette_color_tertiary, var, opacity, albedo, ped)

    ped = ped or PlayerPedId()

    for k, v in pairs(Config.overlay_all_layers) do
        if v.name == name then
            v.visibility = visibility
            if visibility ~= 0 then
                v.tx_normal = tx_normal
                v.tx_material = tx_material
                v.tx_color_type = tx_color_type
                v.tx_opacity = tx_opacity
                v.tx_unk = tx_unk
                if tx_color_type == 0 then
                    v.palette = Config.color_palettes[name][palette_id]
                    v.palette_color_primary = palette_color_primary
                    v.palette_color_secondary = palette_color_secondary
                    v.palette_color_tertiary = palette_color_tertiary
                end
                if name == "shadows" or name == "eyeliners" or name == "lipsticks" then
                    v.var = var
                    if tx_id ~= 0 then
                        v.tx_id = Config.overlays_info[name][1].id
                    end
                else
                    v.var = 0
                    if tx_id ~= 0 then
                        v.tx_id = Config.overlays_info[name][tx_id].id
                    end
                end
                v.opacity = opacity
            end
        end
    end

    local gender = IsPedMale(PlayerPedId()) == 1 and 'Male' or 'Female'
    local current_texture_settings = Config.texture_types[gender]

    if textureId ~= -1 then
        Citizen.InvokeNative(0xB63B9178D0F58D82, textureId)
        Citizen.InvokeNative(0x6BEFAA907B076859, textureId)
    end

    textureId = Citizen.InvokeNative(0xC5E7204F322E49EB, albedo, current_texture_settings.normal, current_texture_settings.material)

    for k, v in pairs(Config.overlay_all_layers) do
        if v.visibility ~= 0 then
            local overlay_id = Citizen.InvokeNative(0x86BB5FF45F193A02, textureId, v.tx_id, v.tx_normal, v.tx_material, v.tx_color_type, v.tx_opacity, v.tx_unk)
            if v.tx_color_type == 0 then
                Citizen.InvokeNative(0x1ED8588524AC9BE1, textureId, overlay_id, v.palette)
                Citizen.InvokeNative(0x2DF59FFE6FFD6044, textureId, overlay_id, v.palette_color_primary, v.palette_color_secondary, v.palette_color_tertiary)
            end

            Citizen.InvokeNative(0x3329AAE2882FC8E4, textureId, overlay_id, v.var);
            Citizen.InvokeNative(0x6C76BC24F8BB709A, textureId, overlay_id, v.opacity);
        end
    end

    while not Citizen.InvokeNative(0x31DC8D3F216D8509, textureId) do
        Citizen.Wait(0)
    end

    Citizen.InvokeNative(0x92DAABA2C1C10B0E, textureId)
    Citizen.InvokeNative(0x0B46E25761519058, ped, joaat("heads"), textureId)
    Citizen.InvokeNative(0xCC8CA3E88256E58F, ped, false, true, true, true, false)
end



