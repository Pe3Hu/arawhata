extends MarginContainer


@onready var bg = $BG
@onready var index = $HBox/Index
@onready var difficulty = $HBox/Difficulty
@onready var entry = $HBox/Entry
@onready var exit = $HBox/Exit

var ladder = null
var steps = null
var direction = null
var measure = null
var type = null
var part = null


func set_attributes(input_: Dictionary) -> void:
	ladder = input_.ladder
	steps = input_.steps
	direction = input_.direction
	measure = input_.measure
	part = "obstacle"
	
	if measure == "stairwell":
		type = input_.type
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.aisle
	index.set_attributes(input)
	index.custom_minimum_size = Global.vec.size.sixteen
	Global.num.index.aisle += 1
	var style = index.bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.doorway.entry
	index.bg.visible = true
	
	input.subtype = 1
	difficulty.set_attributes(input)
	difficulty.custom_minimum_size = Global.vec.size.sixteen
	style = difficulty.bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.difficulty
	difficulty.bg.visible = true
	
	for _i in steps.size():
		var step = steps[_i]
		var _type = null
		
		match _i:
			0:
				_type = "entry"
			1:
				_type = "exit"
		
		set_doorway(step, _type)
	
	match measure:
		"step":
			steps.front().neighbors.next = steps.back()
			steps.back().neighbors.prior = steps.front()
		"stairwell":
			roll_difficulty()


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
	
	var side = Global.dict.aisle.side[direction][type_]
	step_.add_aisle(self, side, type_)


func roll_difficulty() -> void:
	var base = 2
	
	if Global.dict.obstacle.role[type] == "aggressor":
		base -= 1
	
	var modifiers = {}
	modifiers[0] = 9
	modifiers[1] = 4
	modifiers[2] = 1
	var modifier = Global.get_random_key(modifiers)
	var value = base + modifier
	difficulty.set_number(value)


func apply_impact(member_: MarginContainer) -> void:
	var end = ladder.steps.get_child(exit.get_number())
	end.add_member(member_)
