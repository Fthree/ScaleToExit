extends LimboState
## Move state.

const VERTICAL_FACTOR := 0.8

@export var animation_player: AnimationPlayer
@export var animation: StringName
@export var speed: float = 50.0


func _enter() -> void:
	animation_player.play(animation, 0.1)


func _update(_delta: float) -> void:
	var horizontal_move: float = Input.get_axis(&"move_left", &"move_right")
	var vertical_move: float = Input.get_axis(&"move_up", &"move_down")

	if not is_zero_approx(horizontal_move):
		agent.face_dir(horizontal_move)

	var desired_velocity := Vector2(horizontal_move, vertical_move * VERTICAL_FACTOR) * speed
	agent.move(desired_velocity)

	if horizontal_move == 0.0 and vertical_move == 0.0:
		get_root().dispatch(EVENT_FINISHED)


# @export var root: Node2D
# @export var animation_player: AnimationPlayer
# @export var animation: StringName

# func _enter() -> void:
# 	animation_player.play(animation)


# func _update(_delta: float) -> void:
# 	if root.scale.x < 1.2 and root.scale.x > -1.2 and root.scale.y < 1.2 and root.scale.y > -1.2:
# 		get_root().dispatch(self.EVENT_FINISHED)
