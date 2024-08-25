class_name PickupBox
extends Box
## Area that registers damage.

@export var pickupSignal: Pickup

var last_attack_vector: Vector2

func _ready() -> void:
	area_entered.connect(do_action)

func do_action(source: Box) -> void:
	if source.owner != owner:
		pickupSignal.do_pickup(source)
