local config = {
	groundEffect = 181,
	explosionEffect = 180,
	explosionDelay = 1000, -- Delay until explosion

	minDmg = 1000,
	maxDmg = 2000,
	damageType = COMBAT_FIREDAMAGE,

	playerChance = 50, -- % chance of attack appearing on each player
}

local area = createCombatArea(AREA_SQUARE1X1)

local function castOnTarget(playerId, monsterId)
	local player = Player(playerId)
	local position = player:getPosition()
	local groundPos = setEffectOffset(player:getPosition(), 2)
	local explPos = setEffectOffset(player:getPosition(), 3)

	groundPos:sendMagicEffect(config.groundEffect)

	addEvent(function()
		local monster = Monster(monsterId)
		if monster then
			doAreaCombatHealth(monster, config.damageType, position, area, -config.minDmg, -config.maxDmg)
		end

		explPos:sendMagicEffect(config.explosionEffect)
	end, config.explosionDelay)
end

function onCastSpell(creature, variant)
	local spectators = Game.getSpectators(creature:getPosition(), false, true, 7, 7, 5, 5)

	for _, spec in pairs(spectators) do
		local randomChance = math.random(100)
		if config.playerChance > randomChance then
			local tile = Tile(spec:getPosition())
			if not tile:hasFlag(TILESTATE_PROTECTIONZONE) then
				castOnTarget(spec:getId(), creature:getId())
			end
		end
	end
	return true
end