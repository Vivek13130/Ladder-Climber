extends Node2D

@onready var player: CharacterBody2D = $player

var current_platform: Node2D
var last_platform_position: Vector2
var score: int = 0
var game_active: bool = true

func _ready() -> void:
	Manager.base_location = $Platform_manager/StartPlatform.global_position
	$Platform_manager/StartPlatform.get_node("CollisionShape2D").disabled = false

func _process(delta: float) -> void:
	if Manager.chances_left < 0:
		game_active = false
	
	if $ladder_residue.get_child_count() > 150 : 
		var residue = $ladder_residue.get_children()
		for ind in range(0, 50):
			residue[0].queue_free()

func game_over():
	if game_active:
		game_active = false
		$UI.show_game_over(score)


func restart_game():
		score = 0
		game_active = true
		
		
		# Delete existing platforms
		for platform in $Platform_manager.get_children():
				platform.queue_free()
		
		player.global_position = $Platform_manager.get_child(0).global_position + Vector2(50 , 150)
		
		
		await get_tree().process_frame
		
		current_platform = $StartPlatform
		
		$UI.update_score(score)
