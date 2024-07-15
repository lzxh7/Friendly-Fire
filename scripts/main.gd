extends Node

var world_scene := preload("res://scenes/world.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func new_game() -> void:
	var world = get_tree().get_first_node_in_group("world")
	if world:
		world.queue_free()
	add_child(world_scene.instantiate())
	await get_tree().process_frame # wait for the world to free so we don't have 2 players
	var player = get_tree().get_first_node_in_group("player")
	player.game_over.connect($"UI/GameOver".show)
