extends Node2D

@onready var platform_manager: Node2D = $"../Platform_manager"
var platform_scene : PackedScene = preload("res://scenes/platform.tscn")



var count = 0 

func _process(delta):
	ensure_platforms_ahead()
	count += 1
	if(count >= 1020):
		count = 0


func ensure_platforms_ahead(min_ahead := 5):
	var current = Manager.current_platform_index
	var needed = max(min_ahead - ( Manager.platforms.size() - current ) , 0)

	for i in range(needed):
		var new_platform = platform_scene.instantiate()
		new_platform.position = calculate_next_position(Manager.platforms[Manager.platforms.size()-1].global_position)
		platform_manager.add_child(new_platform)
		new_platform.collision_layer = 10


var step_y := 200  # vertical gap between platforms
var step_x := 600  # horizontal base offset
var offset_range := 100  # randomness in horizontal offset
var last_direction := 1  # 1 for right, -1 for left

func calculate_next_position(curr_pos: Vector2) -> Vector2:
	# Alternate direction
	last_direction *= -1

	# Add small random horizontal variation
	var x_offset := step_x * last_direction + randf_range(-offset_range, offset_range)
	var y_offset := -step_y + randf_range(-offset_range/2, offset_range/2)

	return curr_pos + Vector2(x_offset, y_offset)



func cleanup_old_platforms(min_behind := 2):
	var current = Manager.current_platform_index

	while current - min_behind > 0:
		var platform_to_remove = Manager.platforms[0]
		platform_to_remove.queue_free()
		Manager.platforms.remove_at(0)
		current -= 1
		Manager.current_platform_index -= 1  # update index since bottom is removed
