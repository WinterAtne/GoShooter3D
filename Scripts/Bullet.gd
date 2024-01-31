extends RigidBody3D

var initial_inpulse : float = 50

func _ready():
	rotation.x = -rotation.x
	apply_impulse(global_transform.basis.z.normalized() * initial_inpulse)
	pass 
