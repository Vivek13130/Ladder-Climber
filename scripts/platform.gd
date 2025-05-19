extends StaticBody2D

var served_ladder_step : bool = false


func _ready() -> void:
	Manager.platforms.append(self)


func _on_ladder_step_spawner_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not served_ladder_step:
		Manager.platform_crossed += 1
		Manager.current_platform_index += 1
		Manager.platforms[Manager.current_platform_index].collision_layer = 1
		print("reached new platform : " , Manager.current_platform_index)
		body.get_ladder_step()
		served_ladder_step = true
