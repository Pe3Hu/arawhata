extends MarginContainer


@onready var triggers = $HBox/Triggers
@onready var authority = $HBox/Authority

var dominion = null
var title = null
var totem = null


func set_attributes(input_: Dictionary) -> void:
	dominion = input_.dominion
	title = input_.title
	
	init_triggers()
	init_indicator()


func init_triggers() -> void:
	var description = Global.dict.active.title[title]
	totem = description.totem
	
	for index in Global.dict.passive.index:
		description = Global.dict.passive.index[index]
		
		if totem == description.totem:
			var input = {}
			input.skill = self
			input.index = index
			
			var trigger = Global.scene.trigger.instantiate()
			triggers.add_child(trigger)
			trigger.set_attributes(input)


func init_indicator() -> void:
	var input = {}
	input.indicators = null
	input.root = "authority"
	input.max = 100
	authority.set_attributes(input)
