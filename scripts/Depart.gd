extends Timer

onready var game_manager = get_node("/root/Spatial/game manager")
onready var son_label = get_node("/root/Spatial/CanvasLayer/Control/VBoxContainer/MarginContainer/sons/Label")
onready var feu_rouge = get_node("/root/Spatial/course/course debut/feu rouge")

var compteur = -1
onready var audiostream = [$AudioStreamPlayer,$AudioStreamPlayer2 ]
onready var audiostream1 : AudioStreamPlayer3D = $AudioStreamPlayer3D
onready var sons : Array = [preload("res://sons/3.wav"),preload("res://sons/2.wav"),preload("res://sons/1.wav"),preload("res://sons/goo.wav")]
onready var textes = ["3 !", "2 !", "1 !!", "GO !!!!"]
var start_wait_time = 2
var decalage_musique = 0.2

var volume_sons = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	volume_sons = game_manager.volume_sons
	audiostream[0].volume_db = volume_sons
	audiostream[1].volume_db = volume_sons
	son_label.get_parent().get_parent().visible = false
	connect("timeout",self,"decompte")
	one_shot = true
	if Singleton.has_baton :
		start_wait_time = 4.5
	wait_time = start_wait_time
	start()

func decompte():
	if compteur == -1:
		compteur += 1
		wait_time = decalage_musique
		game_manager.start_musique()
		start()
	elif compteur <= 3 :
		audiostream[compteur%2].stream = sons[compteur]
		audiostream[compteur%2].play()
		son_label.get_parent().get_parent().visible = true
		son_label.bbcode_text = "[center][b]"+ textes[compteur] + "[/b][/center]"
		feu_rouge.allume_feux(compteur)
		wait_time = 1
		if compteur == 3 :
			depart()
			wait_time = 2
		compteur += 1
		start()
	else :
		son_label.get_parent().get_parent().visible = false
		feu_rouge.allume_feux(compteur)
		

func depart():
	get_node("/root/Spatial/crab").depart()
	get_tree().call_group("poissons","depart")
