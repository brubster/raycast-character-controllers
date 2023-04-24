extends Control


func _on_resume_pressed() -> void:
	hide()


func _on_quit_pressed() -> void:
	get_tree().quit()

