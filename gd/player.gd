extends CharacterBody3D
class_name PlayerBody

const SPEED = 3.0
const JUMP_VELOCITY = 4.5
const RUN_MULT = 2.0

const mouse_sensitivity = .005

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var hand_pumpkin = $ItemHolder/Pumpkin
var holding_item = false

var walking = false
var just_walking = false
var running = false
var just_running = false

var ground_type = "grass"

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$AnimationPlayer.play("walk")

func play_step_sound():
	get_node("footsteps_" + ground_type).play()


func _process(delta):
	if walking:
		if just_walking:
			just_walking = false
			$AnimationPlayer.play("walk", .5)
			while walking:
				await get_tree().create_timer(1).timeout
				play_step_sound()
	elif running:
		if just_running:
			just_running = false
			$AnimationPlayer.play("run", .5)
			while running:
				#Play sound before waiting to give extra oomf when starting to run
				play_step_sound()
				await get_tree().create_timer(.6).timeout
	else:
		$AnimationPlayer.pause()


func _physics_process(delta):
	#If our player is holding a pumpkin, make it visible. Otherwise, hide it.
	if is_instance_valid(hand_pumpkin):
		if holding_item and !hand_pumpkin.visible:
			hand_pumpkin.show()
			#todo - change hand placements
		elif !holding_item and hand_pumpkin.visible:
			hand_pumpkin.hide()
			#todo - change hand placements
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if Input.is_action_pressed("run") and input_dir.y<0:
		running = true
		walking = false
		velocity.x = direction.x * SPEED * RUN_MULT
		velocity.z = direction.z * SPEED * RUN_MULT
	elif direction:
		walking = true
		running = false
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		walking = false
		running = false
		just_walking = true
		just_running = true
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
