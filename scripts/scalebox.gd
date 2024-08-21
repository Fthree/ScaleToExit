class_name ScaleBox
extends Box

@export var root: Node2D
@export var scaled: Scale_Attribute

func scale_agent_up() -> void:
	scaled.do_scale_up()

func scale_agent_down() -> void:
	scaled.do_scale_down()