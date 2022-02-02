extends Spatial


var blockSrc = preload("res://Scenes/cube.tscn")
var blockCopySrc = preload("res://Scenes/cubeCopy.tscn")
var timeb4 = 0
var globBlockInstance=0

var globWaveCount=0

var hierPass

var globMostHeight=0

var globFallStart=false

var globRot =0
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
		globWaveCount=0
		hierPass=0
		for i in range(6):
			globXnum = random.randf_range(-24, 24)
			globZnum = random.randf_range(-24, 24)
			globRot = random.randf_range(0, 2*PI)
			globBlockSize = random.randf_range(1, 5)
			globWidth = random.randf_range(0.5, globBlockSize-0.2)
			globHeight = globBlockSize - globWidth
			add_child(blockSrc.instance())
			hierPass+=1
			
		timeb4=0
