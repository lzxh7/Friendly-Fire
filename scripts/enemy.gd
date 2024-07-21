extends CharacterBody2D

@export var speed := 10.0
@export var drag := 10.0

@export var mass := 1.0

@export var separation_distance := 100.0
@export var separation_strength := 1.0

@export var player_knockback := 300.0

@export var health := 3
@export var score_value := 100

@export var health_drop_chance := 0.1

var target: Node2D

var health_pack := preload("res://scenes/health_pack.tscn")

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")
	while move_and_collide(Vector2.ZERO, true):
		position -= global_position.direction_to(target.global_position) * 10

func _process(delta: float) -> void:

	var direction := global_position.direction_to(target.global_position)
	
	velocity = velocity * exp(-drag * delta)
	var acceleration := speed * drag * direction
	
	for enemy: Node2D in get_tree().get_nodes_in_group("enemies"):
		var distance := global_position.distance_to(enemy.global_position)
		if distance < separation_distance:
			acceleration -= (
					global_position.direction_to(enemy.global_position)
					* (separation_distance - distance)
					* separation_strength
			)
	
	velocity += acceleration * delta

	move_and_slide()


func hit(_source=null) -> void:
	if not can_be_hit():
		return
	$AnimationPlayer.play("hit")
	health -= 1
	if health <= 0:
		$Death.play()
		$Death.reparent(get_parent())
		var main = get_tree().get_first_node_in_group("main")
		if main:
			main.add_score(score_value)
		$AnimationPlayer.play("death")


func _on_damage_source_body_entered(body: Node2D) -> void:
	if body == target:
		target.hit(self)
		var knockback = global_position.direction_to(target.global_position) * player_knockback
		target.velocity += knockback / target.mass
		velocity -= knockback / mass


func can_be_hit() -> bool:
	return not $AnimationPlayer.is_playing()


func drop_health() -> void:
	if randf() < health_drop_chance:
		var health = health_pack.instantiate()
		add_child(health)
		health.reparent(get_parent())
