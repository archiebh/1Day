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
onready var main = $Camera/CanvasLayer/Main
onready var settings = $Camera/CanvasLayer/Settings
onready var music = $AudioStreamPlayer
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
	global.fov = value
	camera.fov = global.fov
	pass # Replace with function body.


func _on_musicslider_value_changed(value):
	if value > 20:
		musicvol = value
		global.music = -80 + musicvol
		music.volume_db = global.music
	else:
		musicvol = -100
		global.music = -80 + musicvol
		music.volume_db = global.music
	pass # Replace with function body.


func _on_sfxslider_value_changed(value):
	if value > 50:
		soundvol = value
		global.sound = -80 + soundvol
	else:
		musicvol = 0
		soundvol = 0
		global.sound = -80 + soundvol
	pass # Replace with function body.


func _on_Back_pressed():
	settings.visible = false
	main.visible = true
	
	pass # Replace with function body.


func _on_Settings_pressed():
	settings.visible = true
	main.visible = false
	pass # Replace with function body.


func _on_Exit_pressed():
	get_tree().quit()
