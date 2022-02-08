extends Spatial


var hier

var speed = 20
onready var audio = $AudioStreamPlayer3D
onready var hitbox = $CSGCombiner/CSGBox/Area
onready var water = get_node("/root/mainNode/lvl1/water")
var stopped=false
var begin = false
var waved=false
var shadowDelay=0
onready var csg = $CSGCombiner

func nearestFive(num):
	return 2.25 + (floor((num+2)/4)*4)
# Called when the node enters the scene tree for the first time.
func _ready():
	csg.cast_shadow = false
	hier = get_node("/root/mainNode").hierPass
	var xNum = get_node("/root/mainNode").globXnum
	var zNum = get_node("/root/mainNode").globZnum
	var rotNum = get_node("/root/mainNode").globRot
	translation = Vector3(xNum, get_node("/root/mainNode").globMostHeight+40, zNum)
	scale = Vector3(get_node("/root/mainNode").globWidth, 1, get_node("/root/mainNode").globHeight)
	rotation = Vector3(0, rotNum, 0)
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
	audio.unit_db = global.sound
	if get_node("/root/mainNode").globWaveCount > 5:
		begin = true
	if stopped==false:
		translation -= Vector3(0, speed*delta, 0)
	if len(hitbox.get_overlapping_areas()) > 0 and stopped == false and begin:
		var yPos=translation.y
		for area in hitbox.get_overlapping_areas():
			if area.is_in_group("blocks"):
				if yPos-4 > get_node("/root/mainNode").globMostHeight:
					if hier < area.get_parent().get_parent().get_parent().hier:
						queue_free()
				else:
					stopped=true
					speed=0
					translation = Vector3(translation.x, nearestFive(yPos), translation.z)
					if global.isInGame:
						if translation.distance_to(get_node("/root/mainNode/FirstPerson").translation) < 26:
							audio.play()
					else:
						audio.play()
					csg.cast_shadow = false
					if translation.y > get_node("/root/mainNode").globMostHeight:
						get_node("/root/mainNode").globMostHeight = translation.y
			if area.is_in_group("blocks2"):
				stopped=true
				speed=0
				translation = Vector3(translation.x, nearestFive(yPos), translation.z)
				audio.play()
				csg.cast_shadow = false
				if translation.y > get_node("/root/mainNode").globMostHeight:
					get_node("/root/mainNode").globMostHeight = translation.y
	
	if begin and shadowDelay < 10:
		shadowDelay+=1
	if shadowDelay > 9 and not csg.cast_shadow:
		csg.cast_shadow = true
	if translation.y+10 < water.translation.y:
		queue_free()
