extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Manager.death_zone_pos_y = global_position.y


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("player")):
		Manager.chances_left = -1
		print("YOU DIED !!!")
	elif(body.is_in_group("ladder")):
		Manager.break_ladder(body)
	else :
		body.queue_free()
