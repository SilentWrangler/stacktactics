extends Node2D

@export var units_to_deploy: Array[UnitData]
@export var manager: BattleManager
@export var target: UnitData
@export var target_location: Vector2i
@export var enemies_to_deploy: Array[UnitData]
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(len(units_to_deploy)):
		manager.deploy_unit(units_to_deploy[i], manager.player_deploy_locations[i])
	
	for i in range(len(enemies_to_deploy)):
		manager.deploy_unit(enemies_to_deploy[i], manager.enemy_deploy_locations[i], Unit.Team.Enemy)
	
	manager.deploy_unit(target,target_location,Unit.Team.Enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
