extends Area

export var vitesse_transition = 3
export var destroy_autre = false
export var village = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_zone_camera_tourne_body_entered(body):
	if body.name == "crab":
		if !body.camera_is_good && !body.has_baton:
			body.vitesse_transition = vitesse_transition
			body.to_dos = true
			if village :
				Singleton.camera_turned_village = true
				get_node("/root/Spatial/Zone texte fuck it camera")._on_Area_body_entered(get_node("/root/Spatial/crab"))
			if destroy_autre && get_node("/root/Spatial/zone camera tourne course") != null :
				get_node("/root/Spatial/zone camera tourne course").queue_free()
		#queue_free()
