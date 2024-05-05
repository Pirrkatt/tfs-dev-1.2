function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:hasAutoLootSystem() then
        player:sendCancelMessage("You have already unlocked the AutoLoot system!")
        return true
    end

    player:sendTextMessage(MESSAGE_INFO_DESCR, "You have unlocked the AutoLoot system!")
    player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
    player:unlockAutoLootSystem()
    player:spawnAutoLooter()
    item:remove(1)
	return true
end