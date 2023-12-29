extends MarginContainer


@onready var ladders = $Ladders

var sketch = null


func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_ladders()


func init_ladders() -> void:
	for _i in 1:
		var input = {}
		input.labyrinth = self
		input.dimensions = Vector2(7, 9)
	
		var ladder = Global.scene.ladder.instantiate()
		ladders.add_child(ladder)
		ladder.set_attributes(input)
