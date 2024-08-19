extends LimboState
## Move state.

@export var root: Node2D
@export var animation_player: AnimationPlayer
@export var animation: StringName

func _enter() -> void:
	animation_player.play(animation)


func _update(_delta: float) -> void:
	if root.scale.x < 1.2 and root.scale.x > -1.2 and root.scale.y < 1.2 and root.scale.y > -1.2:
		get_root().dispatch(self.EVENT_FINISHED)
