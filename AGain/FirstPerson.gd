extends KinematicBody

var speed = 5
const ACCEL_DEFAULT = 7
const ACCEL_AIR = 1
onready var accel = ACCEL_DEFAULT
var gravity = 9.8
var jump = 7
var walljump = 1

var floating_text = preload("res://Position.tscn")
var jumping
var cam_accel = 40
var mouse_sense = 0.1
var snap
var melee_damage = 5
var blocking = 0
var position = Vector3()
var y: float = position.y
var text = floating_text.instance()
var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()
onready var head = $Head
onready var camera = $Head/Camera
onready var melee_anim = $AnimationPlayer
onready var hitbox = $Head/Camera/Hitbox
onready var slash = $Head/slash
onready var cut = $Head/cut
onready var jumpsound = $Head/jump
onready var walksound = $Head/walk
onready var sprintsound = $Head/sprint
onready var slidesound = $Head/slide
onready var flipsound = $Head/flip
onready var timer = $Timer
onready var strikebar = $Head/Camera/StrikePower

func StrikeTimeout():
	if melee_damage <25:
		melee_damage = melee_damage + 1
		if not is_on_floor() and melee_damage >= 15:
			melee_damage = 15

func _ready():
	#hides the cursor
	timer.start()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func melee():
	if Input.is_action_just_released("fire") and not Input.is_action_pressed("sprint") and blocking == 0:
		if not melee_anim.is_playing():
			melee_anim.play("Slash")
			slash.play()
			for body in hitbox.get_overlapping_bodies():
				if body.is_in_group("Enemy"):
					body.health -= melee_damage
					text.amount = melee_damage
					text = text.instance()
					add_child(text)
					cut.play()
	if not Input.is_action_pressed("fire") or blocking == 1:
		melee_damage = 5

func respawn():
	if position.y < -50:
		self.position = Vector3(0,0,50)

func flip():
	if Input.is_action_just_pressed("flip") and blocking == 0:
		
		melee_anim.play("Flip")
		flipsound.play()

func block():
	if Input.is_action_just_pressed("block") and not melee_anim.is_playing():
		melee_anim.play("Block")
		blocking = 1
	if Input.is_action_just_released("block") and blocking == 1:
		blocking = 0
		melee_anim.play("BlockRelease")

func _process(delta):
	melee()
	flip()
	block()
	respawn()
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
	strikebar.value = melee_damage
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		camera.set_as_toplevel(true)
		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.set_as_toplevel(false)
		camera.global_transform = head.global_transform
		
func _physics_process(delta):
	#get keyboard input
	if is_on_wall():
		if Input.is_action_pressed("jump") and walljump ==1:
			gravity = 3
			jumping = 0
	if not is_on_wall():
		gravity = 9.8
		jumping = 1
	if is_on_floor():
		jumping = 1
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	if is_on_floor() or is_on_wall():
		if Input.is_action_pressed("sprint"):
			speed = 25
	if Input.is_action_just_released("sprint"):
		speed = 5
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
	if Input.is_action_just_released("jump") and is_on_wall() and walljump == 1:
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

