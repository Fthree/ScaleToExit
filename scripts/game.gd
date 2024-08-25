extends Node

const Skeleton_Basic := preload("res://enemies//skeleton_enemy_basic.tscn")


const WAVES: Array = [
	[Skeleton_Basic],
	[Skeleton_Basic,Skeleton_Basic],
	[Skeleton_Basic,Skeleton_Basic,Skeleton_Basic,Skeleton_Basic]]

@export var wave_index: int = -1
@export var agents_alive: int = 0

@onready var player: CharacterBody2D = $Player
@onready var spawn_points: Node = $SpawnPoints

# func _ready():
#     _start_round()

func _start_round() -> void:
	wave_index += 1
	if wave_index >= WAVES.size():
		return

	await get_tree().create_timer(3.0).timeout

	var spawns: Array = spawn_points.get_children()
	spawns.shuffle()
	for i in WAVES[wave_index].size():
		var agent_resource: PackedScene = WAVES[wave_index][i]
		var agent: CharacterBody2D = agent_resource.instantiate()
		add_child(agent)
		agent.global_position = spawns[i].global_position
		agent.death.connect(_on_agent_death)
		agents_alive += 1

func _on_agent_death() -> void:
	agents_alive -= 1
	if agents_alive == 0:
		_start_round()
