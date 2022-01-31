extends Spatial


# Declare member variables here. Examples:
var speed = 5
onready var hitbox = $CSGCombiner/CSGBox/Area
onready var water = get_node("/root/mainNode/lvl1/water")
var stopped=false
var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	random.randomize()
	var xNum = random.randf_range(-12.5, 12.5)
	var zNum = random.randf_range(-12.5, 12.5)
	translation = Vector3(xNum, water.translation.y+40, zNum)
	
	var blockSize = random.randf_range(2, 8)
	var width = random.randf_range(1, blockSize-0.4)
	var height = blockSize - width
	scale = Vector3(width, 1, height)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translation -= Vector3(0, speed*delta, 0)
	#if len(hitbox.get_overlapping_areas()) > 0 and stopped == false:
	for area in hitbox.get_overlapping_areas():
		if not area.is_in_group("player"):
			speed = 0
			stopped=true
		if area.is_in_group("culler"):
			queue_free()

