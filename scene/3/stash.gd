extends MarginContainer


@onready var bg = $BG
@onready var index = $HBox/Index
@onready var difficulty = $HBox/Difficulty
@onready var reward = $HBox/Reward

var ladder = null
var type = null


func set_attributes(input_: Dictionary) -> void:
	ladder = input_.ladder
	
	init_basic_setting()


func init_basic_setting() -> void:
	type = "stash"
	
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.stash
	index.set_attributes(input)
	index.custom_minimum_size = Global.vec.size.sixteen
	Global.num.index.stash += 1
	
	var style = index.bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.doorway.stash
	index.bg.visible = true
	
	input.subtype = 1
	difficulty.set_attributes(input)
	difficulty.custom_minimum_size = Global.vec.size.sixteen
	
	input.subtype = 0
	reward.set_attributes(input)
	reward.custom_minimum_size = Global.vec.size.sixteen
	style = difficulty.bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.difficulty
	difficulty.bg.visible = true
	
	roll_difficulty()


func roll_difficulty() -> void:
	var base = 1
	var modifiers = {}
	modifiers[0] = 9
	modifiers[1] = 4
	modifiers[2] = 1
	var modifier = Global.get_random_key(modifiers)
	var value = base + modifier
	difficulty.set_number(value)
