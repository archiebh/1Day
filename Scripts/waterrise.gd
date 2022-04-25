extends CSGBox


var speed = 1.5
onready var sky = global.watery

func getSpeedIdeal():
	return (get_node("/root/mainNode").globMostHeight-translation.y)/7
	

# Called when the node enters the scene tree for the first time.
func _ready():


	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translation = Vector3(0, getSpeedIdeal()*delta, 0) + translation
	global.watery = translation.y
	pass
