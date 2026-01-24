class_name RewardsOutcome
extends OptionOutcome

@export var rewards: Rewards

func apply(tree):
	if not BattleData.extra_rewards:
		BattleData.extra_rewards = []
	BattleData.extra_rewards.append(rewards)

func get_tooltip():
	return rewards.get_text()
