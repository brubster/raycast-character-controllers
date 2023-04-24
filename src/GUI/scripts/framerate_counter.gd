extends Control


@onready var counter: Label = $HBoxContainer/Counter


func _process(_delta: float) -> void:
	counter.set_text("FPS: " + str(Engine.get_frames_per_second()))

