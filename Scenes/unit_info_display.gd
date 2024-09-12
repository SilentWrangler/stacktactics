extends ScrollContainer

@onready var ability_box = $VBoxContainer/AbilityBox
@onready var unit_picture = $VBoxContainer/UnitPicture
@onready var unit_name = $VBoxContainer/UnitName
@onready var unit_tags = $VBoxContainer/UnitTags
@onready var unit_description = $VBoxContainer/UnitDescription
@onready var stat_label = $VBoxContainer/StatLabel
@onready var hp_label = $VBoxContainer/HPLabel

@export var arcana_image: Texture2D
@export var power_image: Texture2D
@export var fortitude_image: Texture2D

@export var name_fontsize = 24


var ability_template = preload("res://Scenes/ability_display.tscn")

func clear():
	for ch in ability_box.get_children():
		ch.free()
	unit_picture.texture=null
	unit_name.text=""
	unit_tags.text=""
	unit_description.text=""

func display_from_unit(unit: Unit):
	clear()
	unit_picture.texture = unit.unitData.sprite_texture
	unit_name.text = "[font_size=%d] %s [/font_size]" % [name_fontsize, unit.unitData.unit_name]
	unit_description.text = unit.unitData.unit_description
	display_stats(
		unit.total_attribute(Unit.Attribute.Power),
		unit.total_attribute(Unit.Attribute.Arcana),
		unit.total_attribute(Unit.Attribute.Fortitude),
		unit.unitData
		)
	display_hp(unit.stack.Stack)
	display_tags(unit.tags)
	display_abilities(unit.Abilities)

func display_from_slot(unitSlot: PlayerData.UnitSlot):
	clear()
	unit_picture.texture = unitSlot.unitData.sprite_texture
	unit_name.text = "[font_size=%d] %s [/font_size]"  % [name_fontsize,  unitSlot.get_unit_name()]
	unit_description.text = unitSlot.get_desc()
	display_stats(unitSlot.unitData.power,unitSlot.unitData.arcana, unitSlot.unitData.fortitude, unitSlot.unitData)
	display_hp(unitSlot.unitData.default_hp)
	display_tags(unitSlot.get_tags())
	display_abilities(unitSlot.unitData.abilities)

func display_evo(unitSlot: PlayerData.UnitSlot, evo: UnitData):
	pass


func display_tags(tags: Array[StringName]):
	var msg = ', '.join(PackedStringArray(tags))
	unit_tags.text = msg
	

func display_abilities(abilities: Array[Ability]):
	for a in abilities:
		var t = ability_template.instantiate()
		t.display_ability(a)
		ability_box.add_child(t)

func display_hp(stack: Array[HpSegment]):
	hp_label.text=""
	hp_label.push_paragraph(HORIZONTAL_ALIGNMENT_CENTER)
	for segment in stack:
		hp_label.add_image(StaticData.get_hp_texture(segment.Type))
		hp_label.append_text(' %d '% segment.amount)
	hp_label.pop()

func display_stats(power: int, arcana: int, fortitude: int, unitData: UnitData):
	stat_label.text=""
	stat_label.push_paragraph(HORIZONTAL_ALIGNMENT_CENTER)
	stat_label.add_image(power_image)
	if power>unitData.power:
		stat_label.push_color(Color.SEA_GREEN)
	if power<unitData.power:
		stat_label.push_color(Color.FIREBRICK)
	stat_label.append_text(" %d " % power)
	if power!=unitData.power:
		stat_label.pop()
	stat_label.add_image(arcana_image)
	if arcana>unitData.arcana:
		stat_label.push_color(Color.SEA_GREEN)
	if arcana<unitData.arcana:
		stat_label.push_color(Color.FIREBRICK)
	stat_label.append_text(" %d " % arcana)
	if arcana!=unitData.arcana:
		stat_label.pop()
	stat_label.add_image(fortitude_image)
	if fortitude>unitData.fortitude:
		stat_label.push_color(Color.SEA_GREEN)
	if fortitude<unitData.fortitude:
		stat_label.push_color(Color.FIREBRICK)
	stat_label.append_text(" %d " % fortitude)
	if fortitude!=unitData.fortitude:
		stat_label.pop()
	stat_label.pop()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#clear()
