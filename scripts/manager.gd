extends Node



# UI update variables 
var max_height : float = 0 
var platform_crossed : int = 0 
var chances_left : int = 3
var high_score : float = 0.0


# platform states 
var current_platform_index: int = 0
var platforms := []  # list of platform node references (ordered from bottom to top)
var base_location : Vector2

var player_position : Vector2

var rigid_ladders := []

# ladder state 
var ladder_is_growing : bool = false
var ladder_is_falling : bool = false  
var ladder_step_length : int = 1 
var ladder_steps_used : int = 0

var player_face_direction : int = 1 # 1 for right , -1 for left
var game_over : bool = false

func reset_manager():
	max_height = 0 
	platform_crossed  = 0 
	chances_left = 3
	current_platform_index = 0
	platforms = []  
	base_location 
	player_position 
	rigid_ladders = []
	ladder_is_growing  = false
	ladder_is_falling  = false  
	ladder_step_length  = 1 
	player_face_direction  = 1 # 1 for right , -1 for left
	game_over  = false
	ladder_steps_used = 0



func free_all_ladders():
	for ladder in rigid_ladders:
		break_ladder(ladder)


func break_ladder(body):
	var full_ladder = body
	if not full_ladder or not full_ladder is RigidBody2D:
		return
	
	for child in full_ladder.get_children():
		if child is Sprite2D:
			# Create new step as RigidBody2D
			var step = RigidBody2D.new()
			
			step.position = child.global_position
			step.rotation = child.global_rotation
			step.gravity_scale = 1.0
			step.angular_damp = 1.0
			step.linear_damp = 0.2
			
			# Visual
			var sprite = Sprite2D.new()
			sprite.texture = child.texture
			sprite.scale = Vector2(0.2, 0.2)
			step.add_child(sprite)
			
			# Collision
			var shape = CollisionShape2D.new()
			var rect = RectangleShape2D.new()
			rect.size = Vector2(40, 20)  # adjust to match your step
			shape.shape = rect
			step.add_child(shape)
			
			var ladder_holder = get_tree().get_root().get_node("Main/ladder_residue")
			if ladder_holder:
				ladder_holder.add_child(step)
				step.collision_layer = 10 # no more collision with ladder or platforms 
				step.collision_mask = 1 # only collide with platforms 
			else:
				print("Ladder residue holder not found!")
			
			# Add random impulse for effect
			var rand_x = randf_range(-500, 500)
			var rand_y = randf_range(-500, 500)
			step.apply_impulse(Vector2(rand_x, rand_y))
			step.apply_torque_impulse(randf_range(-300, 300))

	# Remove the original full ladder
	full_ladder.queue_free()
