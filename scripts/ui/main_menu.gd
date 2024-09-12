extends Node3D

@onready var point_a = $PointA
@onready var point_b = $PointB
@onready var point_g = %PointG
@onready var camera = %Camera3D
@onready var anim = $CanvasLayer/Anim
@onready var button_play = %ButtonPlay
@onready var button_options = %ButtonOptions
@onready var button_quit = %ButtonQuit
@onready var player = $Player
@onready var gameboy = $Gameboy

var holding_game:bool = false
var look_point:Marker3D

# Called when the node enters the scene tree for the first time.
func _ready():
	await anim.animation_finished
	look_at_point(point_a)
	button_play.grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if look_point != null:
		if !holding_game:
			 # Get direction vector from player to the look point
			var direction = (look_point.global_position - player.global_position).normalized()
			
			# Calculate Y (horizontal) rotation for the player
			var target_y_angle = atan2(direction.x, direction.z)
			
			# Lerp the player's Y rotation towards the target Y angle
			player.rotation.y = lerp_angle(player.rotation.y, target_y_angle, delta * 3)
			
			# Calculate X (vertical) rotation for the camera (pitch)
			var camera_to_point = look_point.global_position - camera.global_position
			var target_x_angle = -asin(camera_to_point.y / camera_to_point.length())
			
			# Lerp the camera's X rotation towards the target X angle
			camera.rotation.x = lerp(camera.rotation.x, target_x_angle, delta * 3)
			
		#var global_pos = camera.global_transform.origin
		#var target_pos = look_point.global_transform.origin
		#var rotation_speed = 0.1
		#var wtransform = camera.global_transform.looking_at(Vector3(target_pos.x,global_pos.y,target_pos.z),Vector3(0,1,0))
		#var wrotation = Quaternion(camera.global_transform.basis).slerp(Quaternion(wtransform.basis), rotation_speed)
#
		#camera.global_transform = Transform3D(Basis(wrotation), camera.global_transform.origin)
	pass


func _physics_process(delta):
	#if look_point != null:
		#player.look_at(look_point.global_position)
	if holding_game:
		var target_position = point_g.global_position + Vector3(0, -0.45, 0)
		gameboy.global_position = lerp(gameboy.global_position, target_position, delta * 3)
		gameboy.rotation = lerp(gameboy.rotation, point_g.global_rotation, delta * 1.5)
	pass


func pick_up_gameboy():
	holding_game = true


func put_down_gameboy():
	var _t = create_tween()
	_t.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_t.set_parallel(true)
	_t.tween_property(gameboy,"position", point_b.global_position, 1.5)
	_t.tween_property(gameboy,"rotation", Vector3.ZERO, 1.5)
	#_t.tween_callback(
		#func():
			#gameboy.reparent(point_g)
			#gameboy.rotation = Vector3.ZERO
			#gameboy.position = Vector3(0, -0.5, 0)
	#)



func look_at_point(marker:Marker3D):
	look_point = marker
	


func _on_button_play_focus_entered():
	look_at_point(point_b)
	gameboy.toggle_hilight()
	pass # Replace with function body.


func _on_button_play_focus_exited():
	gameboy.toggle_hilight()
	pass # Replace with function body.


func _on_button_play_pressed():
	pick_up_gameboy()
	pass # Replace with function body.


func _on_button_options_focus_entered():
	look_at_point(point_a)
	pass # Replace with function body.


func _on_button_options_pressed():
	pass # Replace with function body.


func _on_button_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.
