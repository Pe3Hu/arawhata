extends MarginContainer


@onready var members = $Members

var ladder = null


func set_attributes(input_: Dictionary) -> void:
	ladder = input_.ladder
	
	fill_members()


func fill_members() -> void:
	var options = []
	
	for squad in ladder.squads.get_children():
		options.append_array(squad.members.get_children())
	
	options.shuffle()
	
	for member in options:
		var input = {}
		input.type = "number"
		input.subtype = member.index.get_number()
		
		var icon = Global.scene.icon.instantiate()
		members.add_child(icon)
		icon.set_attributes(input)
		icon.custom_minimum_size = Vector2(Global.vec.size.sixteen)
		icon.proprietor = member
		member.order = icon


func full_activation() -> void:
	var n = members.get_child_count()
	
	for _i in n:
		activation()


func activation() -> void:
	var member = members.get_child(0).proprietor
	member.advancement()
	members.remove_child(member.order)
	members.add_child(member.order)
