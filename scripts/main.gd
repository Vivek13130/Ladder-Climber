extends Node2D

@onready var player: CharacterBody2D = $player

var current_platform: Node2D
var last_platform_position: Vector2
var score: int = 0

func _ready() -> void:
	Manager.base_location = $Platform_manager/StartPlatform.global_position
	$Platform_manager/StartPlatform.get_node("CollisionShape2D").disabled = false

func _process(delta: float) -> void:
	
	if Manager.chances_left < 0:
		game_over()
	
	if $ladder_residue.get_child_count() > 150 : 
		var residue = $ladder_residue.get_children()
		for ind in range(0, 50):
			residue[0].queue_free()


func game_over():
	Manager.game_over = true
	Manager.high_score = max(Manager.high_score, Manager.max_height)
	$CanvasLayer2.visible = true
