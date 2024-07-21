extends CanvasLayer

signal screen_changed(screen: StringName)

@export var screen_name = &"MainMenu"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_screen(screen: StringName) -> void:
	for child in $Screens.get_children():
		if child.name == screen:
			child.show()
		else:
			child.hide()
	screen_name = screen
	screen_changed.emit(screen)
	


func _on_screen_changed(screen: StringName) -> void:
	if screen == &"InGame" or screen == &"GameOver":
		$InGameHUD.show()
	else:
		$InGameHUD.hide()
