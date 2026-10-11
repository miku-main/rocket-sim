# flight.gd
# Runs a RocketSim in real time using a fixed time step.
extends Node2D

const DT: float = 0.001            		# s, physics time step (always the same)
const MAX_FRAME_TIME: float = 0.25 		# s, cap so a frozen frame can't cause a huge catch-up
const PIXELS_PER_METER: float = 10.0	# drawing scale

# references to nodes in the scene, found when the scene starts.
@onready var rocket: Node2D = $Rocket
@onready var stats: Label = $HUD/Stats

var sim: RocketSim
var accumulator: float = 0.0       # s, real time waiting to be simulated
var reported: bool = false         # so the result prints only once


func _ready() -> void:
	sim = RocketSim.new()

# (re)starts a flight from the pad.
func start_flight() -> void:
	sim = RocketSim.new()
	accumulator = 0.0
	reported = false

func _process(delta: float) -> void:
	# press Space or Enter to launch again.
	if Input.is_action_just_pressed("ui_accept"):
		start_flight()
	
	# Deposit this frame's real time into the "time bank".
	accumulator += minf(delta, MAX_FRAME_TIME)

	# Withdraw it in exact DT chunks.
	while accumulator >= DT and not sim.is_finished():
		sim.step(DT)
		accumulator -= DT
	
	update_visuals()

	# Print the result once when the flight ends.
	if sim.is_finished() and not reported:
		reported = true
		if sim.has_landed:
			print("Landed at t = %.3f s, impact speed %.2f m/s" % [sim.landing_time, sim.landing_speed])
		else:
			print("Rocket failed to lift off")

# moves the rocket on screen and updates the text.
func update_visuals() -> void:
	# Flip the sign: physics up is positive, screen up is negative.
	rocket.position.y = -sim.altitude * PIXELS_PER_METER
	
	stats.text = "Time: %.2f s\nAltitude: %.1f m\nMax altitude: %.1f m\nVelocity: %.1f m/s\nAcceleration: %.1f m/s^2\nStatus: %s" %[
		sim.t, sim.altitude, sim.max_altitude, sim.velocity, sim.acceleration, get_status()
	]
	
# describes what the rocket is doing right now.
func get_status() -> String:
	if sim.has_landed:
		return "Landed (impact %.1f m/s)" % sim.landing_speed
	if sim.is_finished():
		return "Failed to lift off"
	if not sim.has_lifted_off:
		return "On the pad"
	if sim.t < sim.burn_time:
		return "Motor burning"
	if sim.velocity > 0.0:
		return "Coasting up"
	return "Falling"
