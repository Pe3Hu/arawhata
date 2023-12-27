extends MarginContainer


@onready var steps = $HBox/Steps
@onready var aisles = $HBox/Aisles

var labyrinth = null
var dimensions = null


func set_attributes(input_: Dictionary) -> void:
	labyrinth = input_.labyrinth
	dimensions = input_.dimensions
	
	init_steps()
	init_aisles()


func init_steps() -> void:
	var corners = {}
	corners.x = [0, dimensions.x - 1]
	corners.y = [0, dimensions.y - 1]
	
	steps.columns = dimensions.x
	
	for _i in dimensions.y:
		for _j in dimensions.x:
			var input = {}
			input.ladder = self
			input.grid = Vector2(_j, _i)
			
			if corners.x.has(_i) or corners.y.has(_j):
				if corners.x.has(_i) and corners.y.has(_j):
					input.type = "corner"
				else:
					input.type = "edge"
			else:
				input.type = "center"
			
			var step = Global.scene.step.instantiate()
			steps.add_child(step)
			step.set_attributes(input)


func init_aisles() -> void:
	var grid = Vector2.ZERO
	
	for _i in int(dimensions.y):
		var shift = Vector2(1, 0)
		var input = {}
		input.ladder = self
		input.type = "left to right"
		
		if _i % 2 == 1:
			shift = Vector2(-1, 0)
			input.type = "right to left"
		
		for _j in dimensions.x:
			if _i != dimensions.y - 1 or dimensions.x - 1 != _j:
				input.steps = []
				
				if _j == dimensions.x - 1:
					input.type = "up to down"
					shift = Vector2(0, 1)
				
				var step = get_step(grid)
				input.steps.append(step)
				grid += shift
				step = get_step(grid)
				input.steps.append(step)
				
				var aisle = Global.scene.aisle.instantiate()
				aisles.add_child(aisle)
				aisle.set_attributes(input)


func check_grid(grid_: Vector2) -> bool:
	return grid_.x >= 0 and grid_.y >= 0 and dimensions.y > grid_.y and dimensions.x >  grid_.x


func get_step(grid_: Vector2) -> Variant:
	if check_grid(grid_):
		var index = grid_.y * dimensions.x + grid_.x
		return steps.get_child(index)
	
	return null
