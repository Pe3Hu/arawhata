extends MarginContainer


@onready var cradle = $HBox/Cradle
@onready var labyrinth = $HBox/Labyrinth


func _ready() -> void:
	var input = {}
	input.sketch = self
	cradle.set_attributes(input)
	labyrinth.set_attributes(input)
