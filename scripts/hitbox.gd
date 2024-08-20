class_name Hitbox
extends Box
## Area that deals damage.

## Damage value to apply.
@export var damage: float = 1.0

## Push back the victim.
@export var knockback_enabled: bool = false

## Desired pushback speed.
@export var knockback_strength: float = 500.0


func _ready() -> void:
	area_entered.connect(_area_entered)


func _area_entered(hurtbox: Hurtbox) -> void:
	if hurtbox.owner == owner:
		return
	hurtbox.take_damage(damage, knockback_strength, self)
