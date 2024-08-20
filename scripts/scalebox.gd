class_name ScaleBox
extends Box
## Area that registers damage.

@export var scaled: Scale_Attribute

var last_attack_vector: Vector2

func scale_agent_up() -> void:
	scaled.do_scale_up()

func scale_agent_down() -> void:
	scaled.do_scale_down()