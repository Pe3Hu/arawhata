extends MarginContainer


@onready var bg = $BG
@onready var index = $HBox/Index
@onready var entry = $HBox/Entry
@onready var exit = $HBox/Exit

var ladder = null
var steps = null
var type = null


func set_attributes(input_: Dictionary) -> void:
	ladder = input_.ladder
	steps = input_.steps
	type = input_.type
	
	init_basic_setting()


func init_basic_setting() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color.SLATE_GRAY
	bg.set("theme_override_styles/panel", style)
	
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.aisle
	index.set_attributes(input)
	index.custom_minimum_size = Global.vec.size.sixteen
	Global.num.index.aisle += 1
	
	for _i in steps.size():
		var step = steps[_i]
		var _type = null
		
		match _i:
			0:
				_type = "entry"
			1:
				_type = "exit"
		
		set_doorway(step, _type)


func set_doorway(step_: MarginContainer, type_: String) -> void:
	var icon = get(type_)
	var input = {}
	input.type = "number"
	input.subtype = step_.index.get_number()
	icon.set_attributes(input)
	icon.custom_minimum_size = Global.vec.size.sixteen
	
	var style = StyleBoxFlat.new()
	style.bg_color = Global.color.doorway[type_]
	icon.bg.set("theme_override_styles/panel", style)
	#var style = icon.bg.get("theme_override_styles/panel")
	#style.bg_color = Global.color.doorway[type_]
	
	var side = Global.dict.aisle.side[type][type_]
	step_.add_aisle(self, side, type_)
	
