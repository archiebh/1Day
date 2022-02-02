extends Spatial


var speed = 20
onready var audio = $AudioStreamPlayer3D
onready var hitbox = $CSGCombiner/CSGBox/Area
onready var water = get_node("/root/mainNode/lvl1/water")
var stopped=false
var begin = false
onready var csg = $CSGCombiner

func nearestFive(num):
	return 2.25 + (floor((num+2)/4)*4)
# Called when the node enters the scene tree for the first time.
func _ready():
	var xNum = get_node("/root/mainNode").globXnum
	var zNum = get_node("/root/mainNode").globZnum
	translation = Vector3(xNum, get_node("/root/mainNode").globMostHeight+40, zNum)
	scale = Vector3(get_node("/root/mainNode").globWidth, 1, get_node("/root/mainNode").globHeight)
	
	get_node("/root/mainNode").globBlockInstance=0
	add_child(get_node("/root/mainNode").blockCopySrc.instance())
	get_node("/root/mainNode").globBlockInstance += 1
	add_child(get_node("/root/mainNode").blockCopySrc.instance())
	get_node("/root/mainNode").globBlockInstance += 1
	add_child(get_node("/root/mainNode").blockCopySrc.instance())
	get_node("/root/mainNode").globBlockInstance += 1
	add_child(get_node("/root/mainNode").blockCopySrc.instance())
	get_node("/root/mainNode").globBlockInstance += 1
	add_child(get_node("/root/mainNode").blockCopySrc.instance())
	get_node("/root/mainNode").globBlockInstance += 1
	add_child(get_node("/root/mainNode").blockCopySrc.instance())
	get_node("/root/mainNode").globBlockInstance += 1
	add_child(get_node("/root/mainNode").blockCopySrc.instance())
	get_node("/root/mainNode").globBlockInstance += 1
	add_child(get_node("/root/mainNode").blockCopySrc.instance())
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_node("/root/mainNode").globFallStart == true:
		begin = true
	if stopped==false:
		translation -= Vector3(0, speed*delta, 0)
	if len(hitbox.get_overlapping_areas()) > 0 and stopped == false and begin:
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
