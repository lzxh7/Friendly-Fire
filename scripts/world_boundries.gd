@tool
extends Marker2D

@onready var x_boundries := [$"../Walls/CollisionShape2D2", $"../Walls/CollisionShape2D3"]
@onready var y_boundries := [$"../Walls/CollisionShape2D", $"../Walls/CollisionShape2D4"]
@onready var camera := $"../Camera2D"

func _ready() -> void:
	set_notify_transform(true)


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		var x := absf(transform.origin.x)
		var y := absf(transform.origin.y)
		for boundry in x_boundries:
			boundry.shape.distance = -x
		for boundry in y_boundries:
			boundry.shape.distance = -y
		camera.limit_left = -x
		camera.limit_right = x
		camera.limit_bottom = y
		camera.limit_top = -y

