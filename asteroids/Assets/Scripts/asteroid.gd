extends Node2D

# Variables
@onready var screen_size = get_viewport_rect().size
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var asteroid_sprite: Sprite2D = $AsteroidSprite
@onready var explosion_player: AudioStreamPlayer2D = $ExplosionPlayer

@export var speed_multiplier : float = 1

var asteroid_type : Array = [0, 160, 320]
var speed_x 
var speed_y

# Sets both speeds and the scale
func _ready() -> void:
	# Sets the Asteroids sprite to one of three random sprites to add variety
	asteroid_sprite.region_rect = Rect2(asteroid_type[randi_range(0,2)], 0, 160, 160)
	
	# Randomizes the speed (and the direction) of the asteroids
	speed_x = randf_range(-3, 3)
	speed_y = randf_range(-3, 3)

# Checks every frame if wrapping is needed
func _process(_delta: float) -> void:
	# Calls screen wrap function
	_screen_wrap()

# Moves every frame (60) 
func _physics_process(_delta: float) -> void:
	# Moves the asteroid
	position += Vector2(speed_x , speed_y) * speed_multiplier

# Wraps the asteroid to the screen
func _screen_wrap():
	# Screen wrap, once the asteroid reaches one side of the screen it teleports to the other
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)

# Handles the asteroid splitting on bullet impact
func _duplicate():
	# visible = false
	# collision_shape_2d.disabled = true
	
	# To know when to stop duplicating (happens 2 times)
	if (scale.x > .625):
		# Splits into 2
		for i in 2:
			# Duplicates the asteroid
			var dupe = duplicate(8)
			# Adds the duplicate to the tree
			get_parent().call_deferred("add_child", dupe)
			# Makes the dupe smaller 
			dupe.scale = scale * .75
			# Speeds up the dupe
			dupe.speed_multiplier = speed_multiplier * randf_range(1, 1.5)
	# Plays Explosion noise
	explosion_player.play()
	# Makes the asteroid non-interactable
	visible = false
	# Have to call_deferred so it doesn't error (Why?)
	call_deferred("_disable")
	# Deletes the current asteroid
	# queue_free()

# Checks if a bullet has impacted the asteroid
func _on_area_2d_area_entered(area: Area2D) -> void:
	# If a bullet has entered the asteroid area
	if (area.collision_layer == 1):
		# Makes sure its a bullet
		if (area.name != "CharacterArea"):
			# Frees the bullet
			area.queue_free()
		# Calls duplicate
		_duplicate()
		# Adds points to the global var
		GlobalVars.points += 100

# Func that disables the collision shape
func _disable():
	# Disabled = true
	collision_shape_2d.disabled = true

# Deletes the asteroid once the explosion noise is finished
func _on_explosion_player_finished() -> void:
	# Frees the asteroid obj
	queue_free()
