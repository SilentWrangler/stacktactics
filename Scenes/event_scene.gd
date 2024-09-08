extends Control

@onready var background = $Background
@onready var side_picture = $SidePicture
@onready var title = $PanelContainer/VBoxContainer/EventTitle
@onready var description = $PanelContainer/VBoxContainer/EventDescription
@onready var option_box = $PanelContainer/VBoxContainer/Options
# Called when the node enters the scene tree for the first time.
func _ready():
	print("event scene opened")
	if BattleData.event:
			
		background.texture = BattleData.event.background
		side_picture.texture = BattleData.event.side_picture
		
		title.text = BattleData.event.title
		description.text = BattleData.event.text
		
		for option in BattleData.event.options:
			if option.available():
				var button = Button.new()
				button.text = option.text
				button.tooltip_text = option.outcome.get_tooltip()
				button.connect("pressed", func (): option.outcome.apply(get_tree()))
				button.alignment = HORIZONTAL_ALIGNMENT_LEFT
				option_box.add_child(button)
	
