extends Area

onready var game_manager = get_node("/root/Spatial/game manager")
export var declenche_nuit = false
export var declenche_annonce = false
export var stop_compteur = false
export var relance_temps = false
export var has_tried_race = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_zone_declenche_nuit_body_entered(body):
	if body.name == "crab":
		if stop_compteur && body.has_baton && game_manager.waits_for != "reboot":
			game_manager.stop_time_fin()
		elif relance_temps :
			game_manager.relance_temps()
		elif !body.has_baton && declenche_nuit && game_manager.waits_for == "nuit":
			game_manager.start_night_fall()
			queue_free()
		elif !body.has_baton && declenche_annonce && game_manager.waits_for == "annonce":
			game_manager.lance_annonce()
			game_manager.quotien = 2.5
			queue_free()
		elif has_tried_race :
			Singleton.has_tried_race = true
			Singleton.try_race += 1
			queue_free()
