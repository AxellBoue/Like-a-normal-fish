extends StaticBody


onready var audiosource = $AudioStreamPlayer
onready var ooh = preload("res://sons/oooh1.wav")
var volume_sons = 0
onready var son_label = get_node("/root/Spatial/CanvasLayer/Control/VBoxContainer/MarginContainer/sons/Label")

# Called when the node enters the scene tree for the first time.
func _ready():
	volume_sons = get_node("/root/Spatial/game manager").volume_sons
	audiosource.stream = ooh



func _on_zone_oooh_body_entered(body):
	if body.name == "crab":
		audiosource.volume_db = volume_sons * 0.7
		audiosource.play()
		son_label.bbcode_text = "[center][b]Ooooh :([/b] [/center]"
		son_label.get_parent().get_parent().visible = true
		$Timer.start()
		

func _on_Timer_timeout():
	son_label.get_parent().get_parent().visible = false
	
