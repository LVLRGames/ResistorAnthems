@tool
extends EditorPlugin

const UI = preload("res://addons/lvlr_core/ui/ui.tscn")

var ui

func _enter_tree() -> void:
	ui = UI.instantiate()
	
	add_control_to_dock(DOCK_SLOT_LEFT_BL, ui)
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	remove_control_from_docks(ui)
	ui.queue_free()
	# Clean-up of the plugin goes here.
	pass
