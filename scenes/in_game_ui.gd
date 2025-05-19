extends Control
@onready var height_label: Label = $PanelContainer/VBoxContainer/heightLabel
@onready var platform_crossed_label: Label = $PanelContainer/VBoxContainer/platformCrossedLabel
@onready var chances_left_label: Label = $PanelContainer/VBoxContainer/chancesLeftLabel


func _ready() -> void:
	height_label.text = "Height : " + str(Manager.max_height) + " m"
	platform_crossed_label.text = "Platforms crossed : " + str(Manager.platform_crossed)
	chances_left_label.text = "Chances Left : " + str(Manager.chances_left)


func _process(delta: float) -> void:
	height_label.text = "Height : " + str(Manager.max_height) + " m"
	platform_crossed_label.text = "Platforms crossed : " + str(Manager.platform_crossed)
	chances_left_label.text = "Chances Left : " + str(Manager.chances_left)
