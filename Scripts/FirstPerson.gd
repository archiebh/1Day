extends KinematicBody
var height
var speed = 8
const ACCEL_DEFAULT = 10
const ACCEL_AIR = 10
onready var accel = ACCEL_DEFAULT
var gravity = 30
var jump = 16
var walljump = 1
var todo = 0
const gravconst = 30
var score = 0
var highscore = 0
const SAVE_FILE_PATH = "user://savedata.save"
var jumping
var cam_accel = 40
var mouse_sense = 0.2
var snap
var melee_damage = 5
var blocking = 0
var position = Vector3()
var y: float = position.y
var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()
var dead = 0
var squashed = 0
onready var head = $Head
onready var camera = $Head/Camera
onready var melee_anim = $AnimationPlayer
onready var slash = $Head/slash
onready var cut = $Head/cut
onready var jumpsound = $Head/jump
onready var walksound = $Head/walk
onready var sprintsound = $Head/sprint
onready var slidesound = $Head/slide
onready var upbox = $PlayerHitbox
onready var water = $Head/water
onready var waterblock = get_node("/root/mainNode/lvl1/water")
onready var scorelabel = $Head/CanvasLayer/Label
onready var deathlabel = $Head/CanvasLayer/Label2

func _ready():
	#hides the cursor
	loadhighscore()
	water.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func setscore():
	height = translation.y
	if height > score and dead == 0:
		score = height
	scorelabel.text = str(int(round(score))-2)
	if highscore < score:
		highscore = score-2

func teleport():
	if translation.x > 25:
		translation = Vector3(-25, translation.y, translation.z)
	if translation.x < -25:
		translation = Vector3(25, translation.y, translation.z)
	if translation.z > 25:
		translation = Vector3(translation.x, translation.y,-25)
	if translation.z < -25:
		translation = Vector3(translation.x, translation.y, 25)

func block():
	if Input.is_action_just_pressed("block") and not melee_anim.is_playing():
		melee_anim.play("Block")
		blocking = 1
	if Input.is_action_just_released("block") and blocking == 1:
		blocking = 0
		melee_anim.play("BlockRelease")

func savehighscore():
	var save_data = File.new()
	save_data.open(SAVE_FILE_PATH, File.WRITE)
	save_data.store_var(highscore)
	save_data.close()

func loadhighscore():
	var save_data = File.new()
	if save_data.file_exists(SAVE_FILE_PATH):
		save_data.open(SAVE_FILE_PATH, File.READ)
		highscore = save_data.get_var()
		save_data.close()

func kill():
	if translation.y - waterblock.translation.y < -1 and dead == 0:
		savehighscore()
		deathlabel.text = "Drowned!\nScore: "+str(int(round(score))-2)+"\nHigh Score: "+str(int(round(highscore)))+"\n\nClick to restart"
		deathlabel.visible = true
		scorelabel.visible = false
		dead = 1
	if squashed == 1 and dead == 0:
		savehighscore()
		deathlabel.text = "Crushed!\nScore: "+str(int(round(score))-2)+"\nHigh Score: "+str(int(round(highscore)))+"\n\nClick to restart"
		deathlabel.visible = true
		scorelabel.visible = false
		dead = 1
func restart():
	get_tree().reload_current_scene()

func _process(delta):
	kill()
	teleport()
	setscore()
	if dead == 1 and Input.is_action_pressed("leftclick"):
		restart()
	water.volume_db = 4-(translation.y - waterblock.translation.y)
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		camera.set_as_toplevel(true)
		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.set_as_toplevel(false)
		camera.global_transform = head.global_transform
	if dead == 1:
		set_physics_process(false)
		jumpsound.stop()
		walksound.stop()
		sprintsound.stop()
		if waterblock.translation.y > 0:
			translation.y = waterblock.translation.y + 5


func _physics_process(delta):
	#get keyboard input
	
	if len(upbox.get_overlapping_areas()) > 0 and is_on_ceiling():
		translation -= Vector3(0, 20*delta, 0)
		gravity_vec = Vector3.DOWN
	if is_on_floor() and is_on_ceiling():
		squashed = 1
	if is_on_wall():
		if Input.is_action_pressed("jump") and walljump ==1:
			gravity = gravconst
			jumping = 0
	if not is_on_wall():
		gravity = gravconst
		jumping = 1
	if is_on_floor():
		jumping = 1
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	if Input.is_action_pressed("sprint"):
		speed = 17
	if Input.is_action_just_released("sprint"):
		speed = 8
	#jumping and gravity
	if Input.is_action_pressed("sprint"):
		melee_damage = 5
	if is_on_floor():
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
		walljump = 1
		jumpsound.play()
	if Input.is_action_just_pressed("jump") and is_on_wall() and walljump == 1:
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
		walljump = 0
		jumpsound.play()
		slidesound.stop()
	if is_on_floor():
		if Input.is_action_pressed("move_backward") or Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			if Input.is_action_pressed("sprint"):
				if not sprintsound.playing:
					sprintsound.play()
					walksound.stop()
			if not Input.is_action_pressed("sprint"):
				if not walksound.playing:
					walksound.play()
					sprintsound.stop()
	if not is_on_floor():
		walksound.stop()
		sprintsound.stop()
	if walksound.playing or sprintsound.playing:
		if Input.is_action_just_released("move_forward") or Input.is_action_just_released("move_backward") or Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right"):
			walksound.stop()
			sprintsound.stop()
	if jumping == 1 and walljump == 1:
		slidesound.play()
	if not is_on_wall() or not Input.is_action_pressed("jump"):
		slidesound.stop()
	#make it move
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	movement = velocity + gravity_vec
	
# warning-ignore:return_value_discarded
	move_and_slide_with_snap(movement, snap, Vector3.UP)


