extends Node3D

@onready var point_a:Marker3D = %PointA
@onready var point_b:Marker3D = %PointB
@onready var point_c:Marker3D = %PointC
@onready var point_g:Marker3D = %PointG
@onready var point_g_2:Marker3D = %PointG2
@onready var camera:Camera3D = %Camera3D
@onready var anim:AnimationPlayer = $CanvasLayer/Anim
@onready var button_play:Button = %ButtonPlay
@onready var button_options:Button = %ButtonOptions
@onready var button_quit:Button = %ButtonQuit
@onready var player = $Player
@onready var gameboy:GameBoy = %Gameboy

var holding_game:bool = false
var look_point:Marker3D
var direction:Vector3 = Vector3.ZERO
var target_direction:Vector3 = Vector3.ZERO
var mousing:bool = false
var cur_g_point:Marker3D:
	get: return point_g_2 if gameboy.mode == GameBoy.Mode.SHOW_CART else point_g
var _t:Tween



# Called when the node enters the scene tree for the first time.
func _ready():
	cur_g_point = point_g
	#point_g_2.look_at(camera.position)
	gameboy.cart_selected.connect(_on_cart_selected)
	await anim.animation_finished
	look_at_point(point_a)
	button_play.grab_focus()
	pass # Replace with function body.


func _input(event:InputEvent):
	mousing = event is InputEventMouseMotion && event.relative != Vector2.ZERO
	if holding_game:
		if event.is_action_pressed("ui_cancel"):
			if gameboy.mode == GameBoy.Mode.SELECT_CART:
				gameboy.current_cart.queue_free()
				gameboy.mode = GameBoy.Mode.SHOW_CART
				pass
			elif gameboy.mode == GameBoy.Mode.SHOW_CART:
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
		var target_position = cur_g_point.global_position + Vector3(0, -0.45, 0)
		gameboy.global_position = lerp(gameboy.global_position, target_position, delta * 10)
		gameboy.rotation = lerp(gameboy.rotation, cur_g_point.global_rotation, delta * 10)
	pass


func pick_up_gameboy():
	if !holding_game:
		button_play.release_focus()
		gameboy.mode = GameBoy.Mode.SHOW_CART
		anim.play_backwards("menu_fly_in_quick")
		anim.queue("episode_info_fly_in")
		#anim.play("episode_info_fly_in")
		var rot = cur_g_point.global_rotation
		var pos = cur_g_point.global_position + Vector3(0, -0.45, 0)
		if _t != null: 
			_t.kill()
		_t = create_tween()
		_t.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		_t.set_parallel(true)
		_t.tween_property(gameboy,"position", pos, 0.5)
		_t.tween_property(gameboy,"rotation", rot, 0.5)
		#_t.set_parallel(false)
		_t.tween_callback(
			func():
				holding_game = true
		)


func put_down_gameboy():
	if holding_game:
		gameboy.mode = GameBoy.Mode.INACTIVE
		anim.play_backwards("episode_info_fly_in")
		anim.queue("menu_fly_in_quick")
		
		if _t != null: 
			_t.kill()
		_t = create_tween()
		_t.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		_t.set_parallel(true)
		_t.tween_property(gameboy,"position", gameboy.original_position, 0.75)
		_t.tween_property(gameboy,"rotation", gameboy.original_rotation, 0.75)
		#_t.set_parallel(false)
		_t.tween_callback(
			func():
				holding_game = false
				button_play.grab_focus()
		)


func look_at_point(marker:Marker3D):
	look_point = marker


func show_episode_info_ui():
	
	pass


func _on_cart_selected(index:int):
	show_episode_info_ui()
	pass


# play button
func _on_button_play_button_down():
	pick_up_gameboy()
	gameboy.mode = GameBoy.Mode.SHOW_CART
	show_episode_info_ui()

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
