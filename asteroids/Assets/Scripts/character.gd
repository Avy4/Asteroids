extends CharacterBody2D

# Variables
@onready var screen_size = get_viewport_rect().size
@onready var bullet_holder: Node = %BulletHolder
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var shoot_pos: Marker2D = $ShootPos
@onready var lazer_beam_player: AudioStreamPlayer2D = $LazerBeamPlayer
@export var bullet : PackedScene

const SPEED = 250.0
const ROTATION = 5.0
const ACCELERATION = 5.0

# Runs screen wrap every frame
func _process(_delta: float) -> void:
	# Calls screen wrap
	_screen_wrap()
	# Sets char_position to the characters current global position every frame
	GlobalVars.char_position = global_position

# Movement
func _physics_process(_delta: float) -> void:
	# Function calls
	_shoot()
	_move()
	_warping()

# Wraps the airplane to the screen
func _screen_wrap():
	# Tps the character back into bounds it if ever leaves
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)

# Function that handles shooting
func _shoot():
	# Checks if shoot is presses and if there are not 4 bullets on screen
	if (Input.is_action_just_pressed("shoot") && bullet_holder.get_child_count() < 4):
		# Creates the bullet
		var b = bullet.instantiate()
		# Plays bullet firing noise
		lazer_beam_player.play()
		# Adds the bullet to the tree
		bullet_holder.add_child(b)
		# Sets the position of the bullet
		b.transform = shoot_pos.global_transform

# Function that handles movement
func _move():
	# Checks if forward is pressed
	if (Input.is_action_pressed("forward")):
		# Adds velocity (rotated so it goes in the right direction)
		velocity = Vector2(1, 0).rotated(rotation) * SPEED
		# Plays boosting animation
		animation_player.play("boost")
	else:
		# Deceleration 
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION)
		# Animation changes to no boost
		animation_player.play("no_boost")
	# If left is pressed
	if (Input.is_action_pressed("left")):
		# Rotates left
		rotate(-ROTATION * PI/180)
	# If right is pressed
	if (Input.is_action_pressed("right")):
		# Rotates right
		rotate(ROTATION * PI/180)
	# Call to movement
	move_and_slide()

# Hyper space warp, essentially just sends you to a random point on the screen
func _warping():
	# Checks if hyper space warp is called
	if (Input.is_action_just_pressed("hyperspace_warp")):
		# After three seconds a random tp is called
		await get_tree().create_timer(.3).timeout
		position = Vector2(randf_range(0,960), randf_range(0,960))

# If an asteroid or ufo collides with the player
func _on_character_area_area_entered(area: Area2D) -> void:
	# Makes sure it was an asteroid or ufo
	if (area.collision_layer == 2):
		# Resets the players position to the center of the screen
		position = Vector2(480,480)
		# Reduces lives by 1 
		GlobalVars.lives -= 1
