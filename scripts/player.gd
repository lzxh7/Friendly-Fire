extends CharacterBody2D

@export var speed := 10.0
@export var drag := 10.0
@export var max_angular_speed := 12

var mouse_last := false

func _process(delta: float) -> void:

	# Movement
	var direction := Input.get_vector('move_left', 'move_right', 'move_up', 'move_down')

	velocity = velocity * exp(-drag * delta)
	var acceleration := speed * drag
	velocity += acceleration * delta * direction

	# Aiming
	var target_rotation := rotation
	var input_direction := Input.get_vector('look_left', 'look_right', 'look_up', 'look_down')
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


	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and event.relative != Vector2.ZERO:
		mouse_last = true