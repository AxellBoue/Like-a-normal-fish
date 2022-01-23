extends Spatial

onready var feedback = $"feedback pnj"
onready var ui_action = get_node("/root/Spatial/CanvasLayer/Control/VBoxContainer/actions/actions/Label")
export var dialogues : Array = ["You’re here again to ask to start the race facing on the side ? Why do you want it so much ? You’re so desperate for attention ?",
"Everyone has always started facing the race, how could we trust someone who does’nt even look toward his future ?",
"Do you have something to hide ? In a baby we could tolerate it, but you’re a grown up now ! Only lyers and bad people don’t look in front of them.",
"qsdf","sqf"]
var num = 0
var is_in_dialogue = false
onready var label = get_node("/root/Spatial/CanvasLayer/Control/VBoxContainer/dialogues/Label")
var player_proche = false

# Called when the node enters the scene tree for the first time.
func _ready():
	label.get_parent().visible = false
	ui_action.get_parent().get_parent().visible = false
	feedback.visible = false

func _process(delta):
	if Input.is_action_just_pressed("action") && player_proche :
		parle()

func parle():
	if is_in_dialogue :
		next_dialogue()
	else :
		label.text = dialogues[num]
		label.get_parent().visible = true
		ui_action.get_parent().get_parent().visible = false
		is_in_dialogue = true

func next_dialogue():
	num += 1
	if num < dialogues.size():
		label.text = dialogues[num]
	else :
		label.get_parent().visible = false
		ui_action.get_parent().get_parent().visible = true
		is_in_dialogue = false
		num = 0

func _on_Area_body_entered(body):
	if body.name == "crab":
		body.add_objet_proche(self)
		player_proche = true
		feedback.visible = true
		ui_action.bbcode_text = "[center][b]Talk[/b] [/center]"
		ui_action.get_parent().get_parent().visible = true

func _on_Area_body_exited(body):
	if body.name == "crab":
		player_proche = false
		body.remove_objet_proche(self)
		feedback.visible = false
		ui_action.get_parent().get_parent().visible = false
		#reset dialogue
		is_in_dialogue = false
		label.get_parent().visible = false
		num = 0
