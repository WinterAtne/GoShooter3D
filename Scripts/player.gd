extends CharacterBody3D

@export var speed = 5.0
@export var acceleration = 4.0
@export var jump_speed = 8.0
@export var mouse_sensitivity = 0.0015

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera = $Camera3D
@onready var anim_tree = $AnimationTree

@onready var bullet = load("res://Scenes/Bullet.tscn")

var moving = false
var was_moving = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	velocity.y += -gravity * delta
	get_move_input(delta)
	move_and_slide()
	shoot()
	
	if velocity.x != 0:
		moving = true
	
	if moving != was_moving:
		anim_tree.set("parameters/conditions/moving", moving)
		anim_tree.set("parameters/conditions/notmoving", !moving)
	
	was_moving = moving
	pass

func get_move_input(delta):
	#We store the state of the y velocity so that it isn't canceled when we change everything else
	var vy = velocity.y
	
	velocity.y = 0
	var input = Input.get_vector("left", "right", "forward", "backward")
	var dir = Vector3(input.x, 0, input.y).rotated(Vector3.UP, rotation.y)
	velocity = lerp(velocity, dir * speed, acceleration * delta)
	
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = jump_speed
	else:
		velocity.y = vy
	
	pass

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		camera.rotation.x -= event.relative.y * mouse_sensitivity
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90.0, 90.0)
		rotation.y -= event.relative.x * mouse_sensitivity

func shoot():
	if Input.is_action_just_pressed("shoot"):
		var instance = bullet.instantiate()
		instance.position = camera.global_position + Vector3(0, 0, -1).rotated(Vector3.UP, camera.global_rotation.y)
		instance.transform.basis = camera.global_transform.basis.rotated(Vector3.UP, PI)
		get_parent().add_child(instance)
	
