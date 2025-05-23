extends Control
@onready var your_score: Label = $PanelContainer/VBoxContainer/your_score
@onready var high_score: Label = $PanelContainer/VBoxContainer/high_score
@onready var platforms_crossed: Label = $PanelContainer/VBoxContainer/platforms_crossed
@onready var ladder_step_spawned: Label = $PanelContainer/VBoxContainer/ladder_step_spawned


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	your_score.text = "You reached " + str(Manager.max_height) + "m."
	high_score.text = "Your best is " + str(Manager.high_score) + "m."
	platforms_crossed.text = "You crossed " + str(Manager.platform_crossed) +" platforms to reach this height."
	ladder_step_spawned.text = "You Spawned " + str(Manager.ladder_steps_used) + " ladder steps ! "


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui.tscn")
