extends AudioStreamPlayer

# please godot give us typed dictionaries i want to export this
var music_map := {
	&"InGame": preload("res://addons/nes_shooter_music/Mercury.wav"),
	&"GameOver": preload("res://addons/nes_shooter_music/Map (basic version).wav"),
	&"MainMenu": preload("res://addons/nes_shooter_music/Map.wav"),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_ui_screen_changed(screen: StringName) -> void:
	if screen in music_map and stream != music_map[screen]:
		stream = music_map[screen]
		play()


func _on_finished() -> void:
	play()
