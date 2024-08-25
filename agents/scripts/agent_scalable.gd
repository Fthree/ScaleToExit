extends CharacterBody2D

signal death

@export var target_item_group: Item

var _frames_since_facing_update: int = 0
var _is_dead: bool = false
var _moved_this_frame: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var a_scale: Scale_Attribute = $Scale
@onready var root: Node2D = $Root
@onready var collision_shape_2d: CollisionShape2D = $Collider
@onready var bt_player: BTPlayer = $BTPlayer

func _ready() -> void:
	if a_scale:
		a_scale.scale_bigger.connect(_scale_up)
		a_scale.scale_smaller.connect(_scale_down)
	if bt_player and target_item_group:
		bt_player.blackboard.set_var("group", target_item_group.get_groups()[0])

func _physics_process(_delta: float) -> void:
	_post_physics_process.call_deferred()

#if the agent hasn't moved, lerp that beotch
func _post_physics_process() -> void:
	if not _moved_this_frame:
		velocity = lerp(velocity, Vector2.ZERO, 0.5)
	_moved_this_frame = false

## Returns 1.0 when agent is facing right.
## Returns -1.0 when agent is facing left.
func get_facing() -> float:
	return signf(root.scale.x)

## Is specified position inside the arena (not inside an obstacle)?
func is_good_position(p_position: Vector2) -> bool:
	var space_state := get_world_2d().direct_space_state
	var params := PhysicsPointQueryParameters2D.new()
	params.position = p_position
	params.collision_mask = 1 # Obstacle layer has value 1
	var collision := space_state.intersect_point(params)
	return collision.is_empty()

## Face specified direction.
func face_dir(dir: float) -> void:
	if dir > 0.0 and root.scale.x < 0.0:
		root.scale.x = abs(root.scale.x)
		_frames_since_facing_update = 0
	elif dir < 0.0 and root.scale.x > 0.0:
		root.scale.x = -abs(root.scale.x)
		_frames_since_facing_update = 0
		
## When agent is scaled up...
func _scale_up() -> void:
	if abs(root.scale.x) < 1.5 and abs(root.scale.y) < 1.5:
		root.scale += Vector2(.5 * sign(root.scale.x), .5)

## When agent is scaled down...
func _scale_down() -> void:
	if abs(root.scale.x) > 0.5 and abs(root.scale.y) > 0.5:
		root.scale -= Vector2(.5 * sign(root.scale.x), .5)

func move(p_velocity: Vector2) -> bool:
	velocity = lerp(velocity, p_velocity, 0.2)
	_moved_this_frame = true
	return move_and_slide()

## Push agent in the knockback direction for the specified number of physics frames.
func apply_knockback(knockback: Vector2, frames: int = 10) -> void:
	if knockback.is_zero_approx():
		return
	for i in range(frames):
		move(knockback)
		await get_tree().physics_frame

## Update agent's facing in the velocity direction.
func update_facing() -> void:
	_frames_since_facing_update += 1
	if _frames_since_facing_update > 3:
		face_dir(velocity.x)

func die() -> void:
	if _is_dead:
		return
	death.emit()
	_is_dead = true
	root.process_mode = Node.PROCESS_MODE_DISABLED
	animation_player.play(&"death")
	collision_shape_2d.set_deferred(&"disabled", true)

	for child in get_children():
		if child is BTPlayer or child is LimboHSM:
			child.set_active(false)

	if get_tree():
		await get_tree().create_timer(1.0).timeout
		queue_free()
