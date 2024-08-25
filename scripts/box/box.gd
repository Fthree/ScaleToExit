class_name Box
extends Area2D

func _ready() -> void:
	area_entered.connect(_do_action)

func _do_action(_source: Box) -> void:
	pass
