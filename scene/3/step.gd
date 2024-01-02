extends MarginContainer


@onready var bg = $BG
@onready var index = $Index
@onready var up = $Up
@onready var right = $Right
@onready var down = $Down
@onready var left = $Left
@onready var markers = $Markers

var ladder = null
var grid = null
var border = null
var status = null
var obstacle = null
var aisles = {}
var neighbors = {}


func set_attributes(input_: Dictionary) -> void:
	ladder = input_.ladder
	grid = input_.grid
	border = input_.border
	status = input_.status
	
	init_basic_setting()


func init_basic_setting() -> void:
	neighbors.next = null
	neighbors.prior = null
	custom_minimum_size = Global.vec.size.step
	var style = StyleBoxFlat.new()
	style.bg_color = Color.SLATE_GRAY
	
	if status != "path":
		style.bg_color = Color.GRAY
	
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


func set_stash(stash_: MarginContainer) -> void:
	var sides = ["left", "right"]
	
	for side in sides:
		var doorway = get(side)
		
		if doorway.visible:
			sides.erase(side)
			break
	
	var doorway = get(sides.front())
	doorway.set_stash(stash_)


func recolor(color_: String) -> void:
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Color(color_)


func rehue(hue_: float) -> void:
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Color.from_hsv(hue_, 1, 1)


func add_member(member_: MarginContainer) -> void:
	if Global.num.step.limit >= markers.get_child_count():
		if member_.marker == null:
			var input = {}
			input.type = "number"
			input.subtype = member_.index.get_number()
			
			member_.marker = Global.scene.icon.instantiate()
			markers.add_child(member_.marker)
			member_.marker.set_attributes(input)
			member_.marker.custom_minimum_size = Vector2(Global.vec.size.sixteen)
			member_.marker.bg.visible = true
		
		member_.step.markers.remove_child(member_.marker)
		markers.add_child(member_.marker)
		member_.step = self
		
		obstacle_impact(member_)
	else:
		neighbors.next.add_member(member_)


func obstacle_impact(member_: MarginContainer) -> void:
	if status == "finish":
		ladder.active = false
		return
	
	if obstacle != null:
		var roles = {}
		
		for role in Global.arr.role:
			if role == Global.dict.obstacle.role[obstacle.type]:
				roles[role] = obstacle
			else:
				roles[role] = member_
		
		ladder.encounter.set_roles(roles.aggressor, roles.defender)
