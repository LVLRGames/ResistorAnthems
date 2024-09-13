class_name GameBoy
extends Node3D

const CARTRIDGE = preload("res://scenes/cartridge.tscn")

@onready var light = $Light
@onready var anim = $Anim
@onready var carousel: Node3D = $CartCarousel

var lit:bool = false
var radius: float = 0.33  # Distance from the gameboy
var num_items: int = 5  # Number of cartridges
var angle_between_items: float = PI / 3.0  # Angle between each cartridge
var current_index: int = 0  # Currently selected index
var carts_showing:bool = false
var carousel_items = []  # Array to hold the cartridge nodes
var rotation_speed: float = 2.0  # Speed of carousel rotation
var original_position:Vector3 = global_position
var original_rotation:Vector3 = global_rotation



func _ready():
	original_position = global_position
	original_rotation = global_rotation
	carousel.rotation_degrees.y = 180
	angle_between_items = (2*PI)/num_items
	

func _input(event):
	# Handle scrolling through the carousel
	if event is InputEventKey:
		if event.is_action_pressed("ui_left"):
			rotate_carousel(-1)
		elif event.is_action_pressed("ui_right"):
			rotate_carousel(1)


func toggle_carousel(on:bool):
	var _t = create_tween()
	_t.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_t.tween_property(carousel, "scale", Vector3.ONE * (1 if on else 0.001), 0.33)
	



func toggle_hilight(on:bool):
	if on:
		if !lit:
			anim.play("hilight")
			lit = true
	else:
		if lit:
			anim.play_backwards("hilight")
			lit = false


func show_cartridges():
	if !carts_showing:
		toggle_carousel(true)
		print(lit)
		toggle_hilight(true)
		
		if carousel_items.size() == 0:
			# Create or arrange the cartridges in a circle
			for i in range(num_items):
				var cartridge = CARTRIDGE.instantiate()
				carousel.add_child(cartridge)
				carousel_items.append(cartridge)
				cartridge.position = calculate_position(i)
				cartridge.rotation_degrees.y = 90
				cartridge.game_name += str(i)
				#position_cartridge(cartridge, i)

		carts_showing = true
		hilight_cartridge(0)


func hide_cartridges():
	if carts_showing:
		#toggle_hilight(false)
		toggle_carousel(false)
		carts_showing = false


func hilight_cartridge(index:int):
	var cartridge = carousel_items[index]
	if index == current_index:
		if !cartridge.is_hilighted:
			cartridge.hilight()
	else: 
		if cartridge.is_hilighted:
			cartridge.unhilight() 



func rotate_carousel(direction: int):
	current_index = wrap(current_index - direction, 0, num_items)
	for i in range(num_items):
		var new_index = (i - current_index) % num_items
		var cartridge = carousel_items[i]
		
		hilight_cartridge(i)
		
		# Use a tween to animate the transition smoothly
		var _tween = create_tween()
		_tween.set_parallel()
		_tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		_tween.tween_property(cartridge, "position", calculate_position(new_index), 0.5)
		_tween.tween_property(cartridge, "rotation_degrees", Vector3(0,90,0), 0.8)


func calculate_position(index: int) -> Vector3:
	var angle = angle_between_items * index
	var x = radius * cos(angle)
	var z = radius * sin(angle)
	return carousel.position + Vector3(x, -0.5, z)
