extends MarginContainer


@onready var steps = $VBox/HBox/Steps
@onready var aisles = $VBox/HBox/Aisles
@onready var stashes = $VBox/HBox/Stashes
@onready var travelers = $VBox/HBox/Travelers
@onready var squads = $VBox/HBox/Squads
@onready var queue = $VBox/HBox/Queue
@onready var encounter = $VBox/Encounter
@onready var podium = $VBox/Podium
@onready var timer = $Timer

var labyrinth = null
var dimensions = null
var iteration = 0
var active = true


func set_attributes(input_: Dictionary) -> void:
	labyrinth = input_.labyrinth
	dimensions = input_.dimensions
	
	init_steps()
	init_aisles()
	init_stashes()
	init_travelers()
	Engine.time_scale = 3


func init_steps() -> void:
	steps.columns = dimensions.x
	var start = Vector2(0, 0)
	var finish = dimensions - Vector2.ONE
	var corners = {}
	corners.x = [start.x, finish.x]
	corners.y = [start.y, finish.y]
	
	for _i in dimensions.y:
		for _j in dimensions.x:
			var input = {}
			input.ladder = self
			input.grid = Vector2(_j, _i)
			input.status = "path"
			input.border = false
			
			match input.grid:
				start:
					input.status = "start"
				finish:
					input.status = "finish"
			
			if corners.x.has(_j):
				input.border = true
			
			var step = Global.scene.step.instantiate()
			steps.add_child(step)
			step.set_attributes(input)


func init_aisles() -> void:
	var grid = Vector2.ZERO
	
	for _i in int(dimensions.y):
		var shift = Vector2(1, 0)
		var input = {}
		input.ladder = self
		input.measure = "step"
		input.direction = "left to right"
		
		if _i % 2 == 1:
			shift = Vector2(-1, 0)
			input.direction = "right to left"
		
		for _j in dimensions.x:
			if _i != dimensions.y - 1 or dimensions.x - 1 != _j:
				input.steps = []
				
				if _j == dimensions.x - 1:
					input.direction = "up to down"
					shift = Vector2(0, 1)
				
				var step = get_step(grid)
				input.steps.append(step)
				grid += shift
				step = get_step(grid)
				input.steps.append(step)
				
				var aisle = Global.scene.aisle.instantiate()
				aisles.add_child(aisle)
				aisle.set_attributes(input)
				aisle.visible = false
	
	init_portals()


func init_portals() -> void:
	var portals = {}
	portals["trap"] = 3
	portals["trail"] = 3
	var options = {}
	
	for portal in portals:
		options[portal] = []
	
	for step in steps.get_children():
		if step.status == "path": 
			for portal in portals:
				match portal:
					"trap":
						if step.grid.y - 2 >= 0 and !step.up.visible:
							var grid = step.grid + Vector2(0,-2)
							var exit = get_step(grid)
							
							if !exit.down.visible:
								options[portal].append(step)
					"trail":
						if step.grid.y + 2 < dimensions.y and !step.down.visible:
							var grid = step.grid + Vector2(0, 2)
							var exit = get_step(grid)
							
							if !exit.up.visible:
								options[portal].append(step)
	
	var shifts = {}
	shifts["trail"] = Vector2(0, 2)
	shifts["trap"] = Vector2(0,-2)
	var directions = {}
	directions["trail"] = "up to down"
	directions["trap"] = "down to up"
	
	while !portals.keys().is_empty():
		var portal = Global.get_random_key(portals)
		portals[portal] -= 1
		
		if portals[portal] == 0:
			portals.erase(portal)
		
		if !options[portal].is_empty():
			var shift = null
			var input = {}
			input.ladder = self
			input.measure = "stairwell"
			input.steps = []
			input.direction = directions[portal]
			input.type = portal
			
			var step = options[portal].pick_random()
			input.steps.append(step)
			var grid = step.grid + shifts[portal]
			step = get_step(grid)
			input.steps.append(step)
			
			var aisle = Global.scene.aisle.instantiate()
			aisles.add_child(aisle)
			aisle.set_attributes(input)
			
			for _portal in options:
				for _step in input.steps:
					options[_portal].erase(_step)
				
				var _step = null
				
				if _portal == portal:
					_step = input.steps[1]
				else:
					_step = input.steps[0]
				
				grid = _step.grid + shifts[_portal]
				step = get_step(grid)
				
				if step != null:
					#var pair = Global.dict.aisle.pair[portal]
					options[_portal].erase(step)


func init_stashes() -> void:
	var options = []
	
	for step in steps.get_children():
		if step.status == "path" and step.border: 
			options.append(step)
	
	var n = 5
	
	for _i in n:
		var step = options.pick_random()
		options.erase(step)
		
		var input = {}
		input.ladder = self
		input.step = step
		
		var stash = Global.scene.stash.instantiate()
		stashes.add_child(stash)
		stash.set_attributes(input)


func init_travelers() -> void:
	var routes = {}
	routes["down to up"] = []
	routes["up to down"] = []
	
	for direction in routes:
		var words = direction.split(" ")
		var side = words[2]
		var grid = Vector2(1, 0)
		var step = get_step(grid)
		var route = [step]
		
		while step.status != "finish":
			step = step.neighbors.next
			
			if !step.get(side).visible:
				route.append(step)
			else:
				if route.size() > 2:
					routes[direction].append(route)
				
				route = []
		
		route.pop_back()
		
		if route.size() > 2:
			routes[direction].append(route)
		
		match direction:
			"down to up":
				route = routes[direction].front()
				
				while route.front().grid.y == 0:
					routes[direction].pop_front()
					route = routes[direction].front()
			"up to down":
				route = routes[direction].back()
				
				while route.front().grid.y == dimensions.y - 1:
					routes[direction].pop_back()
					route = routes[direction].back()
	
	var stairwells = {}
	var types = {}
	
	for type in Global.arr.traveler:
		types[type] = []
	
	for _i in dimensions.y:
		stairwells[_i] = {}
	
	for direction in routes:
		for route in routes[direction]:
			var stairwell = route.front().grid.y
			stairwells[stairwell][direction] = route
	
	for stairwell in stairwells:
		if stairwells[stairwell].keys().size() == 1:
			var direction = stairwells[stairwell].keys().front()
			
			for obstacle in Global.dict.obstacle.direction:
				if Global.dict.obstacle.direction[obstacle] == direction and types.has(obstacle):
					var route = stairwells[stairwell][direction]
					types[obstacle].append(route)
	
	for stairwell in stairwells:
		if stairwells[stairwell].keys().size() == 2:
			var direction = stairwells[stairwell].keys().pick_random()
			
			if types.guardian.size() > types.sage.size():
				direction = "up to down"
				
			if types.guardian.size() < types.sage.size():
				direction = "down to up"
			
			for obstacle in Global.dict.obstacle.direction:
				if Global.dict.obstacle.direction[obstacle] == direction and types.has(obstacle):
					var route = stairwells[stairwell][direction]
					types[obstacle].append(route)
	
	var colors = {}
	colors["guardian"] = "red"
	colors["sage"] = "blue"
	
	for type in types:
		for route in types[type]:
			var input = {}
			input.ladder = self
			input.type = type
			input.route = route
			
			var traveler = Global.scene.traveler.instantiate()
			travelers.add_child(traveler)
			traveler.set_attributes(input)


func check_grid(grid_: Vector2) -> bool:
	return grid_.x >= 0 and grid_.y >= 0 and dimensions.y > grid_.y and dimensions.x >  grid_.x


func get_step(grid_: Vector2) -> Variant:
	if check_grid(grid_):
		var index = grid_.y * dimensions.x + grid_.x
		return steps.get_child(index)
	
	return null


func next_iteration() -> void:
	timer.paused = true
	
	for traveler in travelers.get_children():
		traveler.enroute()
	
	queue.rest()
	timer.paused = false 


func _on_timer_timeout():
	if active:
		queue.activation()
	else:
		timer.paused = true
		awarding()


func add_squad(squad_: MarginContainer) -> void:
	squad_.ladder = self
	squads.add_child(squad_)


func commence() -> void:
	var input = {}
	input.ladder = self
	queue.set_attributes(input)
	encounter.set_attributes(input)
	timer.start()


func get_end_of_advancement(start_: MarginContainer, distance_: int) -> MarginContainer:
	var end = start_
	var key = null
	
	match sign(distance_):
		1:
			key = "next"
		-1:
			key = "prior"
	
	for _i in abs(distance_):
		if end.neighbors[key] != null:
			end = end.neighbors[key]
		else:
			break
	
	return end


func awarding() -> void:
	var members = []
	
	for squad in squads.get_children():
		for member in squad.members.get_children():
			members.append(member)
	
	members.sort_custom(func(a, b): return a.step.index.get_number() > b.step.index.get_number())
	
	var input = {}
	input.ladder = self
	input.winners = []
	
	for _i in 3:
		input.winners.append(members[_i])
	
	podium.set_attributes(input)
