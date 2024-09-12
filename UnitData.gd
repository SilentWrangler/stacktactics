class_name UnitData
extends Resource

@export var unit_type_ID: StringName
@export var unit_name: String = 'Unit'
@export_multiline var unit_description: String = 'Unit description goes here'
@export var sprite_texture: Texture2D
@export var default_hp: Array[HpSegment]
@export var power: int
@export var arcana: int
@export var fortitude: int
@export var abilities: Array[Ability]
@export var inherent_tags: Array[StringName]
@export var AI: BaseAI
