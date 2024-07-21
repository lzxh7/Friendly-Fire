extends ScreenChangeButton

@export var bullet_scene: PackedScene


@onready var text_template = text

var best_score := 0:
	set(value):
		best_score = value
		text = text_template % best_score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	owner.screen_changed.connect(_on_ui_screen_changed)
	best_score = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _pressed() -> void:
	super._pressed()
	await get_tree().create_timer(0.05) # very hacky but i have to submit this in 30 minutes
	var main = get_tree().get_first_node_in_group("main")
	if main:
		main.set_bullet(bullet_scene)



func _on_ui_screen_changed(screen: StringName) -> void:
	if screen == &"GameOver":
		var player = get_tree().get_first_node_in_group("player")
		if player and player.bullet_scene == bullet_scene:
			var main = get_tree().get_first_node_in_group("main")
			if main and main.score > best_score:
				best_score = main.score
