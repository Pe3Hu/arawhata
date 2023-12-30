extends MarginContainer


@onready var bg = $BG
@onready var steps = $HBox/Steps
@onready var left = $HBox/Left
@onready var right = $HBox/Right
@onready var stairwell = $HBox/Stairwell
@onready var power = $HBox/Power

var ladder = null
var type = null
var route = null
var step = null
var direction = null


func set_attributes(input_: Dictionary) -> void:
	ladder = input_.ladder
	type = input_.type
	route = input_.route
	
	init_icons()
	roll_power()
	roll_step()
	roll_direction()


func init_icons() -> void:
	for _step in route:
		var input = {}
		input.type = "number"
		input.subtype = _step.index.get_number()
		
		var icon = Global.scene.icon.instantiate()
		steps.add_child(icon)
		icon.set_attributes(input)
		icon.bg.visible = true
		icon.custom_minimum_size = Vector2(Global.vec.size.sixteen)
		step = _step
		recolor("passive")
	
	step = null
	
	var input = {}
	input.type = "number"
	input.subtype = route.front().grid.y
	
	stairwell.set_attributes(input)
	stairwell.custom_minimum_size = Vector2(Global.vec.size.sixteen)
	stairwell.bg.visible = true
	var style = stairwell.bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.traveler[type]


func roll_power() -> void:
	var limits = {}
	limits.min = round(ladder.dimensions.y * 3.0 / 4.0)
	limits.max = round(ladder.dimensions.y * 5.0 / 4.0)
	var input = {}
	input.type = "number"
	Global.rng.randomize()
	input.subtype  = Global.rng.randi_range(limits.min, limits.max)
	
	power.set_attributes(input)
	power.custom_minimum_size = Vector2(Global.vec.size.sixteen)
	power.bg.visible = true
	var style = power.bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.traveler[type]


func roll_step() -> void:
	step = route.pick_random()
	take_step()


func roll_direction() -> void:
	var directions = ["left", "right"]
	
	for _direction in directions:
		var input = {}
		input.type = "triangle"
		input.subtype = _direction
		
		var icon = get(_direction)
		icon.set_attributes(input)
		icon.custom_minimum_size = Vector2(Global.vec.size.sixteen)
	
	var index = route.find(step)
	
	if index == 0:
		directions.erase("left")
	
	if index == route.size() - 1:
		directions.erase("right")
	
	direction = directions.pick_random()
	var icon = get(direction)
	icon.visible = true


func enroute() -> void:
	step_out()
	var index = route.find(step)
	
	match direction:
		"left":
			index -= 1
		"right":
			index += 1
	
	step = route[index]
	take_step()
	update_direction()


func update_direction() -> void:
	var index = route.find(step)
	
	if index == 0 and direction == "left":
		var icon = get(direction)
		icon.visible = false
		direction = "right"
		icon = get(direction)
		icon.visible = true
	
	if index == route.size() - 1 and direction == "right":
		var icon = get(direction)
		icon.visible = false
		direction = "left"
		icon = get(direction)
		icon.visible = true


func recolor(status_: String) -> void:
	var index = route.find(step)
	var icon = steps.get_child(index)
	
	var style = icon.bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.route[status_]


func take_step() -> void:
	step.obstacle = self
	recolor("active")
	
	var side = Global.dict.traveler.doorway[type]
	var doorway = step.get(side)
	doorway.visible = true
	var style = doorway.bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.traveler[type]


func step_out() -> void:
	step.obstacle = null
	recolor("passive")
	
	var side = Global.dict.traveler.doorway[type]
	var doorway = step.get(side)
	doorway.visible = false
