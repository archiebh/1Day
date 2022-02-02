extends Spatial


var blockSrc = preload("res://Scenes/cube.tscn")
var blockCopySrc = preload("res://Scenes/cubeCopy.tscn")
var timeb4 = 0
var globBlockInstance=0

var globMostHeight=0

var globFallStart=false

var globXnum =0
var globZnum =0
var globBlockSize =0
var globWidth =0
var globHeight =0
var random = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.target_fps = 60
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeb4+=delta
	if timeb4 > 0.5:
		globFallStart=false
		random.randomize()
		globXnum = random.randf_range(-11, 11)
		globZnum = random.randf_range(-11, 11)
		globBlockSize = random.randf_range(1, 4)
		globWidth = random.randf_range(0.5, globBlockSize-0.2)
		globHeight = globBlockSize - globWidth
		add_child(blockSrc.instance())
		timeb4=0
