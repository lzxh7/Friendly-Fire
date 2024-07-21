extends Node

var world_scene := preload("res://scenes/world.tscn")
var score: int = 0
var world: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func new_game() -> void:
	score = 0
	world = get_tree().get_first_node_in_group("world")
	if world:
		world.queue_free()
	world = world_scene.instantiate()
	add_child(world)
	await get_tree().process_frame # wait for the world to free so we don't have 2 players
	var player = get_tree().get_first_node_in_group("player")
	player.game_over.connect($UI.set_screen.bind(&"GameOver"))


func add_score(amount: int) -> void:
	if $UI.screen_name == &"InGame":
		score += amount * world.get_node("Camera2D/EnemySpawner").wave


func _on_ui_screen_changed(screen: StringName) -> void:
	if screen == &"InGame":
		new_game()
	if screen != &"InGame" and screen != &"GameOver":
		world = get_tree().get_first_node_in_group("world")
		if world:
			world.queue_free()
	if screen == &"GameOver":
		AudioServer.set_bus_mute(AudioServer.get_bus_index(&"SFX"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(&"SFX"), false)


func set_bullet(scene) -> void:
	world.get_node("Player").bullet_scene = scene
