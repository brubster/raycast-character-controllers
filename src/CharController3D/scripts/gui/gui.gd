extends Control

### 
### gui.gd
### 

signal can_move(val: bool)

@onready var pause_menu: Control = $PauseMenu


# Catch input if menu(s) are visible
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if not pause_menu.is_visible():
			pause_menu.show()
		else:
			pause_menu.hide()


# Pause Menu Visibility Changed
func _on_pause_menu_visibility_changed():
	if pause_menu.is_visible():
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		can_move.emit(false)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		can_move.emit(true)

