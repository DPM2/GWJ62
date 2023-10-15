extends CharacterBody3D
class_name PlayerBody

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const RUN_MULT = 2.0

const mouse_sensitivity = .005

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var hand_pumpkin = $ItemHolder/Pumpkin
var holding_item = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

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
		velocity.x = direction.x * SPEED * RUN_MULT
		velocity.z = direction.z * SPEED * RUN_MULT
	elif direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
