@tool
extends BTAction

@export var target_var: StringName = &"target"
@export var position_var: StringName = &"pos"


func _generate_name() -> String:
	return "select target pos  target: %s ➜%s" % [
		LimboUtility.decorate_var(target_var),
		LimboUtility.decorate_var(position_var)]

func _tick(_delta: float) -> Status:
	var target := blackboard.get_var(target_var) as Node2D
	if not is_instance_valid(target):
		return FAILURE
	blackboard.set_var(position_var, target.position)
	return SUCCESS

