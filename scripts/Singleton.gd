extends Spatial


var has_baton = false
var has_tried_race = false
var try_race = 0
var camera_turned_village = false

var volume_musique = -10
var volume_sons = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reinitialise():
	has_baton = false
	has_tried_race = false
	try_race = 0
	camera_turned_village = false
