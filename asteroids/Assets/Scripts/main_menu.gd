extends Node

# Variables
@onready var last_score: Label = $CanvasLayer/LastScore

# Runs on node ready
func _ready() -> void: 
	# Sets the score text as the previous score (or 0 if it hasn't been played yet)
	last_score.text = "Previous Score: " + str(GlobalVars.points)

# On button click
func _on_button_pressed() -> void:
	# Changes the scene to the game level
	get_tree().change_scene_to_file("res://Assets/Scenes/asteroids_level.tscn")
