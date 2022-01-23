extends VBoxContainer


onready var option_pannel = get_node("/root/Control/options")


# Called when the node enters the scene tree for the first time.
func _ready():
	option_pannel.visible = false
	$play.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_play_button_down():
	Singleton.reinitialise()
	get_tree().change_scene("res://main.tscn")


func _on_options_button_down():
	option_pannel.visible = true
	option_pannel.get_node("panel options").activated()

func back_from_options():
	option_pannel.visible = false
	$play.grab_focus()
	#option_pannel.get_node("panel options/hbox/MarginContainer/retour").release_focus()

func _on_quit_button_down():
	get_tree().quit()
