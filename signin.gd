extends Button


func _on_pressed() -> void:
	if($LineEdit.text == "Tagda" && $LineEdit2.text == "Admin"):
		get_tree().change_scene_to_file("res://main.tscn")
	pass # Replace with function body.
