extends MarginContainer


@onready var skills = $Skills

var member = null


func set_attributes(input_: Dictionary) -> void:
	member = input_.member
	
	add_basic_skill()


func add_basic_skill() -> void:
	var totem = "hare"
	
	for title in Global.dict.active.title:
		var description = Global.dict.active.title[title]
		
		if description.has("priority") and description.totem == totem:
			add_skill(title)
			return


func add_skill(title_: String) -> void:
	var input = {}
	input.dominion = self
	input.title = title_
	
	var skill = Global.scene.skill.instantiate()
	skills.add_child(skill)
	skill.set_attributes(input)
