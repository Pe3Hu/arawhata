extends MarginContainer


@onready var index = $HBox/Index
@onready var rundown = $HBox/Rundown
@onready var indicators = $HBox/Indicators
@onready var tattoo = $HBox/Tattoo
@onready var flesh = $HBox/Flesh
@onready var dominion = $HBox/Dominion

var guild = null
var squad = null
var marker = null
var order = null
var step = null
var part = null
 

func set_attributes(input_: Dictionary) -> void:
	guild = input_.guild
	part = "member"
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.member = self
	rundown.set_attributes(input)
	indicators.set_attributes(input)
	tattoo.set_attributes(input)
	flesh.set_attributes(input)
	dominion.set_attributes(input)
	
	input.type = "number"
	input.subtype = Global.num.index.member
	index.set_attributes(input)
	index.custom_minimum_size = Global.vec.size.sixteen
	Global.num.index.member += 1


func advancement() -> void:
	var roots = {}
	#roots.occupancy = get_root_based_on_occupancy()
	#roots.tension = get_root_based_on_tension()
	#roots.result = {}
	
	for root in Global.arr.root:
		var indicator = indicators.get_indicator(root)
		var reserve = indicator.get_value("current")
		var aspect = rundown.get_aspect_based_on_root_and_branch(root, "tension")
		var base = aspect.get_base_of_quadratic_degree()
		
		if reserve >= base:
			roots[root] = round(indicator.get_percentage() * base)
	
	var root = Global.get_random_key(roots)
	var indicator = indicators.get_indicator(root)
	var aspect = rundown.get_aspect_based_on_root_and_branch(root, "tension")
	var base = aspect.get_base_of_quadratic_degree()
	
	Global.rng.randomize()
	var distance = Global.rng.randi_range(1, base)
	indicator.change_value("current", -base)
	
	if step == null:
		step = squad.ladder.steps.get_child(0)
		step.add_member(self)
		distance -= 1
	
	var end = squad.ladder.get_end_of_advancement(step, distance)
	end.add_member(self)


func get_root_based_on_occupancy() -> Array:
	var roots = []
	roots.append_array(Global.arr.root)
	roots.sort_custom(func(a, b): return indicators.get_indicator(a).get_percentage() < indicators.get_indicator(b).get_percentage())
	return roots


func get_root_based_on_tension() -> Array:
	var roots = []
	roots.append_array(Global.arr.root)
	roots.sort_custom(func(a, b): return rundown.get_aspect_based_on_root_and_branch(a, "tension").get_base_of_quadratic_degree() < rundown.get_aspect_based_on_root_and_branch(b, "tension").get_base_of_quadratic_degree())
	return roots


func rest() -> void:
	for root in Global.arr.root:
		energize(root)


func energize(root_: String) -> void:
	var indicator = indicators.get_indicator(root_)
	var aspect = rundown.get_aspect_based_on_root_and_branch(root_, "replenishment")
	var base = aspect.get_base_of_quadratic_degree()
	indicator.change_value("current", base)
