extends StaticBody


var player_proche = false
var player
onready var feedback = $feedback
onready var ui_action = get_node("/root/Spatial/CanvasLayer/Control/VBoxContainer/actions/actions/Label")
var temps_timer = 3
onready var dialogues_label = get_node("/root/Spatial/CanvasLayer/Control/VBoxContainer/dialogues/Label")
onready var timer_dialogues =  get_node("/root/Spatial/CanvasLayer/Control/VBoxContainer/dialogues/Timer")

# Called when the node enters the scene tree for the first time.
func _ready():
	feedback.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("action") && player_proche :
		player.ramasse_baton()
		ui_action.get_parent().get_parent().visible = false
		dialogues_label.bbcode_text = "Wow this is the perfect shape, it will help me turn faster !"
		dialogues_label.get_parent().visible = true
		timer_dialogues.wait_time = temps_timer
		timer_dialogues.start()
		get_tree().call_group("baton","queue_free")

func _on_Area_body_entered(body):
	if body.name == "crab":
		body.add_objet_proche(self)
		player = body
		player_proche = true
		feedback.visible = true
		ui_action.bbcode_text = "[center][b]Pick up[/b] [/center]"
		ui_action.get_parent().get_parent().visible = true


func _on_Area_body_exited(body):
	if body.name == "crab":
		player_proche = false
		body.remove_objet_proche(self)
		feedback.visible = false
		ui_action.get_parent().get_parent().visible = false
