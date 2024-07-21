extends HSlider

@export var bus: StringName
@export_multiline var text: String
@export_node_path("Label") var label: NodePath

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _value_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), linear_to_db(float(value) / max_value))
	get_node(label).text = text % value
