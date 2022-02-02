extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var parent : Node
var xOff
var yOff
# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	if get_node("/root/mainNode").globBlockInstance == 0:
		xOff=25
		yOff=0
	elif get_node("/root/mainNode").globBlockInstance == 1:
		xOff=-25
		yOff=0
	elif get_node("/root/mainNode").globBlockInstance == 2:
		xOff=25
		yOff=25
	elif get_node("/root/mainNode").globBlockInstance == 3:
		xOff=-25
		yOff=25
	elif get_node("/root/mainNode").globBlockInstance == 4:
		xOff=25
		yOff=-25
	elif get_node("/root/mainNode").globBlockInstance == 5:
		xOff=-25
		yOff=-25
	elif get_node("/root/mainNode").globBlockInstance == 6:
		xOff=0
		yOff=25
	elif get_node("/root/mainNode").globBlockInstance == 7:
		xOff=0
		yOff=-25
		global_transform.origin = parent.translation + Vector3(xOff, 0, yOff)
		get_node("/root/mainNode").globFallStart=true
	
	global_transform.origin = parent.translation + Vector3(xOff, 0, yOff)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_transform.origin = parent.translation + Vector3(xOff, 0, yOff)
