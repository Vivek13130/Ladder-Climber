extends Node2D

var ladder_step_scene = preload("res://scenes/ladder_step.tscn")
var grow_timer : float = 0.0 
var spawn_rate : float = 0.05
var step_height := 25
var ladder_step_size : int = 1
var ladder_steps : Array = []  # To store all the ladder steps

var ladder_is_growing : bool = false
var ladder_is_falling : bool = false

var platform_width = 300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_step()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(ladder_is_falling):
		return
	
	if ladder_is_growing:
		grow_timer += delta
		if(grow_timer >= spawn_rate):
			spawn_step()
			grow_timer = 0.0


func start_growing():
	if(not ladder_is_falling):
		ladder_is_growing = true 
		grow_timer = 0.0


# Function to spawn a new ladder step
func spawn_step():
	var step : Sprite2D = ladder_step_scene.instantiate()
	var y_offset = -step_height * ladder_step_size
	step.position = Vector2(0, y_offset)

	# Add the step to the list and scene
	add_child(step)
	$step_add.play()
	ladder_steps.append(step)  # Add to the array
	ladder_step_size += 1


# Function to drop the ladder and combine steps into one rigid body
func drop_ladder(direction: String):
	ladder_is_growing = false 
	ladder_is_falling = true
	
	var full_ladder : RigidBody2D = RigidBody2D.new()
	full_ladder.add_to_group("ladder")
	full_ladder.mass = 0.1
	add_child(full_ladder)
	full_ladder.global_position = ladder_steps[0].global_position  # Position the full ladder at the base of the first step
	
	Manager.rigid_ladders.append(full_ladder)
	# Create a collision shape to represent the full ladder
	var col = CollisionShape2D.new()
	var shape := CapsuleShape2D.new()
	var step_count = ladder_steps.size()
	var step_h = step_height
	var step_w = ladder_steps[0].texture.get_width() * 0.2  # Assuming the width is the same for each step
	shape.height = step_count * step_h
	shape.radius = 25
	col.shape = shape
	full_ladder.add_child(col)
	col.position = Vector2(0, -step_count * step_h / 2 + 8)  # Center the collision shape vertically

	 #Add the sprite visuals for the ladder (they will be positioned on the full ladder)
	# After setting full_ladder.position
	for step in ladder_steps:
		var sprite : Sprite2D = Sprite2D.new()
		sprite.texture = step.texture 
		sprite.scale = Vector2(0.2, 0.2)
		full_ladder.add_child(sprite)
		sprite.global_position = step.global_position  # Place exactly where old step was


	# Remove the old ladder steps from the scene
	for step in ladder_steps:
		step.queue_free()
	ladder_steps.clear()

	# Apply torque impulse to make it fall in the specified direction
	var dir = -1 if (direction == "left") else 1
	full_ladder.rotation = deg_to_rad(dir * 5)
	
	check_ladder_validity(full_ladder)


func check_ladder_validity(full_ladder : RigidBody2D):
	var curr_index = Manager.current_platform_index
	var curr_platform = Manager.platforms[curr_index]
	var next_platform = Manager.platforms[curr_index + 1]
	
	var player_position = Manager.player_position
	
	var dist1 = player_position.distance_to(next_platform.global_position )
	var dist = player_position.distance_to(next_platform.global_position )
	var required_steps = int(round(min(dist, dist1) / step_height))
	
	#print("required steps : ", required_steps, "  steps found : ", ladder_step_size)
	
	if ladder_step_size - required_steps > 10:
		await get_tree().create_timer(3.0).timeout
		break_ladder(full_ladder)

	elif ladder_step_size - required_steps  < -5:
		await get_tree().create_timer(3.0).timeout
		break_ladder(full_ladder)



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
