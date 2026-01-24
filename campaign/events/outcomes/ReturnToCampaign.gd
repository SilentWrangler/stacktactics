class_name ReturnToCampaign
extends OptionOutcome

@export var victory: bool
@export var see_next: bool

func apply(tree):
	BattleData.victory = victory
	BattleData.from_event = true
	tree.change_scene_to_file(PlayerData.campaign)

func get_tooltip():
	return "Return to campaign and receive clearing rewards" if victory else(\
	 "See what happens next..." if see_next else "Retreat to campaign")
