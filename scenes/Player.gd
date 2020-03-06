extends KinematicBody2D

const ACCEL = 850
const MAX_SPEED = 85
const FRICTION = 0.25
const AIR_RESIST = 0.02
const GRAVITY = 250
const JUMP_FORCE = 128

var motion = Vector2.ZERO
var double_jump = 0

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer

func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if x_input != 0:
		animation_player.play("Run")
		motion.x += x_input * ACCEL * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		sprite.flip_h = x_input < 0
	else:
		animation_player.play("Stand")
	
	motion.y += GRAVITY * delta
	
	if is_on_floor():
		double_jump = 0
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION)
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE 
	else:
		animation_player.play("Jump")
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
		if double_jump < 1 and Input.is_action_just_pressed("ui_up"):
			double_jump += 1
			motion.y = -JUMP_FORCE 
			
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESIST)
	
	motion = move_and_slide(motion, Vector2.UP)
