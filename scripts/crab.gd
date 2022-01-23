extends KinematicBody

#mouvement données
export var vitesse = 5
export var vitesse_rot_base = 1
export var vitesse_rot_baton = 2 #4
var vitesse_rot
var gravite = 0.6
#mouvement var
var mouvement = Vector3(0,0,0)
var inputX = 0
var inputY = 0
var my = 0 #mouvement sur l'axe y 

# etat
var bloque = true
var has_baton = false
var is_baton_actif = false
var is_autre_action_dispo = false
var obj_proches : Array = []

# camera
onready var camera_box = $Spatial
onready var cam_dos_rot = 90
onready var cam_profil_rot = 0
var vitesse_transition = 5
var vitesse_transition_default = 5
var to_profil = false
var to_dos = false
var camera_is_good = false
	#camera.transform = camera.transform.interpolate_with(cam_dos.transform,vitesse_transition*delta)

#baton
onready var baton_actif = $"baton actif"
onready var baton_range = $"baton range"


# Called when the node enters the scene tree for the first time.
func _ready():
	vitesse_rot = vitesse_rot_base
	baton_actif.visible = false
	baton_range.visible = false
	init (get_node("/root/Singleton").has_baton)
	
func init(new_has_baton):
	if (new_has_baton):
		ramasse_baton()
		to_dos = true
		get_node("/root/Spatial/groupe trouve baton/baton a ramasser").queue_free()
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("action"):
		if (has_baton && !is_autre_action_dispo):
			set_active_baton(!is_baton_actif)

func _physics_process(delta):
	get_inputs()
	my = mouvement.y
	mouvement = global_transform.basis.x*inputY*vitesse
	mouvement.y = my
	if !bloque :
		mouvement +=  Vector3.DOWN * gravite
		mouvement = move_and_slide(mouvement, Vector3(0,1,0),true,4,0.5)
		# rotation droite gauche -> peut se tourner dans l'anim même si bloque
		global_rotate(global_transform.basis.y, -inputX * 0.005 * vitesse_rot)
		if is_on_floor() :
			my = 0
		
	# changements d'angle de cameras
	if to_dos :
		camera_box.rotate_y(delta*vitesse_transition*0.1)
		if camera_box.rotation_degrees.y >= cam_dos_rot:
			to_dos = false
			camera_box.rotation_degrees.y = cam_dos_rot
			camera_is_good = true
			vitesse_transition = vitesse_transition_default
	if to_profil :
		camera_box.rotate_y(-delta*vitesse_transition*0.1)
		if camera_box.rotation_degrees.y <= cam_profil_rot:
			to_profil = false
			camera_box.rotation_degrees.y = cam_profil_rot
			camera_is_good = false
			vitesse_transition = vitesse_transition_default

func get_inputs():
	inputX = 0
	inputY = 0
	if Input.is_action_pressed("up"):
		inputY += 1
	if Input.is_action_pressed("down"):
		inputY -= 1
	if Input.is_action_pressed("right"):
		inputX += 1
	if Input.is_action_pressed("left"):
		inputX -= 1

func ramasse_baton():
	has_baton = true
	set_active_baton(true)
	
func set_active_baton(b):
	is_baton_actif = b
	if is_baton_actif : 
		vitesse_rot = vitesse_rot_baton
		baton_actif.visible = true
		baton_range.visible = false
	else :
		vitesse_rot = vitesse_rot_base
		baton_actif.visible = false
		baton_range.visible = true

func add_objet_proche(obj):
	obj_proches.append(obj)
	is_autre_action_dispo = true
	
func remove_objet_proche(obj):
	obj_proches.erase(obj)
	if obj_proches.size() <= 0 :
		is_autre_action_dispo = false

func depart():
	bloque = false

