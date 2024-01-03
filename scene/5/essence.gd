extends MarginContainer


@onready var kind = $HBox/Kind
@onready var aspects = $HBox/Aspects

var proprietor = null
var flesh = null
var totem = null
var ranks = null
var amount = null


func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	totem = input_.totem
	ranks = input_.ranks
	amount = input_.amount
	
	init_kind(input_.kind)
	init_aspects()


func init_kind(kind_: String) -> void:
	var input = {}
	input.type = "essence"
	input.subtype = kind_
	kind.set_attributes(input)
	kind.custom_minimum_size = Vector2(Global.vec.size.essence)


func init_aspects() -> void:
	var roots = Global.arr.root
	var branch = Global.dict.essence.branch[kind.subtype]
	
	for _i in amount:
		var input = {}
		input.proprietor = self
		input.root = roots.pick_random()
		input.branch = branch
		var description = Global.roll_perk_description(ranks)
		input.rank = description.rank
		input.grade = description.grade
		input.value = Global.dict.perk.branch[input.branch][input.rank][input.grade]
		
		var aspect = Global.scene.aspect.instantiate()
		aspects.add_child(aspect)
		aspect.set_attributes(input)


func set_as_part_of_flesh(flesh_: MarginContainer) -> void:
	flesh = flesh_
	proprietor = flesh.member
	apply_aspects()


func apply_aspects() -> void:
	for aspect in aspects.get_children():
		var _aspect = flesh.member.rundown.get_aspect_based_on_root_and_branch(aspect.root, aspect.branch)
		_aspect.stack.change_number(aspect.stack.get_number())
		
		if aspect.branch == "volume":
			flesh.member.indicators.update_indicator(aspect.root)
