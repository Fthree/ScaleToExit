class_name Scale_Attribute
extends Attribute

signal scale_bigger
signal scale_smaller

func do_scale_up() -> void:
	scale_bigger.emit()

func do_scale_down() -> void:
	scale_smaller.emit()		