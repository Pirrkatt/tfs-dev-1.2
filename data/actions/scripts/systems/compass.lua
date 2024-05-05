local config = {
    holeId = 19512,
    actionId = 9000,
    cooldown = 30, -- seconds
    range = 40, -- SQM
    mapMarkDescription = "Hidden Hole!"
}

local cooldownTable = {}
PLAYER_MARKS_CACHE = {}

local function addMarks(playerId)
    local player = Player(playerId)
    local playerPos = player:getPosition()

    local holesFound = 0

    for x = playerPos.x-config.range, playerPos.x+config.range do
        for y = playerPos.y-config.range, playerPos.y+config.range do
            local pos = Position(x, y, playerPos.z)
            local tile = Tile(pos)
            local hole = tile and tile:getItemById(config.holeId)
            if hole and hole:getActionId() == config.actionId then
                if not PLAYER_MARKS_CACHE[playerId] then
                    PLAYER_MARKS_CACHE[playerId] = {}
                end

                if not table.contains(PLAYER_MARKS_CACHE[playerId], pos) then
                    player:addMapMark(pos, MAPMARK_SHOVEL, config.mapMarkDescription)
                    table.insert(PLAYER_MARKS_CACHE[playerId], pos)
                    holesFound = holesFound + 1
                end
            end
        end
    end
    player:sendTextMessage(MESSAGE_INFO_DESCR, "With the help of your compass you found " .. holesFound .. " new hidden holes!")
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local playerGuid = player:getGuid()
    local playerCooldown = cooldownTable[playerGuid]
    if playerCooldown and playerCooldown > os.time() then
        player:sendCancelMessage("You can not use this yet, you must wait another " .. (playerCooldown - os.time()) .. " seconds.")
        return true
    end

    addMarks(player:getId())
    cooldownTable[playerGuid] = os.time() + config.cooldown
	return true
end