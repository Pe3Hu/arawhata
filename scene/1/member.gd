extends MarginContainer


@onready var rundown = $HBox/Rundown

var guild = null


func set_attributes(input_: Dictionary) -> void:
	guild = input_.guild
	
	var input = {}
	input.member = self
	rundown.set_attributes(input)
