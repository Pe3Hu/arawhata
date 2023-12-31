extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.edge = [1, 2, 3, 4, 5, 6]
	arr.direction = ["up", "right", "down", "left"]
	arr.traveler = ["sage", "guardian"]
	arr.portal = ["trail", "trap"]
	arr.root = ["strength", "dexterity", "intellect", "will"]
	arr.branch = ["volume", "replenishment", "endeavor", "tension", "resistance"]
	arr.scheme = ["module", "connector"]
	arr.side = ["left", "right"]
	arr.initiative = ["aggressor", "defender"]


func init_num() -> void:
	num.index = {}
	num.index.step = 0
	num.index.aisle = 0
	num.index.stash = 0
	num.index.member = 0
	
	num.aspect = {}
	num.aspect.min = 0
	num.aspect.max = 400
	
	num.step = {}
	num.step.limit = 4


func init_dict() -> void:
	init_neighbor()
	init_labyrinth()
	init_aspect()


func init_labyrinth() -> void:
	dict.aisle = {}
	dict.aisle.side = {}
	dict.aisle.side["left to right"] = {}
	dict.aisle.side["left to right"]["entry"] = "right"
	dict.aisle.side["left to right"]["exit"] = "left"
	dict.aisle.side["right to left"] = {}
	dict.aisle.side["right to left"]["entry"] = "left"
	dict.aisle.side["right to left"]["exit"] = "right"
	dict.aisle.side["down to up"] = {}
	dict.aisle.side["down to up"]["entry"] = "up"
	dict.aisle.side["down to up"]["exit"] = "down"
	dict.aisle.side["up to down"] = {}
	dict.aisle.side["up to down"]["entry"] = "down"
	dict.aisle.side["up to down"]["exit"] = "up"
	
	dict.aisle.pair = {}
	dict.aisle.pair["entry"] = "exit"
	dict.aisle.pair["exit"] = "entry"
	
	dict.obstacle = {}
	dict.obstacle.direction = {}
	dict.obstacle.direction["sage"] = "up to down"
	dict.obstacle.direction["trail"] = "up to down"
	dict.obstacle.direction["guardian"] = "down to up"
	dict.obstacle.direction["trap"] = "down to up"
	
	dict.traveler = {}
	dict.traveler.doorway = {}
	dict.traveler.doorway["guardian"] = "up"
	dict.traveler.doorway["sage"] = "down"
	
	dict.obstacle.initiative = {}
	dict.obstacle.initiative["sage"] = "defender"
	dict.obstacle.initiative["trail"] = "defender"
	dict.obstacle.initiative["stash"] = "defender"
	dict.obstacle.initiative["guardian"] = "aggressor"
	dict.obstacle.initiative["trap"] = "aggressor"


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]


func init_aspect() -> void:
	dict.aspect = {}
	dict.aspect.title = {}
	
	dict.branch = {}
	dict.branch.root = {}
	dict.root = {}
	dict.root.branch = {}
	
	var path = "res://asset/json/arawhata_aspect.json"
	var array = load_data(path)
	
	for aspect in array:
		var data = {}
		
		for key in aspect:
			if key != "title" and !arr.root.has(key):
				data[key] = aspect[key]
		
		
		if !dict.branch.root.has(aspect.title):
			dict.branch.root[aspect.title] = {}
		
		for root in arr.root:
			if !dict.root.branch.has(root):
				dict.root.branch[root] = {}
			
			dict.root.branch[root][aspect.title] = aspect[root]
			dict.branch.root[aspect.title][root] = aspect[root]
			dict.aspect.title[aspect[root]] = {}
			
			for key in data:
				dict.aspect.title[aspect[root]][key] = data[key]
			
			dict.aspect.title[aspect[root]].branch = aspect.title
			dict.aspect.title[aspect[root]].root = root
			num.aspect.min += dict.aspect.title[aspect[root]].min


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.icon = load("res://scene/0/icon.tscn")
	
	scene.guild = load("res://scene/1/guild.tscn")
	scene.member = load("res://scene/1/member.tscn")
	scene.squad = load("res://scene/1/squad.tscn")
	
	scene.aspect = load("res://scene/2/aspect.tscn")
	
	scene.ladder = load("res://scene/3/ladder.tscn")
	scene.step = load("res://scene/3/step.tscn")
	scene.aisle = load("res://scene/3/aisle.tscn")
	scene.stash = load("res://scene/3/stash.tscn")
	scene.traveler = load("res://scene/3/traveler.tscn")


func init_vec():
	vec.size = {}
	vec.size.letter = Vector2(20, 20)
	vec.size.icon = Vector2(48, 48)
	vec.size.number = Vector2(5, 32)
	vec.size.sixteen = Vector2(16, 16)
	
	vec.size.aspect = Vector2(32, 32)
	vec.size.box = Vector2(100, 100)
	vec.size.bar = Vector2(16, 164)
	
	vec.size.step = Vector2(80, 80)
	vec.size.scheme = Vector2(900, 700)
	vec.size.encounter = Vector2(128, 200)
	#vec.size.part = Vector2(16, 16)
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.doorway = {}
	color.doorway.entry = Color.from_hsv(60 / h, 0.6, 0.7)
	color.doorway.exit = Color.from_hsv(270 / h, 0.6, 0.7)
	color.doorway.stash = Color.from_hsv(120 / h, 0.6, 0.7)
	#color.step.aisle = Color.from_hsv(60 / h, 0.6, 0.7)
	
	color.route = {}
	color.route.active = Color.from_hsv(330 / h, 0.6, 0.7)
	color.route.passive = Color.from_hsv(30 / h, 0.6, 0.7)
	
	color.traveler = {}
	color.traveler.guardian = Color.from_hsv(0 / h, 0.6, 0.7)
	color.traveler.sage = Color.from_hsv(210 / h, 0.6, 0.7)
	
	color.indicator = {}
	color.indicator.strength = {}
	color.indicator.strength.fill = Color.from_hsv(0, 0.9, 0.7)
	color.indicator.strength.background = Color.from_hsv(0, 0.5, 0.9)
	color.indicator.dexterity = {}
	color.indicator.dexterity.fill = Color.from_hsv(120 / h, 0.9, 0.7)
	color.indicator.dexterity.background = Color.from_hsv(120 / h, 0.5, 0.9)
	color.indicator.intellect = {}
	color.indicator.intellect.fill = Color.from_hsv(210 / h, 0.9, 0.7)
	color.indicator.intellect.background = Color.from_hsv(210 / h, 0.5, 0.9)
	color.indicator.will = {}
	color.indicator.will.fill = Color.from_hsv(60 / h, 0.9, 0.7)
	color.indicator.will.background = Color.from_hsv(60 / h, 0.5, 0.9)
	
	color.difficulty = Color.from_hsv(150 / h, 0.6, 0.7)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
