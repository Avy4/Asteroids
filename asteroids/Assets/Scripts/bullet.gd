extends Area2D

# Variables
@onready var screen_size = get_viewport_rect().size
@onready var timer: Timer = $Timer

const SPEED = 650

# Checks if bullet needs to be wrapped every frame
func _process(delta: float) -> void:
	_screen_wrap()

# Moves the bullet every fame (60)
func _physics_process(delta: float) -> void:
	# Moves the actual bullet
	position += transform.x * SPEED * delta

# Wraps the bullet to the screen
func _screen_wrap():
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)

# Deletes the bullet after a set amount of time
func _on_timer_timeout() -> void:
	# Frees the bullet so there arent an infinite number of bullets flying around
	queue_free()
