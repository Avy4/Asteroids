extends PathFollow2D

# Variables
@onready var marker_2d: Marker2D = $AsteroidMarker2D
@onready var asteroids_holder: Node = %AsteroidsHolder
@export var spawn : PackedScene

# Runs every frame (const 60 frames)
func _physics_process(_delta: float) -> void:
	# Increases progress by .01 to .1 (out of 1) to randomize asteroid spawns
	progress_ratio += randf_range(.01, .1)

# Runs on timer timeout
func _on_timer_timeout() -> void:
	# Gets the position of the marker_2d (changes based on progress ratio)
	var pos = marker_2d.global_position
	# Spawns a new asteroid
	var new = spawn.instantiate()
	# Sets the position correctly
	new.position = pos
	# Attaches the asteroid to the scene
	asteroids_holder.add_child(new)
