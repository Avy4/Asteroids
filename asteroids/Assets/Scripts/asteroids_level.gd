extends Node

# Variables
@onready var points_label: Label = $CanvasLayer/PointsLabel
@onready var heart_container: HBoxContainer = $CanvasLayer/HeartContainer
@onready var asteroids_holder: Node = %AsteroidsHolder
@export var char : PackedScene

var curr_lives = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Resets lives and points on scene load
	GlobalVars.points = 0
	GlobalVars.lives = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Updates the points label very frame
	points_label.text = "Points: " + str(GlobalVars.points)
	# Checks if the character is dead
	if (curr_lives > GlobalVars.lives):
		# == 1 is essentially 0 lives
		if (curr_lives == 1):
			# Changes scene to the main menu
			get_tree().change_scene_to_file("res://Assets/Scenes/main_menu.tscn")
		_reset()

# Reduces the lives by 1 and removes one heart from the gui
func _reset():
	curr_lives -= 1
	var heart = heart_container.get_child(0)
	heart.queue_free()
