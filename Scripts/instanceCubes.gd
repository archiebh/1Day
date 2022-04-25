extends Spatial


var blockSrc = preload("res://Scenes/cube.tscn")
var blockCopySrc = preload("res://Scenes/cubeCopy.tscn")
var timeb4 = 0
var globBlockInstance=0

var globWaveCount=0

var hierPass
var unpause = 0
var globMostHeight=0

var globFallStart=false
onready var pausemenu = $PauseMenu
var globRot =0
var globXnum =0
var globZnum =0
var globBlockSize =0
var globWidth =0
var globHeight =0
var random = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
onready var layer1 = $Layer1
onready var layer2 = $Layer2
onready var layer3 = $Layer3
onready var layer4 = $Layer4
onready var playery = global.playery
onready var watery = global.watery
onready var difference
func _ready():
	layer1.play()
	layer2.play()
	layer3.play()
	layer4.play()
	Engine.target_fps = 60
var pause = 0
var paused = 0
func isTooNear(w, h, xN, yN):
	var bottom = false
	var top = false
	var left = false
	var right = false
	var aS = pow((w/2), 2)
	var bS = pow((h/2), 2)
	var v = sqrt ( aS + bS )
	var toMove=0
	var rep = Vector3(0, 0, 0)
	if xN - v < -25:
		left = true
	if xN + v > 25:
		right = true
	if yN - v < -25:
		bottom = true
	if yN + v > 25:
		top = true
	if left:
		toMove = v-(xN--25)
		rep+=Vector3(toMove, 0, 0)
	if right:
		toMove = v-(25-xN)
		rep+= Vector3(-toMove, 0, 0)
	if bottom:
		toMove = v-(yN--25)
		rep+=Vector3(0, 0, toMove)
	if top:
		toMove = v-(25-yN)
		rep+= Vector3(0, 0, -toMove) 
	
	return rep
	
func getWorst(w, h):
	var aS = pow((w/2), 2)
	var bS = pow((h/2), 2)
	var v = sqrt ( aS + bS )
	return v
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	difference = global.playery - global.watery
	print(str(difference))
	if Input.is_action_just_pressed("esc") and global.dead == 0:
		get_tree().paused = true
		paused = 1
		global.paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pausemenu.visible = 1
	timeb4+=delta
	if timeb4 > 0.5:
		globFallStart=false
		random.randomize()
		globWaveCount=0
		hierPass=0
		for i in range(6):
			globBlockSize = random.randf_range(1, 5)*4
			globWidth = random.randf_range(2, globBlockSize-0.8)
			globHeight = (globBlockSize - globWidth)
			globRot = random.randf_range(0, 2*PI)
			var safetyMeasure = getWorst(globWidth, globHeight)
			globXnum = random.randf_range((-25)+safetyMeasure, 25-safetyMeasure)
			globZnum = random.randf_range((-25)+safetyMeasure, 25-safetyMeasure)
			add_child(blockSrc.instance())
			hierPass+=1
			
		timeb4=0


func _on_Continue_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pausemenu.visible = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	paused = 0
	global.paused = false


func _on_Exit_pressed():
	global.isInGame=false
	get_tree().paused = false
	get_tree().change_scene("res://mainmenu.tscn")
