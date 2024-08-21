extends StaticBody2D

enum EXPECTED {BIG, SMALL, NORMAL}

@export var expected: EXPECTED
@onready var chkScale: Check_Scale_Attribute = $CheckScale

@onready var hsm: LimboHSM = $LimboHSM
@onready var shut_state: LimboState = $LimboHSM/ShutState
@onready var open_state: LimboState = $LimboHSM/OpenState

func _ready():
    _init_state_machine()
    chkScale.check_scale.connect(_check_scale)

func _check_scale(source: ScaleBox):
    var abs_scale = Vector2(abs(source.root.scale.x), source.root.scale.y)
    
    if abs_scale == Vector2(0.5, 0.5) and expected == EXPECTED.SMALL:
        hsm.dispatch("open")
    elif abs_scale == Vector2(1, 1) and expected == EXPECTED.NORMAL:
        hsm.dispatch("open")
    elif abs_scale == Vector2(1.5, 1.5) and expected == EXPECTED.BIG:
        hsm.dispatch("open")

func _init_state_machine() -> void:
    hsm.add_transition(shut_state, open_state, "open")

    hsm.initialize(self)
    hsm.set_active(true)
