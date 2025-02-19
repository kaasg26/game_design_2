extends CharacterBody3D

@onready var dmg_area = $DamageArea
@onready var atk_area = $AttackArea
@onready var nav_agent = $NavigationAgent3D

@onready var model = $Yellow_Biped
@onready var animator = $Yellow_Biped/AnimationPlayer

var SPEED = 3.0
var ACCEL = 20
var ATTACK = 10
var KNOCKBACK = 16.0
var WALK_SPEED = SPEED
var RUN_SPEED = SPEED * 1.5

func take_damage(_dmg):
	self.queue_free()

func _physics_process(delta: float) -> void:
	for player in get_tree().get_nodes_in_group("Player"):
		if $AttackRange.overlaps_body(player):
			nav_agent.target_position = player.global_position
			SPEED = RUN_SPEED
		else:
			WALK_SPEED
		if atk_area.overlaps_body(player):
			player.take_damage(ATTACK)
			player.inertia = (player.global_position-self.global_position) \
											.normalized() * KNOCKBACK
	var dir = (nav_agent.target_position-self.global_position)
	dir.y = 0
	if dir.length() > 0.01:
		var rot_angle = atan2(dir.x, dir.z)
		self.rotation.y = lerp_angle(rotation.y, rot_angle, 5 * delta)
	velocity = velocity.lerp(dir.normalized() * SPEED, ACCEL * delta)
	
	
	
	animator.play("Robot_Soldat")
	
	
	move_and_slide()
	
