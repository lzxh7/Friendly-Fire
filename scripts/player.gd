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
	var target_rotation = $Aimer.rotation
	var input_direction := Input.get_vector("look_left", "look_right", "look_up", "look_down")
	if input_direction != Vector2.ZERO:
		target_rotation = input_direction.angle()
		mouse_last = false
	if mouse_last:
		# undoes the rotation of get_local_mouse_position()
		var mouse_pos = global_transform.basis_xform(get_local_mouse_position())
		target_rotation = mouse_pos.angle()

	var difference := angle_difference($Aimer.rotation, target_rotation)
	if abs(difference) / delta > max_angular_speed:
		$Aimer.rotation += sign(difference) * max_angular_speed * delta
	else:
		$Aimer.rotation = target_rotation

	# Shooting
	if bullet_scene.get_state().get_node_name(0) == &"AutofireBullet":
		if $Timer.is_stopped():
			$Timer.start()
	elif Input.is_action_just_released("fire"):
		$Timer.stop()
	elif Input.is_action_just_pressed("fire"):
		fire_bullet()
		$Timer.start()

	move_and_slide()



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and event.relative != Vector2.ZERO:
		mouse_last = true


func fire_bullet() -> void:
	$Shoot.play()
	rotation = $Aimer.rotation
	var bullet := bullet_scene.instantiate()
	add_child(bullet)
	bullet.reparent(get_parent())
	bullet.fire()
	rotation = 0
	

func hit(source=null) -> void:
	# very gamejam hack if i try to add any constant animations this will break
	if not can_be_hit():
		return
	$AnimationPlayer.play("hit")
	if "damage" in source:
		health -= source.damage
	else:
		health -= 1
	$Hurt.play()
	if health <= 0:
		$Death.play()
		$Death.reparent(get_parent())
		hide()
		process_mode = Node.PROCESS_MODE_DISABLED
		game_over.emit()


func can_be_hit() -> bool:
	return not $AnimationPlayer.is_playing()


func heal(amount: int) -> void:
	health += amount
	if health > max_health:
		health = max_health
