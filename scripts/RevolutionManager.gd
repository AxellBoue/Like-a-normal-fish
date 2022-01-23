extends StaticBody

var revolution_started = false
onready var musique_player = get_node("/root/Spatial/game manager/AudioStreamPlayerMusique")
onready var musique_revolution = preload("res://sons/ULTRA METAL.ogg")
onready var camera = get_node("/root/Spatial/crab/Spatial/Camera")
onready var cam_objectif = get_node("pos cam fin")
var camera_moves = false
var vitesse_transition = 0.4
onready var timer_apparition = $"revolution/Timer apparition"
var i = -1
var wait_time_debut = 5
var wait_time_avant_apparition = 2
var wait_time_apparitions = 0.5
var wait_time_pause = 4
var wait_time_slogans = 1.5
var wait_time_fin = 4
var wait_time_apres_noir = 1
onready var crips = [$"revolution/crab v6",
$"revolution/crab jaune2",
$"revolution/crab orange2",
$"revolution/bernard lhermite 4",
$"revolution/bernard lhermite 1",
$"revolution/crab v5",
$"revolution/bernard lhermite 3",
$"revolution/crab jaune",
$"revolution/bernard lhermite 2",
$"revolution/crab v4",
$"revolution/crab orange",
$"revolution/crab jaune3",
] 
onready var textes = []
#fondu noir
var to_noir = false
onready var black_screen = get_node("/root/Spatial/CanvasLayer/Control/noir")
var alpha = 0
var vitesse_noir = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	for c in crips :
		c.visible = false
	var textes_parent = get_node("/root/Spatial/CanvasLayer/Control/slogans container")
	for j in range(1,9):
		textes.append(textes_parent.get_node("slogan"+str(j)))

func start_timer_revolution():
	revolution_started = true
	timer_apparition.wait_time = wait_time_debut
	timer_apparition.start()

func start_musique_revolution():
	musique_player.volume_db = -5 
	musique_player.stream = musique_revolution
	musique_player.play()

func _physics_process(delta):
	if camera_moves :
		camera.transform = camera.transform.interpolate_with(cam_objectif.transform,vitesse_transition*delta)
	
	if to_noir :
		alpha += delta * vitesse_noir
		black_screen.color = Color(0,0,0,alpha)
		if alpha >= 1 :
			to_noir = false
			alpha = 1
			black_screen.color = Color(0,0,0,alpha)
			timer_apparition.wait_time = wait_time_apres_noir
			timer_apparition.start()


func _on_Timer_apparition_timeout():
	if alpha == 5 :
		print("timer")
	else :
		if i == -1:
			start_musique_revolution() # lance la muique
			timer_apparition.wait_time = wait_time_avant_apparition
			timer_apparition.start()
			get_node("/root/Spatial/crab").bloque = true
			# lance mouvement camera
			var tr = camera.global_transform
			camera.get_parent().remove_child(camera)
			add_child(camera)
			camera.global_transform = tr
			camera_moves = true
		elif i == 0:
			timer_apparition.wait_time = wait_time_apparitions
			timer_apparition.start()
		elif i <= crips.size():
			timer_apparition.wait_time = wait_time_apparitions
			crips[i-1].visible = true
			timer_apparition.start()
		elif i == crips.size() + 1 : # si cripsize = 8, ici i = 9
			timer_apparition.wait_time = wait_time_pause
			timer_apparition.start()
		elif i <= crips.size() + textes.size() + 1 : # i = 10  à i = 8 + 8 + 1 = 17
			timer_apparition.wait_time = wait_time_slogans
			textes[i - crips.size() -2 ].visible = true  # i -10 :  0 à 7
			timer_apparition.start()
		elif i == crips.size() + textes.size() + 2 :
			timer_apparition.wait_time = wait_time_fin
			timer_apparition.start()
		elif i == crips.size() + textes.size() + 3 :
			black_screen.visible = true
			to_noir = true
		else :
			get_tree().change_scene("res://scenes/menu_demmarage.tscn")
		i += 1
