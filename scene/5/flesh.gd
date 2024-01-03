extends MarginContainer


@onready var essences = $Essences

var member = null
var kinds = []


func set_attributes(input_: Dictionary) -> void:
	member = input_.member
	kinds.append_array(Global.arr.essence)
	
	roll_basic_essences()


func add_essence(essence_: MarginContainer) -> void:
	if kinds.has(essence_.order.subkind):
		kinds.erase(essence_.order.subkind)
		essences.add_child(essence_)
		essence_.set_flesh(self)


func roll_basic_essences() -> void:
	var totem = Global.arr.totem.pick_random()
	
	for kind in Global.arr.essence:
		var input = {}
		input.proprietor = member
		input.kind = kind
		input.totem = totem
		
		if !Global.dict.essence.totem[kind].has(totem):
			input.totem = Global.dict.essence.totem[kind].pick_random()
		
		input.amount = 1
		input.ranks = ["F"]
	
		var essence = Global.scene.essence.instantiate()
		essences.add_child(essence)
		essence.set_attributes(input)
		essence.set_as_part_of_flesh(self)
