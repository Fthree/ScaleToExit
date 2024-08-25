class_name Hurtbox
extends Box
## Area that registers damage.

@export var health: Health

var last_attack_vector: Vector2

func take_damage(amount: float, knockback: float, source: Hitbox) -> void:
	last_attack_vector = owner.global_position - source.owner.global_position
	health.take_damage(amount, last_attack_vector * knockback)
