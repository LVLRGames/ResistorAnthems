extends Node

@onready var light = $Light
@onready var anim = $Anim

var lit:bool = false


func toggle_hilight():
	if !lit:
		anim.play("hilight")
	else:
		anim.play_backwards("hilight")
	
	await anim.animation_finished
	lit = !lit
