extends Bullet

@export var spread := PI/3
@export var number := 3

var self_scene: PackedScene = load("res://scenes/multishot_bullet.tscn")

func fire(child=false):
	if not child:
		var initial_rotation = rotation
		rotation -= (spread - spread / number) / 2
		for _i in number - 1:
			var rotation_ := angle_difference(initial_rotation, rotation)
			var new_bullet = self_scene.instantiate()
			add_child(new_bullet)
			new_bullet.reparent(get_parent())
			new_bullet.fire(true)
			rotation += spread / number
	super.fire()
