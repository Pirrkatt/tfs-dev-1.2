local config = {
	groundEffect = 181,
	explosionEffect = 180,
	explosionDelay = 1000, -- Delay until explosion

	minDmg = 1000,
	maxDmg = 2000,
	damageType = COMBAT_FIREDAMAGE,
}

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, config.damageType)
combat:setArea(createCombatArea(AREA_SQUARE1X1))

function onTargetTile(creature, position)
	doAreaCombat(creature, config.damageType, position, position, -config.minDmg, -config.maxDmg)
end
combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

function onCastSpell(creature, variant)
	local groundPos = setEffectOffset(creature:getPosition(), 2)
	local explPos = setEffectOffset(creature:getPosition(), 3)
	local startDelay = math.max(100, math.min(2000, 100000 / creature:getSpeed()))

	creature:setImmobile(true)

	addEvent(function()
		groundPos:sendMagicEffect(config.groundEffect)
	end, startDelay)

	addEvent(function(creatureId, var)
		creature = Creature(creatureId)
		if creature then
			creature:setImmobile(false)
			explPos:sendMagicEffect(config.explosionEffect)
			combat:execute(creature, var)
		end
	end, startDelay + config.explosionDelay, creature:getId(), variant)
	return true
end