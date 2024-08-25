#*
#* attack_state.gd
#* =============================================================================
#* Copyright 2021-2024 Serhii Snitsaruk
#*
#* Use of this source code is governed by an MIT-style
#* license that can be found in the LICENSE file or at
#* https://opensource.org/licenses/MIT.
#* =============================================================================
#*
extends LimboState

## Attack state: Perform 3-part combo attack for as long as player hits attack button.

@export var animation_player: AnimationPlayer
@export var animation: StringName
#@export var hitbox: Hitbox

func _enter() -> void:
	animation_player.play(animation)
	await animation_player.animation_finished
	
	if is_active():
		get_root().dispatch(EVENT_FINISHED)
