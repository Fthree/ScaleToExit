extends StaticBody2D

signal picked_up

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pickup: Pickup = $Pickup
@onready var root: Node2D = $Root

func _ready() -> void:
	if pickup:
		pickup.picked.connect(_picked_up_item)
	
func _picked_up_item():
	print("picked up item!")
	animation_player.play(&"picked")
	await animation_player.animation_finished
	if picked_up:
		picked_up.emit()
	die()
	
func die() -> void:
	root.process_mode = Node.PROCESS_MODE_DISABLED

	if get_tree():
		await get_tree().create_timer(1.0).timeout
		queue_free()
