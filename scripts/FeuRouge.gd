extends StaticBody


onready var game_manager = get_node("/root/Spatial/game manager")
onready var feux = [$"feu rouge", $"feu orange 1", $"fau orange 2",$"feu vert"]
var feux_emission_colors = ["#ff0000","#ff3600","#ff3600","#19f600"]
var emmission_strength = 3.5
onready var feu : MeshInstance = $"feu rouge"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func allume_feux(num):
	if num <= 3 :
		feux[num].get_surface_material(0).emission = feux_emission_colors[num]
		feux[num].get_surface_material(0).emission_energy = emmission_strength
		feux[num].get_surface_material(0).emission_enabled = true
	if num > 0:
		feux[num-1].get_surface_material(0).emission_enabled = false
		if num == 4 :
			get_node("/root/Spatial/WorldEnvironment").get_environment().glow_enabled = false


