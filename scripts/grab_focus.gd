class_name GrabFocus
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	(get_parent() as CanvasItem).visibility_changed.connect(_on_parent_visibility_changed)
	_on_parent_visibility_changed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_parent_visibility_changed() -> void:
	if get_parent().is_visible_in_tree():
		get_parent().grab_focus()
