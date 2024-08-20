class_name Pickup
extends Attribute

signal picked

func do_pickup(source: Box) -> void:
	if !source.is_in_group("player"):
		picked.emit()
