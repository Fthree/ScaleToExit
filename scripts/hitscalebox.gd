class_name HitScaleBox
extends Box

@export var root: Node2D

func _ready() -> void:
	area_entered.connect(_area_entered)

func _area_entered(scaleBox: ScaleBox) -> void:
	print("area entered")
	if scaleBox.owner == owner:
		return
	if sign(root.scale.y) == -1:
		scaleBox.scale_agent_up()
	else:
		scaleBox.scale_agent_down()

	
