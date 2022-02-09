extends Spatial


# Declare member variables here. Examples:
var speed = 20
onready var audio = $AudioStreamPlayer3D
onready var hitbox = $CSGCombiner/CSGBox/Area
onready var water = get_node("/root/mainNode/lvl1/water")
var fallKeep=false
var stopped=false
onready var csg = $CSGCombiner
# Called when the node enters the scene tree for the first time.

func nearestFive(num):
	return 2.25 + (floor((num+2)/4)*4)

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
	translation = Vector3(xNum+xOff, get_node("/root/mainNode").globMostHeight+40, zNum+yOff)

	scale = Vector3(get_node("/root/mainNode").globWidth, 1, get_node("/root/mainNode").globHeight)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_node("/root/mainNode").globFallStart and stopped==false:
		translation -= Vector3(0, speed*delta, 0)
		fallKeep=true
	if fallKeep and stopped==false:
		translation -= Vector3(0, speed*delta, 0)
	if len(hitbox.get_overlapping_areas()) > 0 and stopped == false:
		var yPos=translation.y
		for area in hitbox.get_overlapping_areas():
			if area.is_in_group("blocks"):
				stopped=true
				speed=0
				translation = Vector3(translation.x, nearestFive(yPos), translation.z)
				audio.play()
				csg.cast_shadow = false
				if translation.y > get_node("/root/mainNode").globMostHeight:
					get_node("/root/mainNode").globMostHeight = translation.y
	if len(hitbox.get_overlapping_areas()) > 0 and stopped == true:
		for area in hitbox.get_overlapping_areas():
			if area.is_in_group("culler"):
				queue_free()

