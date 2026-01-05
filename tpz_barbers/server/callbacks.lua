
local TPZ = exports.tpz_core:getCoreAPI()

-----------------------------------------------------------
--[[ Callbacks  ]]--
-----------------------------------------------------------

exports.tpz_core:getCoreAPI().addNewCallBack("tpz_barbers:canPurchase", function(source, cb, data)
    local _source = source
    local xPlayer = TPZ.GetPlayer(_source)
  
    local money   = xPlayer.getAccount(0)
  
    if money < data.amount then 
        SendNotification(_source, Locales['NOT_ENOUGH_MONEY'], "error")
        return cb (false)
    end

    xPlayer.removeAccount(0, data.amount)

    local skinComp = xPlayer.getOutfitComponents()
  
    -- if it's still a string (double encoded), decode again
    if type(skinComp) == "string" then
      skinComp = json.decode(skinComp)
    end
  
    if data.category == 'hair' or data.category == 'beard' then
        skinComp[data.category] = { id = data.id, color = data.color }
  
    else 

        skinComp[data.category] = {
            id         = data.id, 
            color      = data.color, 
            visibility = data.visibility, 
            opacity    = data.opacity,
        }

    end

    local Parameters = {
        ["charidentifier"] = xPlayer.getCharacterIdentifier(),
        ['skinComp']       = json.encode(skinComp),
    } 
  
    exports.ghmattimysql:execute("UPDATE `characters` SET `skinComp` = @skinComp WHERE `charidentifier` = @charidentifier", Parameters)

    xPlayer.setOutfitComponents(json.encode(skinComp))

    SendNotification(_source, string.format(Locales['SUCCESSFULLY_PAID'], data.amount), 'success')

    return cb(true)
end)