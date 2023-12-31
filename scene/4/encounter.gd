extends MarginContainer


@onready var leftMarker = $Sides/Left/HBox/Marker
@onready var leftMax = $Sides/Left/HBox/Max
@onready var leftPool = $Sides/Left/Pool
@onready var leftWinner = $Sides/Left/Winner
@onready var rightMarker = $Sides/Right/HBox/Marker
@onready var rightMax = $Sides/Right/HBox/Max
@onready var rightPool = $Sides/Right/Pool
@onready var rightWinner = $Sides/Right/Winner
@onready var middleInitiation = $Sides/Middle/Initiation

var ladder = null
var left = null
var right = null
var winner = null
var loser = null
var results = []
var fixed = []
var hides = []
var kind = null


func set_attributes(input_: Dictionary) -> void:
	ladder = input_.ladder
	
	custom_minimum_size = Global.vec.size.encounter


func set_sides(aggressor_: MarginContainer, defender_: MarginContainer) -> void:
	left = aggressor_
	right = defender_


func roll_pool() -> void:
	for side in Global.arr.side:
		var pool = get(side+"Pool")
		
		if !fixed.has(side):
			var gladiator = get(side)
			var aspect = gladiator.get("strength")
			var input = {}
			input.type = "number"
			input.subtype = aspect.get_performance_value(gladiator.stamina.state, gladiator.stamina.effort) 
			
			var icon = get(side+"Max")
			icon.set_attributes(input)
		
			pool.init_dices(1, input.subtype)
			pool.roll_dices()

func end_of_encounter() -> void:
	reset()


func reset() -> void:
	winner = null
	loser = null
	results = []
	fixed = []
	leftPool.reset()
	rightPool.reset()
	middleInitiation.visible = false
