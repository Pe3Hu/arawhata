extends MarginContainer


@onready var members = $Members

var cradle = null


func set_attributes(input_: Dictionary) -> void:
	cradle = input_.cradle
	
	init_members()


func init_members() -> void:
	for _i in 1:
		var input = {}
		input.guild = self
	
		var member = Global.scene.member.instantiate()
		members.add_child(member)
		member.set_attributes(input)
