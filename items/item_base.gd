extends StaticBody2D
class_name Item

signal picked_up

@export var delay_before_free: float = 0.5

@onready var hsm: LimboHSM = $LimboHSM
@onready var idle_state: LimboState = $LimboHSM/IdleState
@onready var picked_state: LimboState = $LimboHSM/PickedState

@onready var root: Node2D = $Root

var can_pickup: bool = true
var is_picked: bool = false  # New flag to check if already picked

func _ready() -> void:
	_init_state_machine()
	
func _init_state_machine() -> void:
	hsm.add_transition(idle_state, picked_state, "picked")
	hsm.initialize(self)
	hsm.set_active(true)

	
func _picked_up_item():
	if is_picked:  # Check if already picked
		return
	
	print("Picked up item: ", self.name)
	is_picked = true  # Set flag
	
	hsm.dispatch("picked")
	hsm.get_active_state().call_on_exit(emit_and_die)
	
func emit_and_die() -> void:
	root.process_mode = Node.PROCESS_MODE_DISABLED

	if get_tree():
		await get_tree().create_timer(delay_before_free).timeout
		if picked_up:
			picked_up.emit()
		queue_free()

func _on_proximity_sensor_in_proximity(source):
	if can_pickup and not is_picked:  # Added is_picked check
		can_pickup = false
		_picked_up_item()
