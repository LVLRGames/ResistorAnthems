@tool
extends Control

const LVLR = preload("res://addons/lvlr_core/textures/lvlr.svg")
const PLYR = preload("res://addons/lvlr_core/textures/plyr.svg")
const WRLD = preload("res://addons/lvlr_core/textures/wrld.svg")

var undo_redo : EditorUndoRedoManager

@onready var tree: Tree = %Tree
@onready var view_mode: TextureButton = %ViewMode
@onready var card_preview: MarginContainer = %CardPreview
@onready var card_info: MarginContainer = %CardInfo



func _ready() -> void:
	view_mode.pressed.connect(
		func():
			if view_mode.button_pressed:
				card_info.hide()
				card_preview.show()
			else:
				card_info.show()
				card_preview.hide()
	)
	
	tree.clear()
	var root = tree.create_item()
	root.set_icon(0,PLYR)
	root.set_text(0,"PLYR")
	for i in range(8):
		var item = tree.create_item(root)
		item.set_icon(0,LVLR)
		item.set_text(0,"LVLR")
		
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass
