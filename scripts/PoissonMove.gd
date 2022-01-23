extends PathFollow


var moves = false
export var vitesse = 5.0
export var disappear = true
var has_accelerated = false
var has_accelerated_bis = false

# Called when the node enters the scene tree for the first time.
func _ready():
	offset = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if moves :
		offset += delta * vitesse
		if !has_accelerated && unit_offset >= 0.3 :
			has_accelerated = true
			vitesse += 0.8
		if !has_accelerated_bis && unit_offset >= 0.4 :
			has_accelerated_bis = true
			vitesse += 1.5
		if unit_offset >= 0.999 :
			if disappear :
				get_parent().queue_free()
			else :
				moves = false


func depart():
	moves = true
