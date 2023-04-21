extends Control


func _input(event: InputEvent) -> void:
	if event is InputEventKey and is_visible():
		get_viewport().set_input_as_handled()


func _on_resume_pressed() -> void:
	hide()


func _on_quit_pressed() -> void:
	get_tree().quit()

