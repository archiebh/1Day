extends Spatial


var blockSrc = preload("res://Scenes/cube.tscn")
var timeb4 = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeb4+=delta
	if timeb4 > 2:
		timeb4=0
		add_child(blockSrc.instance())
