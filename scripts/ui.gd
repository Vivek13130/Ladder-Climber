extends Control


# Called when the node enters the scene tree for the first time.
@onready var label: Label = $Panel/VBoxContainer/Label

func _ready() -> void:
	label.text = "Highscore : " + str(Manager.high_score) + " m"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = "Highscore : " + str(Manager.high_score) + " m"



func _on_button_pressed() -> void:
	Manager.reset_manager()
	get_tree().change_scene_to_file("res://scenes/main.tscn")
