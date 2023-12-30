extends MarginContainer


@onready var bars = $VBox/Bars
@onready var strength = $VBox/Bars/Strength
@onready var dexterity = $VBox/Bars/Dexterity
@onready var intellect = $VBox/Bars/Intellect
@onready var will = $VBox/Bars/Will

var member = null


func set_attributes(input_: Dictionary) -> void:
	member = input_.member
	
	init_indicators()


func init_indicators() -> void:
	var input = {}
	input.indicators = self
	
	for root in Global.arr.root:
		var indicator = get(root)
		input.type = root
		var aspect = member.rundown.get_aspect_based_on_root_and_branch(root, "volume")
		input.max = aspect.stack.get_number()
		indicator.set_attributes(input)


func get_indicator(type_: String) -> Variant:
	for indicator in bars.get_children():
		if indicator.name.to_lower() == type_:
			return indicator
	
	return null

