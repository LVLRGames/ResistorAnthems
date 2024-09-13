class_name GameBoy
extends Node3D

signal cart_selected(index:int)

const CARTRIDGE = preload("res://scenes/cartridge.tscn")
enum Mode {INACTIVE, SELECT_CART, SHOW_CART}

@onready var light = $Light
@onready var anim = $Anim
@onready var carousel: Node3D = $CartCarousel

var mode:Mode = Mode.INACTIVE
var lit:bool = false
var radius: float = 0.33  # Distance from the gameboy
var num_items: int = 5  # Number of cartridges
var angle_between_items: float = PI / 3.0  # Angle between each cartridge
var current_index: int = 0  # Currently selected index
var carts_showing:bool = false
var carousel_items = []  # Array to hold the cartridge nodes
var rotation_speed: float = 2.0  # Speed of carousel rotation
var original_position:Vector3 = Vector3.ZERO
var original_rotation:Vector3 = Vector3.ZERO
var _t:Tween
var current_cart:
	get: 
		if current_index < carousel_items.size():
			return carousel_items[current_index]
		else:
			return null


func _ready():
	original_position = global_position
	original_rotation = global_rotation
	carousel.rotation_degrees.y = 180
	angle_between_items = (2*PI)/num_items
	

func _input(event):
	if carts_showing:
		# Handle scrolling through the carousel
		if event.is_action_pressed("ui_left"):
			rotate_carousel(-1)
		elif event.is_action_pressed("ui_right"):
			rotate_carousel(1)
		if event.is_action_pressed("ui_accept") and mode != Mode.SHOW_CART:
			carousel_items[current_index].press()


func show_game_info():
	toggle_carousel(false)
	current_cart._t.kill()
	current_cart.reparent(self)
	current_cart.position = Vector3(-0.25, 0.2, 0.25)
	mode = Mode.SHOW_CART
	cart_selected.emit(current_index)
	pass


func toggle_carousel(on:bool):
	#if carts_showing != on: return
	if _t != null:
		_t.kill()
	_t = create_tween()
	_t.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_t.tween_property(carousel, "scale", Vector3.ONE * (1.0 if on else 0.001), 0.33)
	_t.tween_callback(
		func():
			carts_showing = on
	)


func toggle_hilight(on:bool):
	if on:
		if !lit:
			anim.play("hilight")
			lit = true
	else:
		if lit:
			anim.play_backwards("hilight")
			lit = false


func clear_carousel():
	current_index = clampi(current_index, 0, num_items)
	carousel_items.clear()
	for child in carousel.get_children():
		child.queue_free()
	num_items = Global.available_episodes.size()
	angle_between_items = (2*PI)/num_items


func show_cartridges():
	clear_carousel()
	#if !carts_showing:
	#await get_tree().create_timer(0.15).timeout
	toggle_carousel(true)
	toggle_hilight(true)
	
	if carousel_items.size() == 0:
		# Create or arrange the cartridges in a circle
		for i in range(Global.available_episodes.size()):
			var cartridge = CARTRIDGE.instantiate()
			carousel.add_child(cartridge)
			carousel_items.append(cartridge)
			cartridge.position = calculate_position(i)
			cartridge.rotation_degrees.y = 90
			cartridge.game_name = Global.available_episodes[i].name
			cartridge.pressed.connect(_on_cart_pressed)
			#position_cartridge(cartridge, i)
	hilight_cartridge(current_index)
	rotate_carousel(0)
	mode = Mode.SELECT_CART


func hide_cartridges():
	toggle_carousel(false)
	if mode == Mode.SELECT_CART:
		mode = Mode.INACTIVE
	elif mode == Mode.SHOW_CART:
		mode = Mode.SELECT_CART


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


func _on_cart_pressed():
	show_game_info()
