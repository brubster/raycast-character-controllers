extends Control

### 
### gui.gd
### 


@onready var pause_menu: Control = $PauseMenu


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if not pause_menu.is_visible():
			pause_menu.show()
			accept_event()
		else:
			pause_menu.hide()
			accept_event()
	elif event is InputEventKey:
		#get_viewport().set_input_as_handled()
		accept_event()


# Pause Menu Visibility Changed
func _on_pause_menu_visibility_changed():
	if pause_menu.is_visible():
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
