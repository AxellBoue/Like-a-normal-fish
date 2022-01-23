extends PanelContainer

# sons
onready var sounds = [preload("res://sons/1.wav"), preload("res://sons/1.wav"),preload("res://sons/1.wav"), preload("res://sons/bravo.wav"), preload("res://sons/bouuuh.wav")]
onready var stream_sons = $hbox/AudioStreamPlayer
var rand = RandomNumberGenerator.new()
# image
onready var image_modif_mat = preload("res://materials/image_correct_mat.tres")
var shader_actif = true
var panel_shader

# Called when the node enters the scene tree for the first time.
func _ready():
	rand.randomize()
	if get_parent().name == "options" : # si c'est le menu
		panel_shader = get_node("../../image_modif")
	else : # si c'est le jeu
		panel_shader = get_node("../image_modif")
	$"hbox/music slider".value = AudioServer.get_bus_volume_db(1)
	$"hbox/sons  slider".value = AudioServer.get_bus_volume_db(2)
	$"hbox/contraste  slider".value = image_modif_mat.get_shader_param("contrast")
	$"hbox/hue  slider".value =  image_modif_mat.get_shader_param("hue_modif")
	check_active_shader()

func activated():
	$"hbox/music slider".grab_focus()

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1,value)
	if value <= -30 :
		AudioServer.set_bus_mute(1,true)
	elif AudioServer.is_bus_mute(1) :
		AudioServer.set_bus_mute(1,false)


func _on_sons__slider_value_changed(value):
	AudioServer.set_bus_volume_db(2,value)
	if value <= -30 :
		AudioServer.set_bus_mute(2,true)
	elif AudioServer.is_bus_mute(2) :
		AudioServer.set_bus_mute(2,false)
	stream_sons.stream = sounds[rand.randi_range(0,sounds.size()-1)]
	stream_sons.play()


func _on_contraste__slider_value_changed(value):
	image_modif_mat.set_shader_param("contrast",value)
	check_active_shader()

func _on_hue__slider_value_changed(value):
	image_modif_mat.set_shader_param("hue_modif",value)
	check_active_shader()

func check_active_shader():
	if image_modif_mat.get_shader_param("contrast") == 1 && image_modif_mat.get_shader_param("hue_modif") == 0 :
		panel_shader.visible = false
		shader_actif = false
	elif !shader_actif :
		panel_shader.visible = true
		shader_actif = true

func _on_retour_button_down():
	if get_node("/root/Control") != null : # si on est dans le menu
		get_node("/root/Control/boutons menu").back_from_options()
	else : # si on est en jeu
		get_node("/root/Spatial/CanvasLayer/Control/menu in game").back_from_options()
