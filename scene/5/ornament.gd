extends MarginContainer


@onready var order = $VBox/Order
@onready var aspects = $VBox/Aspects

var proprietor = null
var tattoo = null
var vendor = null
var ranks = null
var amount = null


func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	vendor = input_.vendor
	ranks = input_.ranks
	amount = input_.amount
	
	init_order(input_.order)
	init_aspects()


func init_order(order_: int) -> void:
	var input = {}
	input.type = "ornament"
	input.subtype = str(order_)
	order.set_attributes(input)
	order.custom_minimum_size = Vector2(Global.vec.size.tattoo)
	
	var style = StyleBoxFlat.new()
	#style.bg_color = Global.color.root.level
	order.bg.set("theme_override_styles/panel", style)


func init_aspects() -> void:
	var index = int(order.get_number())
	var roots = Global.dict.ornament.order[index]
	var branchs = Global.dict.vendor.index[vendor]
	
	for _i in amount:
		var input = {}
		input.proprietor = self
		input.root = Global.get_random_key(roots)
		var type = Global.get_random_key(Global.dict.vendor.rarity)
		input.branch = branchs[type]
		var description = Global.roll_perk_description(ranks)
		input.rank = description.rank
		input.grade = description.grade
		input.value = Global.dict.perk.branch[input.branch][input.rank][input.grade]
		
		var aspect = Global.scene.aspect.instantiate()
		aspects.add_child(aspect)
		aspect.set_attributes(input)


func set_as_part_of_tattoo(tattoo_: MarginContainer) -> void:
	tattoo = tattoo_
	proprietor = tattoo.member
	apply_aspects()


func apply_aspects() -> void:
	for aspect in aspects.get_children():
		var _aspect = tattoo.member.rundown.get_aspect_based_on_root_and_branch(aspect.root, aspect.branch)
		_aspect.stack.change_number(aspect.stack.get_number())
		
		if aspect.branch == "volume":
			tattoo.member.indicators.update_indicator(aspect.root)
