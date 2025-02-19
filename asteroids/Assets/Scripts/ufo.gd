extends Node2D

# Variables
@onready var screen_size = get_viewport_rect().size
@export var ufo_bullet : PackedScene

var warp_count = 0
const SPEED = -5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Just calls screen wrap
	_screen_wrap()

# Wraps the ufo to the screen
func _screen_wrap():
	# Makes it so whenever the UFO goes offscreen it will teleport to the other side of the screen
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)

# Randomly moves the UFO when called 
func _random_warp():
	# Range of teleportation is from one side of the screen to the other
	position.x = randf_range(0,960)

# When the timer runs out
func _on_timer_timeout() -> void:
	# Warps randomly 
	_random_warp()
	# Warp counter (if UFO has warped 3 times it is deleted)
	if (warp_count == 3):
		queue_free()
	warp_count += 1

# Timer for shooting
func _on_shoot_timer_timeout() -> void:
	# Instantiates a bullet
	var b = ufo_bullet.instantiate()
	# Adds the bullet to the tree
	get_tree().root.add_child(b)
	# Sets the bullets position
	b.position = global_position

# Checks if a bullet has impacted the asteroid
func _on_area_2d_area_entered(area: Area2D) -> void:
	# If the collision layer is the bullet/player
	if (area.collision_layer == 1):
		# Is the area isnt the player
		if (area.name != "CharacterArea"):
			# Deletes the bullet
			area.queue_free()
		# Deletes the UFO
		queue_free()
		# Adds 150 points to the player score
		GlobalVars.points += 150
