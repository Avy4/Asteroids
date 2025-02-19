extends Area2D

# Variables
@onready var screen_size = get_viewport_rect().size

var pos_move_to
var rand_change = Vector2(100 * sign(randf_range(-1,1)),0)
const SPEED = 650

# Calls on ready
func _ready():
	# Sets position
	pos_move_to = rand_change + GlobalVars.char_position

# Checks if bullet needs to be wrapped every frame
func _process(delta: float) -> void:
	# Calls screen wrap
	_screen_wrap()
	# If the bullet reaches its position it removes itself
	if (position == pos_move_to):
		queue_free()

# Moves the bullet every fame (60)
func _physics_process(delta: float) -> void:
	# Moves the bullet every frame
	position = position.move_toward(pos_move_to,  SPEED * delta)

# Wraps the bullet to the screen
func _screen_wrap():
	# If the bullet goes offscreen tps it back into bounds
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)

# So the bullet doesn't last forever its deleted on timeout
func _on_timer_timeout() -> void:
	queue_free()
