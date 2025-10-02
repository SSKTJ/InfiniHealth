extends Panel


func _on_button_pressed() -> void:
	var bar = get_parent().get_parent().get_node("ProgressBar")
	var tween = get_tree().create_tween()
	tween.tween_property(bar, "value",bar.value+5,0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	pass # Replace with function body.
