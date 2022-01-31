extends Spatial


# Declare member variables here. Examples:
var speed = 2
onready var hitbox = $CSGCombiner/CSGBox/Area
var stopped=false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translation -= Vector3(0, speed*delta, 0)
	if len(hitbox.get_overlapping_areas()) > 0 and stopped == false:
		speed = 0
		stopped=true

