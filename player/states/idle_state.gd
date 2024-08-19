#*
#* idle_state.gd
#* =============================================================================
#* Copyright 2021-2024 Serhii Snitsaruk
#* 
#* Use of this source code is governed by an MIT-style
#* license that can be found in the LICENSE file or at
#* https://opensource.org/licenses/MIT.
#* =============================================================================
#*
extends LimboState
## Idle state.

@export var root: Node2D
@export var animation_player: AnimationPlayer
@export var idle_animation: StringName

func _enter() -> void:
	animation_player.play(idle_animation)


func _update(_delta: float) -> void:
	if root.scale.x >= 1.2 or root.scale.x <= -1.2 or root.scale.y >= 1.2 or root.scale.y <= -1.2:
		get_root().dispatch(self.EVENT_FINISHED)