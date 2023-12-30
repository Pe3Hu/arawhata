extends MarginContainer


@onready var members = $HBox/Members

var guild = null
var ladder = null


func set_attributes(input_: Dictionary) -> void:
	guild = input_.guild
	
	for member in input_.members:
		members.add_child(member)
		member.squad = self
