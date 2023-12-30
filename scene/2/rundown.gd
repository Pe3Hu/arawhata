extends MarginContainer


@onready var aspects = $Aspects

var member = null


func set_attributes(input_: Dictionary) -> void:
	member = input_.member
	
	init_aspects()


func init_aspects() -> void:
	for branch in Global.arr.branch:
		for root in Global.arr.root:
				var input = {}
				input.rundown = self
				input.root = root
				input.branch = branch
			
				var aspect = Global.scene.aspect.instantiate()
				aspects.add_child(aspect)
				aspect.set_attributes(input)
	
	spread_aspects()


func spread_aspects() -> void:
	var options = {}
	var total = Global.num.aspect.max - Global.num.aspect.min
	
	for branch in Global.arr.branch:
		for root in Global.arr.root:
			var aspect = get_aspect_based_on_root_and_branch(root, branch)
			var value = Global.dict.aspect.title[aspect.appellation].min
			aspect.stack.set_number(value)
			options[aspect.appellation] = Global.dict.aspect.title[aspect.appellation].rarity
	
	while total > 0 and !options.is_empty():
		var appellation = Global.get_random_key(options)
		var aspect = get_aspect_based_on_appellation(appellation)
		Global.rng.randomize()
		var random = Global.rng.randi_range(aspect.stack.get_number() + 1, Global.dict.aspect.title[aspect.appellation].max)
		var change = random - aspect.stack.get_number()
		
		if change > total:
			random -= change - total
			change = total
		
		aspect.stack.set_number(random)
		total -= change
		
		if aspect.stack.get_number() == Global.dict.aspect.title[aspect.appellation].max:
			options.erase(aspect.appellation)


func get_aspect_based_on_root_and_branch(root_: String, branch_: String) -> MarginContainer:
	var a = Global.arr.root.find(root_)
	var b = Global.arr.branch.find(branch_)
	var index = b * Global.arr.root.size() + a
	return aspects.get_child(index)


func get_aspect_based_on_appellation(appellation_: String) -> MarginContainer:
	var a = Global.arr.root.find(Global.dict.aspect.title[appellation_].root)
	var b = Global.arr.branch.find(Global.dict.aspect.title[appellation_].branch)
	var index = b * Global.arr.root.size() + a
	return aspects.get_child(index)
