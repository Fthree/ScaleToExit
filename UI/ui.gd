extends CanvasLayer

@onready var tutorial: Node2D = $Tutorial
@onready var tutorial_hidden: Node2D = $TutorialHidden

@export var start_tutorial_hidden: bool = true

func _ready():
	_init_input_events()

	if start_tutorial_hidden:
		tutorial.hide()
		tutorial_hidden.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_focus_next"):
		if tutorial.visible:
			tutorial.hide()
			tutorial_hidden.show()
		else:
			tutorial_hidden.hide()
			tutorial.show()
		
		await get_tree().create_timer(1).timeout

	
func _init_input_events() -> void:
	_add_action("ui_focus_next", KEY_TAB)

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
