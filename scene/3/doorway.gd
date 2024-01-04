extends MarginContainer


@onready var bg = $BG
@onready var index = $Index
@onready var difficulty = $Difficulty

var step = null
var aisle = null
var traveler  = null
var stash = null
var type = null


func set_attributes(input_: Dictionary) -> void:
	step = input_.step
	
	init_basic_setting()


func init_basic_setting() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color.SLATE_GRAY
	bg.set("theme_override_styles/panel", style)
	
	var keys = ["index", "difficulty"]
	
	for key in keys:
		var input = {}
		input.type = "number"
		input.subtype = 0
		var icon = get(key)
		icon.set_attributes(input)
		icon.custom_minimum_size = Global.vec.size.sixteen
	
	difficulty.visible = false


func set_aisle(aisle_: MarginContainer, type_: String) -> void:
	aisle = aisle_
	type = type_
	
	index.set_number(aisle_.index.get_number())
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.doorway[type]
	visible = true
	
	if type == "entry" and aisle.measure == "stairwell":
		step.obstacle = aisle
	
	difficulty.set_number(aisle_.difficulty.get_number())
	difficulty.visible = true
	index.visible = false


func set_stash(stash_: MarginContainer) -> void:
	type = "stash"
	stash = stash_
	
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.doorway[type]
	visible = true
	step.obstacle = stash
	
	difficulty.set_number(stash_.difficulty.get_number())
	difficulty.visible = true
	index.visible = false


func traveler_came(traveler_: MarginContainer) -> void:
	traveler = traveler_
	visible = true
	
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.traveler[traveler.type]
	
	difficulty.set_number(traveler_.difficulty.get_number())
	difficulty.visible = true
	index.visible = false


func traveler_gone() -> void:
	traveler = null
	visible = false
	
	difficulty.set_number(0)
	difficulty.visible = false

