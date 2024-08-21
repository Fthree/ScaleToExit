class_name Pickup2
extends Attribute

signal picked2

func do_pickup(source: Box) -> void:
	picked2.emit()
