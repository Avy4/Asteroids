extends PathFollow2D

# Variables
@onready var marker_2d: Marker2D = $UFOMarker2D
@export var spawn : PackedScene

# Every frame (60 fps)
func _physics_process(delta: float) -> void:
	# Increases progress by .01 to .1 (out of 1) to randomize UFO spawns
	progress_ratio += randf_range(.01, .1)

# Runs on timer timeout
func _on_timer_timeout() -> void:
	# Gets the position of the marker_2d (changes based on progress ratio)
	var pos = marker_2d.global_position
	# Spawns a new UFO
	var new = spawn.instantiate()
	# Adds the new UFO to the scene tree
	get_tree().root.add_child(new)
	# Sets the position correctly
	new.position = pos
