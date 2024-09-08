class_name ReturnToCampaign
extends OptionOutcome

@export var victory: bool

func apply(tree):
	BattleData.victory = victory
	BattleData.from_event = true
	tree.change_scene_to_file(PlayerData.campaign)
