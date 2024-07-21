class_name Bullet
extends CharacterBody2D

const MAX_BOUNCES := 12

@export var speed := 100.0
@export_flags_2d_physics var emitter_layer

@export var bullets_destroy_bullets := false
@export var damage := 1

@export var mass := 1.0


func _ready() -> void:
	$Area2D.collision_mask = emitter_layer

func _physics_process(delta: float) -> void:
	
	_move_and_bounce(velocity * delta)
	
	rotation = velocity.angle()


func _move_and_bounce(distance: Vector2, depth:=0) -> void:
	if depth > MAX_BOUNCES:
		return
	
	var collision = move_and_collide(distance)

	if collision:
		var collider := collision.get_collider()
		# to prevent the bullet from colliding with the emitter when first
		# shot we don't give it collision with the emitter until its first bounce.
		collision_mask |= emitter_layer
		
		if "velocity" in collider and "mass" in collider and not collider is Bullet:
			if collider.can_be_hit():
				collider.velocity += velocity * mass / collider.mass
		
		velocity = velocity.bounce(collision.get_normal())
		var remainder := collision.get_remainder()
		_move_and_bounce(remainder.bounce(collision.get_normal()), depth + 1)
		
		if collider.has_method("hit"):
			collider.hit(self)
		
		if collider is Bullet and bullets_destroy_bullets:
			queue_free()


func hit(_source=null):
	if bullets_destroy_bullets:
		queue_free()


func fire():
	velocity = speed * Vector2.RIGHT.rotated(rotation)
