extends MarginContainer


@onready var members = $Members

var cradle = null


func set_attributes(input_: Dictionary) -> void:
	cradle = input_.cradle
	
	init_members()


func init_members() -> void:
	for _i in 3:
		var input = {}
		input.guild = self
	
		var member = Global.scene.member.instantiate()
		members.add_child(member)
		member.set_attributes(input)


func choose_ladder() -> void:
	var ladder = cradle.sketch.labyrinth.ladders.get_child(0)
	var input = {}
	input.guild = self
	input.members = get_members_for_squad()
	
	var squad = Global.scene.squad.instantiate()
	ladder.add_squad(squad)
	squad.set_attributes(input)


func get_members_for_squad() -> Array:
	var n = 3
	n = min(n, members.get_child_count())
	
	var _members = []
	
	for _i in n:
		var member = members.get_child(0)
		members.remove_child(member)
		_members.append(member)
	
	return _members
