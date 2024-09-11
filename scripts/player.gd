extends CharacterBody3D


var sensitivity = 0.001



func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
