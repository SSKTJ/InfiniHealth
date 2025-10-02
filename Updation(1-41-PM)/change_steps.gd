extends RichTextLabel

func _ready():
	print("Ready!")
	$Timer.start()
	await get_tree().create_timer(1.0).timeout

#func _process(delta):
	#await get_tree().create_timer(1.0).timeout
	#self.text = str(int(self.text) + 1) + " Steps"

func _on_timer_timeout() -> void:
	self.text = str(int(self.text) + 1) + " Steps"
