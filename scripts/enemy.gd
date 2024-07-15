extends CharacterBody2D

@export var speed := 10.0
@export var drag := 10.0

@export var mass := 1.0

@export var separation_distance := 100.0
@export var separation_strength := 1.0

@export var player_knockback := 300.0

@export var health := 3

var target: Node2D

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")

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
	$AnimationPlayer.play("hit")
	health -= 1
	if health <= 0:
		queue_free()


func _on_damage_source_body_entered(body: Node2D) -> void:
	if body == target:
		target.hit(self)
		var knockback = global_position.direction_to(target.global_position) * player_knockback
		target.velocity += knockback / target.mass
		velocity -= knockback / mass
