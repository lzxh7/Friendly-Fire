extends Label

@export_multiline var label_text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var main := get_tree().get_first_node_in_group("main")
	if main:
		text = label_text % [main.score]
