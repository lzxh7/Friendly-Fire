extends Path2D

@export var enemy_spawns: Array[EnemySpawn]
@export var wave = 1
@export var spawn_delay := 0.5

var active_enemies := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(spawn_delay).timeout
	spawn_loop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func spawn_loop() -> void:
	while true:
		var guaranteed_spawns: Array[EnemySpawn] = []
		var possible_spawns: Array[EnemySpawn] = []
		for enemy_spawn in enemy_spawns:
			if enemy_spawn.wave == wave:
				guaranteed_spawns.push_back(enemy_spawn)
			if enemy_spawn.wave < wave:
				possible_spawns.append(enemy_spawn)
		for i in wave:
			if guaranteed_spawns.size() > 0:
				spawn(guaranteed_spawns.pop_back())
			else:
				spawn(possible_spawns.pick_random())
			await get_tree().create_timer(spawn_delay).timeout
		while active_enemies != 0:
			await get_tree().create_timer(0.1).timeout
		wave += 1


func spawn(enemy_spawn: EnemySpawn) -> void:
	spawn_raw(enemy_spawn.scene, randi_range(enemy_spawn.min_pack, enemy_spawn.max_pack))


func spawn_raw(scene: PackedScene, number: int) -> void:
	var start := randf()
	for pos in range(number):
		$PathFollow2D.progress_ratio = start + float(pos) / number
		var enemy := scene.instantiate()
		$PathFollow2D.add_child(enemy)
		enemy.reparent(get_parent())
		enemy.tree_exited.connect(func(): active_enemies -= 1)
		active_enemies += 1
