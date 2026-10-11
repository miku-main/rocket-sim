# flight.gd
# Runs a RocketSim in real time using a fixed time step.
extends Node2D

const DT: float = 0.001            # s, physics time step (always the same)
const MAX_FRAME_TIME: float = 0.25 # s, cap so a frozen frame can't cause a huge catch-up

var sim: RocketSim
var accumulator: float = 0.0       # s, real time waiting to be simulated
var reported: bool = false         # so the result prints only once


func _ready() -> void:
	sim = RocketSim.new()


func _process(delta: float) -> void:
	# Deposit this frame's real time into the "time bank".
	accumulator += minf(delta, MAX_FRAME_TIME)

	# Withdraw it in exact DT chunks.
	while accumulator >= DT and not sim.is_finished():
		sim.step(DT)
		accumulator -= DT

	# Print the result once when the flight ends.
	if sim.is_finished() and not reported:
		reported = true
		if sim.has_landed:
			print("Landed at t = %.3f s, impact speed %.2f m/s" % [sim.landing_time, sim.landing_speed])
		else:
			print("Rocket failed to lift off")
