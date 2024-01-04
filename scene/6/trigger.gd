extends MarginContainer


@onready var type = $HBox/Type
@onready var subtype = $HBox/Subtype
@onready var measure = $HBox/Measure
@onready var totem = $HBox/Totem

var skill = null
var index = null


func set_attributes(input_: Dictionary) -> void:
	skill = input_.skill
	index = input_.index
	
	init_basic_setting()


func init_basic_setting() -> void:
	var keys = ["type", "subtype", "measure", "totem"]
	var description = Global.dict.passive.index[index]
	
	
	for key in keys:
		var input = {}
		input.type = key
		input.subtype = description[key]
		
		var icon = get(key)
		icon.set_attributes(input)
		icon.custom_minimum_size = Global.vec.size.trigger
