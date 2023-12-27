extends MarginContainer


@onready var bg = $BG
@onready var index = $Index
@onready var up = $Up
@onready var right = $Right
@onready var down = $Down
@onready var left = $Left

var ladder = null
var grid = null
var type = null
var aisles = {}


func set_attributes(input_: Dictionary) -> void:
	ladder = input_.ladder
	grid = input_.grid
	type = input_.type
	
	init_basic_setting()


func init_basic_setting() -> void:
	custom_minimum_size = Global.vec.size.step
	var style = StyleBoxFlat.new()
	style.bg_color = Color.SLATE_GRAY
	bg.set("theme_override_styles/panel", style)
	
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.step
	index.set_attributes(input)
	index.custom_minimum_size = Global.vec.size.sixteen
	Global.num.index.step += 1
	
	set_doorways()


func set_doorways() -> void:
	for direction in Global.arr.direction:
		var doorway = get(direction)
		var input = {}
		input.step = self
		doorway.set_attributes(input)



func add_aisle(aisle_: MarginContainer, side_: String, type_: String) -> void:
	aisles[aisle_] = side_
	var doorway = get(side_)
	doorway.set_aisle(aisle_, type_)
