extends Node3D

signal pressed

@onready var label: Label3D = $Label3D
@onready var cuboid: MeshInstance3D = $blockbench_export/Node/cuboid

@export var game_name:String = "GameName":
	set(v): 
		game_name = v
		label.text = v

var is_hilighted:bool = false
var _t:Tween

func _ready() -> void:
	label.text = game_name
	cuboid.mesh = cuboid.mesh.duplicate()
	cuboid.mesh.surface_set_material(0, cuboid.mesh.surface_get_material(0).duplicate())
	unhilight()
	pass # Replace with function body.


func press():
	var _pt = create_tween()
	_pt.set_parallel()
	_pt.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_pt.tween_property(label, "modulate", Color.GREEN, 0.125)
	_pt.tween_property(label, "modulate", Color.WHITE, 0.125).set_delay(0.125)
	_pt.tween_property(self, "scale", Vector3.ONE * 0.5, 0.15)
	_pt.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_pt.tween_property(self, "scale", Vector3.ONE * 1.0, 0.5).set_delay(0.15)
	_pt.set_parallel(false)
	_pt.tween_callback(
		func():
			pressed.emit()
	#).set_delay(0.35)
	)


func hilight():
	cuboid.mesh.surface_get_material(0).set("shading_mode", BaseMaterial3D.SHADING_MODE_UNSHADED)
	label.modulate = Color.TRANSPARENT
	label.show()
	if _t != null: 
		_t.kill()

	_t = create_tween()
	_t.set_parallel()
	_t.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_t.tween_property(label, "modulate", Color.WHITE, 0.25)
	_t.tween_property(label, "scale", Vector3.ONE, 0.5)
	_t.tween_property(self, "scale", Vector3.ONE * 1.35, 0.15)
	_t.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#_t.set_parallel(false)
	_t.tween_property(self, "scale", Vector3.ONE * 1.0, 0.5).set_delay(0.15)
	_t.tween_callback(
		func():
			is_hilighted = true
	)
	pass


func unhilight():
	cuboid.mesh.surface_get_material(0).set("shading_mode", BaseMaterial3D.SHADING_MODE_PER_PIXEL)
	if _t != null: 
		_t.kill()
	_t = create_tween()
	_t.set_parallel()
	_t.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_t.tween_property(label, "modulate", Color.TRANSPARENT, 0.25)
	_t.tween_property(label, "scale", Vector3.ONE * 0.001, 0.25)
	_t.tween_property(self, "scale", Vector3.ONE * 1.0, 0.5)
	_t.tween_callback(
		func():
			label.hide()
			is_hilighted = false
	)
	pass
