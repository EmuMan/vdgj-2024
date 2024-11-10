extends CharacterBody2D


enum GroundedState { GROUNDED, AIRBORN }
enum MovementState { IDLE, RUNNING, JUMPING, FALLING }
enum JumpState { CAN_JUMP, JUMPING, AIRBORN }
enum DashState { CAN_DASH, DASHING, ON_COOLDOWN }


const H_MAX_SPEED = 300.0
const H_ACCEL = 3000.0
const H_DEACCEL = 3000.0

const V_MAX_SPEED = 800.0

const JUMP_VELOCITY = -300.0
const JUMP_ACCEL = -1000.0
const JUMP_ACCEL_TIME = 300
const JUMP_COYOTE_TIME = 100
const JUMP_BUFFER_TIME = 100

const DASH_VELOCITY = 1000.0
const DASH_DURATION = 100
const DASH_COOLDOWN = 1000


var grounded_state: GroundedState = GroundedState.AIRBORN
var movement_state: MovementState = MovementState.IDLE
var jump_state: JumpState = JumpState.AIRBORN
var dash_state: DashState = DashState.CAN_DASH

var last_time_grounded: int = 0
var last_jump_input_time: int = 0
var last_jump_action_time: int = 0
var last_dash_action_time: int = 0

var current_dash_direction: float = 0.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	update_grounded_state()
	update_movement_state()
	process_inputs(delta)

	move_and_slide()


func process_inputs(delta: float) -> void:
	var now = Time.get_ticks_msec()
	
	if now <= last_dash_action_time + DASH_DURATION:
		dash_state = DashState.DASHING
	elif now < last_dash_action_time + DASH_COOLDOWN:
		if dash_state == DashState.DASHING:
			velocity.y = max(velocity.y, -DASH_VELOCITY / 10.)
		dash_state = DashState.ON_COOLDOWN
	else:
		dash_state = DashState.CAN_DASH

	var dash_just_pressed = Input.is_action_just_pressed("dash")
	if dash_just_pressed and dash_state == DashState.CAN_DASH:
		last_dash_action_time = now
		dash_state = DashState.DASHING
		var mouse_pos := get_global_mouse_position()
		var displacement := mouse_pos - global_position
		current_dash_direction = displacement.angle()
	
	if dash_state == DashState.DASHING:
		velocity = Vector2(DASH_VELOCITY, 0).rotated(current_dash_direction)
		return

	var jump_pressed = Input.is_action_pressed("jump")
	var jump_just_pressed = Input.is_action_just_pressed("jump")
	if jump_just_pressed:
		last_jump_input_time = now

	# grounded = can jump
	if grounded_state == GroundedState.GROUNDED:
		jump_state = JumpState.CAN_JUMP
	# not grounded + can jump = can't jump
	elif jump_state == JumpState.CAN_JUMP:
		jump_state = JumpState.AIRBORN

	if jump_state == JumpState.CAN_JUMP && now <= last_jump_input_time + JUMP_BUFFER_TIME:
		velocity.y = JUMP_VELOCITY
		jump_state = JumpState.JUMPING
		last_jump_action_time = now

	if jump_state == JumpState.JUMPING:
		if jump_pressed && now <= last_jump_action_time + JUMP_ACCEL_TIME:
			velocity.y += JUMP_ACCEL * delta
		else:
			jump_state = JumpState.AIRBORN

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		var delta_v = H_ACCEL * direction * delta
		if sign(velocity.x) != sign(delta_v):
			delta_v += H_DEACCEL * direction * delta
		velocity.x = clamp(velocity.x + delta_v, -H_MAX_SPEED, H_MAX_SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, H_DEACCEL * delta)
	
	velocity.y = clamp(velocity.y, -V_MAX_SPEED, V_MAX_SPEED)

func update_grounded_state() -> void:
	var now = Time.get_ticks_msec()
	if is_on_floor():
		last_time_grounded = now
		grounded_state = GroundedState.GROUNDED
		return
	# if we are within the coyote time
	if now <= last_time_grounded + JUMP_COYOTE_TIME:
		# if jump has already been processed within the coyote time
		if now <= last_jump_action_time + JUMP_COYOTE_TIME:
			grounded_state = GroundedState.AIRBORN
		else:
			grounded_state = GroundedState.GROUNDED
	else:
		grounded_state = GroundedState.AIRBORN

func update_movement_state() -> void:
	if is_equal_approx(velocity.y, 0.):
		if is_equal_approx(velocity.x, 0.):
			movement_state = MovementState.IDLE
		else:
			movement_state = MovementState.RUNNING
	elif velocity.y > 0.:
		movement_state = MovementState.FALLING
	elif velocity.y < 0.:
		movement_state = MovementState.JUMPING
