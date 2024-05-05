local config = {
	groundEffect = 181,
	explosionEffect = 180,
	startDelay = 100, -- Delay to run spell after setting movementBlocked
	explosionDelay = 1000, -- Delay for explosion after running spell

	minDmg = 1000,
	maxDmg = 2000,
	damageType = COMBAT_FIREDAMAGE,
}

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, config.damageType)
combat:setArea(createCombatArea(AREA_SQUARE1X1))

function onGetFormulaValues(player, level, magicLevel)
	return -config.minDmg, -config.maxDmg
end
combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(creature, variant)
	creature:setMovementBlocked(true)

	-- We add a little bit of delay to make sure effect is centered around player
	addEvent(function()
		local groundPos = setEffectOffset(creature:getPosition(), 2)
		groundPos:sendMagicEffect(config.groundEffect)
	end, config.startDelay)

	addEvent(function(creatureId, var)
		creature = Creature(creatureId)
		if creature then
			local explPos = setEffectOffset(creature:getPosition(), 3)
			creature:setMovementBlocked(false)
			explPos:sendMagicEffect(config.explosionEffect)
			combat:execute(creature, var)
		end
	end, config.explosionDelay + config.startDelay, creature:getId(), variant)
	return true
end
