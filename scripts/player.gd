extends CharacterBody2D

const SPEED = 200
const JUMP_FORCE = -500
const GRAVITY = 1200

@export var ladder_scene : PackedScene 
@onready var ladder_marker: Marker2D = $Graphics/ladderMarker
@onready var graphics: Node2D = $Graphics

var can_move = true
var has_ladder = false
var ladder_instance : Node = null

enum State { IDLE, GROWING_LADDER, CLIMBING }
var state = State.IDLE

var player_at_platform_ind : int = -1
var printed_warning : bool = false

func _physics_process(delta):
	Manager.max_height = max(Manager.max_height , global_position.distance_to(Manager.base_location) / 100)
	print(Manager.high_score)
	Manager.player_position = global_position
	
	if(Input.is_action_just_pressed("ladder_step") and not has_ladder):
		get_ladder_step()
		Manager.chances_left -= 1
	
	handle_movement(delta)

	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	move_and_slide()

func handle_movement(delta):
	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	
	if(input_vector.x): 
		graphics.scale.x = input_vector.x
	
	velocity.x = input_vector.x * SPEED

	if Input.is_action_just_pressed("jump") :
		velocity.y = JUMP_FORCE


func _input(event):
	if(state == State.CLIMBING):
		return 
	
	# growing ladder :
	if event.is_action_pressed("space") and has_ladder and state != State.CLIMBING:
		state = State.GROWING_LADDER
		if ladder_instance:
			ladder_instance.start_growing()
	
	# releasing ladder :
	if event.is_action_released("space") and state == State.GROWING_LADDER:
		state = State.IDLE
		if ladder_instance:
			
			var dir : String
			if(graphics.scale.x == 1):
				dir = "right"
			else:
				dir = "left"
			ladder_instance.drop_ladder(dir)
			has_ladder = false   
			var leftover_ladders = get_tree().root.get_node("Main/Leftover_Ladders")
			
			if leftover_ladders:

				var ladder = ladder_marker.get_child(0)
				var ladder_global_pos = ladder.global_position
				# Detach ladder safely
				if ladder.get_parent():
					ladder.get_parent().remove_child(ladder)

				# Reparent
				leftover_ladders.add_child(ladder)
				ladder.global_position = ladder_global_pos  # maintain position

				#print("leftover ladders found and added")
				ladder_instance = null
				
			#else: 
				#print("leftover ladders not found")
	
	if event.is_action_pressed("climb_ladder"):
		state = State.CLIMBING
		start_climbing()


func start_climbing():
	pass

func get_next_platform_direction() -> String:
	return "right"


# Called when a platform emits signal saying "player reached me"
func get_ladder_step():
	Manager.free_all_ladders()
	if(has_ladder):
		return
	has_ladder = true
	if ladder_instance:
		ladder_instance.queue_free()
	ladder_instance = ladder_scene.instantiate()
	ladder_marker.add_child(ladder_instance)
	has_ladder = true
	state = State.IDLE
