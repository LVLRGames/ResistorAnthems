extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var allow_movement:bool = true

var sensitivity = 0.001



func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		event.relative.x = 0


func _physics_process(_delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	if allow_movement:
		# Handle jump.
		#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			#velocity.y = JUMP_VELOCITY

		var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()
