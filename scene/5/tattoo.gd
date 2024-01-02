extends MarginContainer


@onready var ornaments = $VBox/Ornaments
@onready var icons = $VBox/Icons

var member = null
var orders = []


func set_attributes(input_: Dictionary) -> void:
	member = input_.member
	orders.append_array(Global.dict.ornament.order.keys())
	icons.custom_minimum_size = Vector2(Global.vec.size.tattoo)
	
	roll_basic_ornaments()


func add_ornament(ornament_: MarginContainer) -> void:
	if orders.has(ornament_.order.subtype):
		orders.erase(ornament_.order.subtype)
		ornaments.add_child(ornament_)
		ornament_.set_tattoo(self)
		add_icon(ornament_.order.subtype)


func add_icon(order_: int) -> void:
	var input = {}
	input.type = "ornament"
	input.subtype = order_
	var icon = Global.scene.icon.instantiate()
	icons.add_child(icon)
	icon.set_attributes(input)
	icon.custom_minimum_size = Vector2(Global.vec.size.particle)


func roll_basic_ornaments() -> void:
	for _i in 9:
		var input = {}
		input.proprietor = member
		input.vendor = Global.dict.vendor.index.keys().pick_random()
		input.order = _i#Global.dict.ornament.order.keys().pick_random()
		input.amount = 1
		input.ranks = ["F"]
	
		var ornament = Global.scene.ornament.instantiate()
		ornaments.add_child(ornament)
		ornament.set_attributes(input)
		ornament.set_as_part_of_tattoo(self)
