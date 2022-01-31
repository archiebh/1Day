extends Spatial


var blockSrc = preload("res://Scenes/cube.tscn")
var timeb4 = 0
var blockInstance=0

var globXnum =0
var globZnum =0
var globBlockSize =0
var globWidth =0
var globHeight =0
var random = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeb4+=delta
	if timeb4 > 2:
		random.randomize()
		globXnum = random.randf_range(-12.5, 12.5)
		globZnum = random.randf_range(-12.5, 12.5)
		globBlockSize = random.randf_range(2, 8)
		globWidth = random.randf_range(1, globBlockSize-0.4)
		globHeight = globBlockSize - globWidth
		add_child(blockSrc.instance())
		blockInstance+=1
		add_child(blockSrc.instance())
		blockInstance+=1
		add_child(blockSrc.instance())
		blockInstance+=1
		add_child(blockSrc.instance())
		blockInstance+=1
		add_child(blockSrc.instance())
		blockInstance+=1
		add_child(blockSrc.instance())
		blockInstance+=1
		add_child(blockSrc.instance())
		blockInstance+=1
		add_child(blockSrc.instance())
		blockInstance+=1
		add_child(blockSrc.instance())
		blockInstance=0
		timeb4=0
