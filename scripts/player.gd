extends CharacterBody2D

signal game_over


@export var invulnerable := false
@export var bullet_scene: PackedScene
@export var max_health := 10
var health: int

@export var mass := 1.0

@export_category("Movement")
@export var speed := 10.0
@export var drag := 10.0
@export var max_angular_speed := 24.0

var mouse_last := false

func _ready() -> void:
	health = max_health

func _process(delta: float) -> void:	
	# Movement
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	velocity = velocity * exp(-drag * delta)
	var acceleration := speed * drag
	velocity += acceleration * delta * direction

	# Aiming
	var target_rotation := rotation
	var input_direction := Input.get_vector("look_left", "look_right", "look_up", "look_down")
	if input_direction != Vector2.ZERO:
		target_rotation = input_direction.angle()
		mouse_last = false
	if mouse_last:
		target_rotation = global_position.direction_to(get_viewport().get_mouse_position()).angle()

	var difference := angle_difference(rotation, target_rotation)
	if abs(difference) / delta > max_angular_speed:
		rotation += sign(difference) * max_angular_speed * delta
	else:
		rotation = target_rotation

	# Shooting
	if Input.is_action_just_released("fire"):
		$Timer.stop()
	if Input.is_action_just_pressed("fire"):
		fire_bullet()
		$Timer.start()

	move_and_slide()
	invulnerable = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and event.relative != Vector2.ZERO:
		mouse_last = true


func fire_bullet() -> void:
	var bullet := bullet_scene.instantiate()
	add_child(bullet)
	bullet.reparent(get_parent())
	bullet.fire()


func hit(_source=null) -> void:
	if invulnerable:
		return
	$AnimationPlayer.play("hit")
	health -= 1
	invulnerable = true
	if health <= 0:
		hide()
		process_mode = Node.PROCESS_MODE_DISABLED
		game_over.emit()
