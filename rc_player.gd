extends VehicleBody3D

const MAX_STEER = 0.4
const MAX_RPM = 400
const MAX_TORQUE = 200
const HORSE_POWER = 200

var laps = 1
var checkpoints = [false, false, false, false]
var Idle = preload("res://assets/audio/Idle.mp3") 
var Accel = preload("res://assets/audio/Accelaration.mp3")

func reset_checkpoints():
	checkpoints = [false, false, false, false]

func do_lap():
	laps += 1
	reset_checkpoints()
	if laps > 3:
		await get_tree().create_timer(0.25).timeout
		OS.alert("You Win") #TODO change level
	else:
		$Label2.text = "Lap %d/3" % laps


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func calc_engine_force(accel, rpm):
	return accel * MAX_TORQUE * (1 - rpm / MAX_RPM)

func _physics_process(delta: float) -> void:
	steering = lerp(steering,
					Input.get_axis("ui_right", "ui_left") * MAX_STEER,
					delta * 5.0)
	var accel = Input.get_axis("ui_down", "ui_up") * HORSE_POWER
	$backLeft.engine_force = calc_engine_force(accel, abs($backLeft.get_rpm()))
	$backRight.engine_force = calc_engine_force(accel, abs($backRight.get_rpm()))
	
	var fwd_mps = abs((linear_velocity * transform.basis).z)
	$Label.text = "%d mph" % (fwd_mps * 2.23694)
	
	$centerMass.global_position = $centerMass.global_position.lerp(
											   global_position, delta * 20.0)
	$centerMass.transform = $centerMass.transform.interpolate_with(
										 transform, delta * 5.0)
	$centerMass/Camera3D.look_at(global_position.lerp(
								  global_position + linear_velocity, delta * 5.0))
	check_and_right()
	
	$AudioStreamPlayer3D.stream = Idle
	$AudioStreamPlayer3D.play()
	
	if accel > 0:
		var max_dB = 110
		var dB = clamp(max_dB * abs($backLeft.engine_force/MAX_RPM), -10, max_dB)
		$AudioStreamPlayer3D.volume_db = dB
		if $AudioStreamPlayer3D.stream == Idle:
			$AudioStreamPlayer3D.stop()
			$AudioStreamPlayer3D.stream = Accel
		if not $AudioStreamPlayer3D.is_playing():
		
			$AudioStreamPlayer3D.play()

	else:
		$AudioStreamPlayer3D.volume_db = 10  # default
		$AudioStreamPlayer3D.stream = Idle
		$AudioStreamPlayer3D.play()
		

  # change the stream to the idle sound and play


func check_and_right():
	if global_transform.basis.y.dot(Vector3.UP) < 0:
		var cur_rotation = self.rotation_degrees
		cur_rotation.x = 0  # Reset pitch
		cur_rotation.z = 0  # Reset roll
		self.rotation_degrees = cur_rotation
