extends Node3D

@onready var point_a:Marker3D = %PointA
@onready var point_b:Marker3D = %PointB
@onready var point_c:Marker3D = %PointC
@onready var point_g:Marker3D = %PointG
@onready var camera:Camera3D = %Camera3D
@onready var anim:AnimationPlayer = $CanvasLayer/Anim
@onready var button_play:Button = %ButtonPlay
@onready var button_options:Button = %ButtonOptions
@onready var button_quit:Button = %ButtonQuit
@onready var player = $Player
@onready var gameboy:GameBoy = $Gameboy

var holding_game:bool = false
var look_point:Marker3D
var direction:Vector3 = Vector3.ZERO
var target_direction:Vector3 = Vector3.ZERO
var mousing:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	await anim.animation_finished
	look_at_point(point_a)
	button_play.grab_focus()
	pass # Replace with function body.


func _input(event:InputEvent):
	mousing = event is InputEventMouseMotion && event.relative != Vector2.ZERO
	if holding_game:
		if event.is_action_pressed("ui_cancel"):
			put_down_gameboy()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if look_point != null:
		if !holding_game && !mousing:
			
			 # Get direction vector from player to the look point
			direction = (player.global_position - look_point.global_position).normalized()
			
			# Calculate Y (horizontal) rotation for the player
			var target_y_angle = -atan2(direction.x, direction.z)
			
			# Lerp the player's Y rotation towards the target Y angle
			player.rotation.y = lerp_angle(player.rotation.y, -target_y_angle, delta * 3)
			
			# Calculate X (vertical) rotation for the camera (pitch)
			var camera_to_point = camera.global_position - look_point.global_position
			var target_x_angle = -asin(camera_to_point.y / camera_to_point.length())
			
			# Lerp the camera's X rotation towards the target X angle
			camera.rotation.x = lerp(camera.rotation.x, target_x_angle, delta * 3)
	pass


func _physics_process(delta):
	if holding_game:
		var target_position = point_g.global_position + Vector3(0, -0.45, 0)
		gameboy.global_position = lerp(gameboy.global_position, target_position, delta * 3)
		gameboy.rotation = lerp(gameboy.rotation, point_g.global_rotation, delta * 1.5)
	pass


func pick_up_gameboy():
	button_play.release_focus()
	holding_game = true
	await get_tree().create_timer(1).timeout
	gameboy.show_cartridges()


func put_down_gameboy():
	gameboy.hide_cartridges()
	var _t = create_tween()
	_t.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_t.set_parallel(true)
	_t.tween_property(gameboy,"position", gameboy.original_position, 1.5)
	_t.tween_property(gameboy,"rotation", gameboy.original_rotation, 1.5)
	_t.tween_callback(
		func():
			holding_game = false
			button_play.grab_focus()
			#gameboy.reparent(point_g)
			#gameboy.global_rotation = gameboy.original_rotation
			#gameboy.global_position = gameboy.original_position
	)



func look_at_point(marker:Marker3D):
	look_point = marker



# play button
func _on_button_play_pressed():
	pick_up_gameboy()

func _on_button_play_focus_entered():
	look_at_point(point_b)
	gameboy.toggle_hilight(true)

func _on_button_play_focus_exited() -> void:
	if !holding_game:
		gameboy.toggle_hilight(false)
	pass # Replace with function body.



# option button
func _on_button_options_pressed() -> void:
	#open_options_menu()
	pass # Replace with function body.

func _on_button_options_focus_entered():
	look_at_point(point_a)

func _on_button_options_focus_exited() -> void:
	pass # Replace with function body.



# quit button
func _on_button_quit_pressed():
	get_tree().quit()

func _on_button_quit_focus_entered() -> void:
	look_at_point(point_c)
	# fade camera and sound
	pass # Replace with function body.

func _on_button_quit_focus_exited() -> void:
	# unfade camera and sound
	pass # Replace with function body.
