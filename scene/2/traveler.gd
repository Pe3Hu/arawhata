extends MarginContainer


@onready var bg = $BG

var ladder = null


func set_attributes(input_: Dictionary) -> void:
	ladder = input_.ladder
