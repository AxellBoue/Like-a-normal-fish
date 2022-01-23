extends Area

var texte_lu = false
export var lance_fin = false
export var texte = ["Well, I won't try to jump over this. I know I can't do it. I won't die for this stupid race",
"They are fun with their 'try your best'. I can't fly. Nor even swim.", 
"It was useless all along, I had no chance to make it to the end. "]
onready var timer_fin = $"Timer fin"
onready var zone_zexte = get_node("/root/Spatial/CanvasLayer/Control/VBoxContainer/dialogues/Label")
onready var timer_texte = $"Timer texte"
var num = 0
export var temps_texte = 5
export var must_have_stick = true
export var both_ok = false

# Called when the node enters the scene tree for the first time.
func _ready():
	timer_texte.wait_time = temps_texte


func _on_Area_body_entered(body):
	if body.name == "crab" && !texte_lu:
		if both_ok || body.has_baton == must_have_stick :
			texte_lu = true
			zone_zexte.get_parent().visible = true
			zone_zexte.bbcode_text = texte[0]
			timer_texte.start()


func _on_Timer_texte_timeout():
	num += 1
	if num < texte.size() :
		zone_zexte.bbcode_text = texte[num]
		timer_texte.start()
	else :
		zone_zexte.get_parent().visible = false
		if lance_fin :
			if  !get_node("/root/Spatial/course/crevasse fin").revolution_started :
				get_node("/root/Spatial/course/crevasse fin").start_timer_revolution()
