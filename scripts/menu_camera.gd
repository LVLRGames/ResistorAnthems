extends Camera3D

var sensitivity = 0.001
var camera_anglev=0


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if event is InputEventMouseMotion:
		rotate_x(-event.relative.y * sensitivity)
		event.relative.y = 0
