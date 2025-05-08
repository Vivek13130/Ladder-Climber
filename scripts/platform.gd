extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_platform_appearance()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Make platforms look a bit different
func randomize_platform_appearance():
	# Randomly adjust platform width
	var width_variation = randi_range(-30, 30)
	var new_width = 100 + width_variation
	
	# Update collision shape
	$CollisionShape2D.shape.size.x = new_width
	$Ladder_step_spawner/CollisionShape2D.shape.size.x = new_width
	
	# Update visual appearance
	$Panel.size.x = new_width
	#$Panel.position.x = -new_width / 2
	
	# Slightly randomize color
	var r = randf_range(0.0, 0.9)
	var g = randf_range(0.0, 0.9)
	var b = randf_range(0.0, 0.9)
	$Panel.get("theme_override_styles/panel").bg_color = Color(r, g, b)


func _on_ladder_step_spawner_body_entered(body: Node2D) -> void:
	if(body.is_in_group("player") and Manager.player_has_ladder_step):
		body.get_ladder_step()
