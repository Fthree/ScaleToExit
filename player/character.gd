extends "res://scripts/agent_base.gd"

@export var scale_amount: float = 1
@export var max_scale: float = 1.2
@export var move_amount: float = 10
@export var scale_duration: float = 0.1
var scale_clamp: float = .1

@onready var hsm: LimboHSM = $LimboHSM
@onready var idle_state: LimboState = $LimboHSM/IdleState
@onready var move_state: LimboState = $LimboHSM/MoveState
@onready var attack_state: LimboState = $LimboHSM/AttackState

var motion: Vector2 = Vector2.ZERO
var scale_motion: Vector2 = Vector2.ZERO

func _ready() -> void:
    super._ready()
    _init_input_events()
    _init_state_machine()
    death.connect(func(): remove_from_group("player"))

func _physics_process(delta: float) -> void:
    super._physics_process(delta)
    _handle_input_scaling()
    _handle_motion_and_scale(delta)

func _handle_input_scaling() -> void:
    if hsm.get_active_state() != attack_state:
        if Input.is_key_pressed(KEY_UP):
            if root.scale.y < max_scale:
                tween_scale(Vector2(0, scale_amount), scale_duration)

        if Input.is_key_pressed(KEY_DOWN):
            if root.scale.y > -max_scale:
                tween_scale(Vector2(0, -scale_amount), scale_duration)

        if Input.is_key_pressed(KEY_LEFT):
            if root.scale.x > -max_scale:
                tween_scale(Vector2(-scale_amount, 0), scale_duration)

        if Input.is_key_pressed(KEY_RIGHT):
            if root.scale.x < max_scale:
                tween_scale(Vector2(scale_amount, 0), scale_duration)

        if Input.is_key_pressed(KEY_R):
            reset_scale()

        if Input.is_key_pressed(KEY_F):
            hsm.dispatch("attack")


func _handle_scale_motion():
    if Input.is_key_pressed(KEY_SPACE):
        if root.scale.x > max_scale:
            motion.x += root.scale.x * move_amount
            tween_scale(Vector2.ZERO, scale_duration, Vector2(1, root.scale.y))
        elif root.scale.x < -max_scale:
            motion.x += root.scale.x * move_amount
            tween_scale(Vector2.ZERO, scale_duration, Vector2(-1, root.scale.y))

        if root.scale.y > max_scale:
            motion.y -= root.scale.y * move_amount
            tween_scale(Vector2.ZERO, scale_duration, Vector2(root.scale.x, 1))

        elif root.scale.y < -max_scale:
            motion.y -= root.scale.y * move_amount
            tween_scale(Vector2.ZERO, scale_duration, Vector2(root.scale.x, -1))

func reset_scale() -> void:
    tween_scale(Vector2.ZERO, scale_duration, Vector2(1, 1))


func _handle_motion_and_scale(delta: float):
    if motion != Vector2.ZERO:
        var bounce: float = 1

        motion *= move_amount * delta

        var collision = move_and_collide(motion, false)

        if !collision:
            tween_to(motion)
            motion = Vector2.ZERO
        else:
            while collision and bounce > 0:
                motion = motion.bounce(collision.get_normal()) * bounce
                tween_to(motion)
                
                # Reduce the bounce factor
                bounce -= 0.1
                
                # Check for the next collision
                collision = move_and_collide(motion, false)
            motion = Vector2.ZERO

func tween_to(mtn: Vector2, duration: float = 0.1, property: String = "position"):
    var tween = create_tween()
    var final_position: Vector2

    final_position = position + mtn
    tween.tween_property(self, property, final_position, duration)
    
    await tween.finished

func tween_scale(scl_mtn: Vector2, duration: float = 0.1, force_scale: Vector2 = Vector2.ZERO, property: String = "scale"):
    var tween = create_tween()

    var final_scale: Vector2
    if force_scale != Vector2.ZERO:
        final_scale = force_scale
    else:
        final_scale = root.scale + scl_mtn

        # Ensure scale doesn't go between -0.1 and 0.1
        if final_scale.x > -scale_clamp and final_scale.x < scale_clamp:
            final_scale.x = scale_clamp if scl_mtn.x > 0 else -scale_clamp
        if final_scale.y > -scale_clamp and final_scale.y < scale_clamp:
            final_scale.y = scale_clamp if scl_mtn.y > 0 else -scale_clamp

    tween.tween_property(root, property, final_scale, duration)
    
    await tween.finished

func _init_state_machine() -> void:
    hsm.add_transition(idle_state, move_state, idle_state.EVENT_FINISHED)
    hsm.add_transition(move_state, idle_state, move_state.EVENT_FINISHED)
    hsm.add_transition(idle_state, attack_state, "attack")
    hsm.add_transition(move_state, attack_state, "attack")
    hsm.add_transition(attack_state, idle_state, attack_state.EVENT_FINISHED)

    hsm.initialize(self)
    hsm.set_active(true)

func _init_input_events() -> void:
    _add_action("move_left", KEY_A)
    _add_action("move_right", KEY_D)
    _add_action("move_up", KEY_W)
    _add_action("move_down", KEY_S)
    _add_action("attack", KEY_ENTER, KEY_F)

func _add_action(p_action: StringName, p_key: Key, p_alt: Key = KEY_NONE) -> void:
    if not InputMap.has_action(p_action):
        InputMap.add_action(p_action)
        var event := InputEventKey.new()
        event.keycode = p_key
        InputMap.action_add_event(p_action, event)
        if p_alt != KEY_NONE:
            var alt := InputEventKey.new()
            alt.keycode = p_alt
            InputMap.action_add_event(p_action, alt)
