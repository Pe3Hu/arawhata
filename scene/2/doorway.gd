extends MarginContainer


@onready var bg = $BG
@onready var index = $Index


var step = null
var aisle = null
var type = null


func set_attributes(input_: Dictionary) -> void:
	step = input_.step
	
	init_basic_setting()


func init_basic_setting() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color.SLATE_GRAY
	bg.set("theme_override_styles/panel", style)
	
	var input = {}
	input.type = "number"
	input.subtype = 0
	index.set_attributes(input)
	index.custom_minimum_size = Global.vec.size.sixteen


func set_aisle(aisle_: MarginContainer, type_: String) -> void:
	aisle = aisle_
	type = type_
	
	index.set_number(aisle_.index.get_number())
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.doorway[type]
	visible = true
