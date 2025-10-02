extends Node2D  # Or Control if it's a GUI scene

# Path to your main screen scene
const MAIN_SCENE_PATH = "res://main.tscn"

func ready():
	print("Hello")
	# Wait 2 seconds, then change scene
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file(MAIN_SCENE_PATH)
