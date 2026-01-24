extends TextureRect

@onready var label = $Abilityname

func display_ability(ability: Ability):
	await ready
	texture = ability.sprite
	label.text = ability.Name
	tooltip_text = ability.Description
	label.tooltip_text = ability.Description
