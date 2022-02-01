extends Spatial


# Declare member variables here. Examples:
var speed = 20
onready var hitbox = $CSGCombiner/CSGBox/Area
onready var water = get_node("/root/mainNode/lvl1/water")
var stopped=false
onready var csg = $CSGCombiner
# Called when the node enters the scene tree for the first time.
func _ready():
	
	var xOff
	var yOff
	if get_node("/root/mainNode").blockInstance == 0:
		xOff=0
		yOff=0
	elif get_node("/root/mainNode").blockInstance == 1:
		xOff=25
		yOff=0
	elif get_node("/root/mainNode").blockInstance == 2:
		xOff=-25
		yOff=0
	elif get_node("/root/mainNode").blockInstance == 3:
		xOff=25
		yOff=25
	elif get_node("/root/mainNode").blockInstance == 4:
		xOff=-25
		yOff=25
	elif get_node("/root/mainNode").blockInstance == 5:
		xOff=25
		yOff=-25
	elif get_node("/root/mainNode").blockInstance == 6:
		xOff=-25
		yOff=-25
	elif get_node("/root/mainNode").blockInstance == 7:
		xOff=0
		yOff=25
	elif get_node("/root/mainNode").blockInstance == 8:
		xOff=0
		yOff=-25
	
	var xNum = get_node("/root/mainNode").globXnum
	var zNum = get_node("/root/mainNode").globZnum
	translation = Vector3(xNum+xOff, water.translation.y+40, zNum+yOff)

	scale = Vector3(get_node("/root/mainNode").globWidth, 1, get_node("/root/mainNode").globHeight)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translation -= Vector3(0, speed*delta, 0)
	#if len(hitbox.get_overlapping_areas()) > 0 and stopped == false:
	for area in hitbox.get_overlapping_areas():
		if not area.is_in_group("player"):
			speed = 0
			stopped=true
			csg.cast_shadow = false
		if area.is_in_group("culler"):
			queue_free()

