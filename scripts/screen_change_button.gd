class_name ScreenChangeButton
extends Button

@export var screen: StringName


func _pressed() -> void:
	var ui := get_tree().get_first_node_in_group("ui")
	if ui:
		ui.set_screen(screen)
