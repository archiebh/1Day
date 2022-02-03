extends Spatial


var blockSrc = preload("res://Scenes/cube.tscn")
var blockCopySrc = preload("res://Scenes/cubeCopy.tscn")
var timeb4 = 0
var globBlockInstance=0

var globWaveCount=0
var musicvol = 100
var soundvol = 100
var hierPass

var globMostHeight=0

var globFallStart=false
onready var camera = $Camera
onready var waterblock = get_node("lvl1/water")
onready var block = get_node("lvl1/floor/CSGBox")
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

func camera():
	camera.translation.y = waterblock.translation.y + 35
	
func _process(delta):
	camera()
	timeb4+=delta
	if timeb4 > 0.5:
		globFallStart=false
		random.randomize()
		globWaveCount=0
		hierPass=0
		for i in range(6):
			globXnum = random.randf_range(-2, 2)
			globZnum = random.randf_range(-2, 2)
			globRot = random.randf_range(0, 2*PI)
			globBlockSize = random.randf_range(1, 5)
			globWidth = random.randf_range(0.5, globBlockSize-0.2)
			globHeight = globBlockSize - globWidth
			add_child(blockSrc.instance())
			hierPass+=6
			
		timeb4=0


func _on_Play_pressed():
	get_tree().change_scene("res://main.tscn")
	pass # Replace with function body.


func _on_fovslider_value_changed(value):
	camera.fov = value
	pass # Replace with function body.


func _on_musicslider_value_changed(value):
	musicvol = value
	pass # Replace with function body.


func _on_sfxslider_value_changed(value):
	soundvol = value
	pass # Replace with function body.
