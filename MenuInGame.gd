extends VBoxContainer


var is_paused = false
onready var option_pannel = get_node("/root/Spatial/CanvasLayer/Control/panel options")
onready var musique_menu = preload("res://sons/Visiting the city with your kart.ogg")

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	option_pannel.visible = false
	$AudioStreamPlayer.stream = musique_menu
	
func _process(delta):
	if Input.is_action_just_pressed("pause") :
		if !is_paused :
			met_pause()
		else :
			enleve_pause()

func met_pause():
	is_paused = true
	visible = true
	get_tree().paused = true
	$resume.grab_focus()
	$Timer.start()

func enleve_pause() :
	$resume.grab_focus()
	$resume.release_focus()
	$AudioStreamPlayer.stop()
	option_pannel.visible = false
	visible = false
	is_paused = false
	get_tree().paused = false

func _on_resume_button_down():
	enleve_pause()

func _on_options_button_down():
	option_pannel.visible = true
	option_pannel.activated()

func back_from_options():
	option_pannel.visible = false
	$resume.grab_focus()

func _on_menu_button_down():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/menu_demmarage.tscn")

func _on_quit_button_down():
	get_tree().quit()

func _on_Timer_timeout():
	if is_paused:
		$AudioStreamPlayer.play()
