extends MarginContainer


@onready var cradle = $HBox/Cradle
@onready var labyrinth = $HBox/Labyrinth


func _ready() -> void:
	var input = {}
	input.sketch = self
	cradle.set_attributes(input)
	labyrinth.set_attributes(input)
	
	for guild in cradle.guilds.get_children():
		guild.choose_ladder()
	
	labyrinth.ladders.get_child(0).commence()
