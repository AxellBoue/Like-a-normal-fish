extends Spatial

#options
var volume_sons = 0
var volume_musique = -10

#musiques
onready var musique_course = preload("res://sons/Rock'n Roll Circuit.ogg")
onready var musique_stream = $AudioStreamPlayerMusique

# gestion journées
var temps_nuit = 60
var temps_annonce = 100 # declenche l'aube
var temps_reboot = 120
var waits_for = "nuit"
var temps = 0
var quotien = 1 # accélere ou ralenti le temps selon ce qu'on fait. temps après annonce fixe ?
var last_quotien = 1
onready var night_effect = get_node("/root/Spatial/CanvasLayer/Control/night effect")
onready var night_effect_mat : Material = night_effect.material
var to_night = false
var to_dawn = false
var night_quotien = 0
var vitesse_night_fall = 0.1
var vitesse_sun_rise = 0.3
var num_try_avant_message = 4

# annonces
onready var annonce_label = get_node("/root/Spatial/CanvasLayer/Control/VBoxContainer/annonces/Label")
onready var timer_cache_annonce = $TimerCacheAnnonce
onready var annonces_stream = $AudioStreamPlayerAnnonces
onready var son_annonce = preload("res://sons/the race starts.wav")

# teleporte
onready var particule_down = $"Particles down"
onready var particule_up = $"Particles up"
onready var crab = get_node("/root/Spatial/crab")
var temps_particules = 0.9

# groupe trouve baton
onready var groupe_baton = get_node("/root/Spatial/groupe trouve baton")


# Called when the node enters the scene tree for the first time.
func _ready():
	annonce_label.get_parent().visible = false
	crab.visible = false 
	particule_down.emitting = true
	$"Timer particules".wait_time = temps_particules
	$"Timer particules".start()
	# affiche selon si on a essayé la course ou pas
	if get_node("/root/Singleton").has_tried_race : # si a essayé la course pas les vieux qui disent d'y retourner
		get_node("/root/Spatial/groupe avant try course").queue_free()
		get_node("/root/Spatial/groupe trouve baton/Zone baton exemple/AnimationPlayer2").play("crabe tourne")
	else : # si a pas essayé la course, pas de groupe de baton
		get_node("/root/Spatial/groupe trouve baton").queue_free()
	# active zone ralcu si essayé 4 fois mais pas encore le baton
	if Singleton.try_race < num_try_avant_message || Singleton.has_baton :
		get_node("/root/Spatial/Zone texte ralcu").queue_free()
	#gestion zones caméras village
	if Singleton.camera_turned_village : # si deja tourné la camera dans le village, desactie les zones loins
		get_node("/root/Spatial/zone camera tourne village loin").queue_free()
		get_node("/root/Spatial/zone camera tourne village tres loin").queue_free()
	elif !Singleton.has_tried_race : #si pas turned et pas try race (donc pas les crabes) desactive les proches
		get_node("/root/Spatial/zone camera tourne village proche").queue_free()
		get_node("/root/Spatial/zone camera tourne village loin").queue_free()
	else : # si pas turned mais tried race (donc les crabes) active celle du milieu
		get_node("/root/Spatial/zone camera tourne village proche").queue_free()
		get_node("/root/Spatial/zone camera tourne village tres loin").queue_free()
	if Singleton.has_baton : # si a le baton, désactive les trois
		get_node("/root/Spatial/zone camera tourne village loin").queue_free()
		get_node("/root/Spatial/zone camera tourne village proche").queue_free()
		get_node("/root/Spatial/zone camera tourne village tres loin").queue_free()
		
func start_musique():
	musique_stream.stream = musique_course
	musique_stream.volume_db = volume_musique
	musique_stream.play()

func _physics_process(delta):
	# timers gestion etapes
	temps += delta * quotien
	if temps >= temps_nuit && waits_for == "nuit":
		start_night_fall()
	elif temps >= temps_annonce && waits_for == "annonce":
		lance_annonce()
		# start sunrise après le timer qui cache l'annonce
	elif temps >= temps_reboot && waits_for == "reboot":
		quotien = 0
		temps = 0
		lance_reboot()
	
	# gestion changement jour et nuit
	if to_night :
		night_quotien += delta * vitesse_night_fall
		night_effect_mat.set_shader_param("intensity",night_quotien)
		if night_quotien >= 1:
			to_night = false
	if to_dawn :
		night_quotien -= delta * vitesse_sun_rise
		night_effect_mat.set_shader_param("intensity",night_quotien)
		if night_quotien <= 0:
			to_dawn = false
			night_effect.visible = false


func start_night_fall():
	temps = temps_nuit
	waits_for = "annonce"
	night_quotien = 0
	night_effect_mat.set_shader_param("intensity",night_quotien)
	night_effect.visible = true
	to_dawn = false
	to_night = true

func lance_annonce():
	temps = temps_annonce
	waits_for = "reboot"
	annonces_stream.volume_db = volume_sons
	annonces_stream.stream = son_annonce
	annonces_stream.play()
	annonce_label.bbcode_text = "[center]  The race starts in one minute ! [/center]"
	annonce_label.get_parent().visible = true
	timer_cache_annonce.start()

func cache_annonce():
	annonce_label.get_parent().visible = false
	start_sun_rise()

func start_sun_rise():
	night_quotien = 1
	to_night = false
	to_dawn = true
	
func lance_reboot():
	particule_up.transform.origin = crab.transform.origin
	particule_up.emitting = true
	crab.bloque = true
	$"Timer particules".start()

func stop_time_fin(): # fait que le temps ne passe plus
	last_quotien = quotien
	quotien = 0

func relance_temps():
	if quotien == 0 :
		quotien = last_quotien

func _on_Timer_particules_timeout():
	if waits_for == "nuit":
		if crab.visible == false :
			crab.visible = true
			$"Timer particules".start()
		else :
			particule_down.queue_free()
			if Singleton.has_baton :
				get_node("/root/Spatial/Zone texte lets try")._on_Area_body_entered(crab)
	elif waits_for == "reboot":
		if crab.visible == true :
			crab.visible = false 
			$"Timer particules".wait_time += 0.3
			$"Timer particules".start()
		else :
			get_node("/root/Singleton").has_baton = crab.has_baton
			get_tree().change_scene("res://main.tscn")
