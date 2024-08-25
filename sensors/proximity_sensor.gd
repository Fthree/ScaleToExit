class_name ProximitySensor
extends Box

## Area that registers damage.
signal in_proximity(source: Box)

@export var check_interval: float = 0.5  # Interval in seconds

var current_source: Box
var check_timer: Timer

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
	# Set up the Timer
	check_timer = Timer.new()
	check_timer.wait_time = check_interval
	check_timer.one_shot = false
	check_timer.connect("timeout", _on_timer_timeout.bind())
	add_child(check_timer)

func _on_area_entered(source: Box) -> void:
	if source.is_in_group("agent"):
		current_source = source
		check_timer.start()  # Start the timer when an agent enters the area

func _on_area_exited(source: Box) -> void:
	if source.is_in_group("agent"):
		current_source = null
		check_timer.stop()  # Stop the timer when an agent exits the area

func _on_timer_timeout() -> void:
	if current_source:
		in_proximity.emit(current_source)
