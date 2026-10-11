# rocket_sim.gd
# The physics core of the simulator. Math only:
# no drawing, no nodes, nothing on screen.
class_name RocketSim
extends RefCounted

# Gracity's acceleration in m/s^2. "const" meanss it can never change.
const G: float = 9.81

# --- Rocket state (changes every step) ---
var altitude: float = 0.0		# m, height above the launch pad
var velocity: float = 0.0		# m/s, positive = up, negative = down
var acceleration: float = 0.0	# m/s^2, saved so we cam display and graph it
var t: float = 0.0				# s, time since launch
var max_altitude: float = 0.0	# m, highest point reached (apogee)
# --- Flight status ---
var has_lifted_off: bool = false	# true once the rocket leaves the pad
var has_landed: bool = false		# true once it comes back down
var landing_time: float = 0.0		# s
var landing_speed: float = 0.0		# m/s, impact speed (always positive)

# --- Rocket settings (stay the same during a flight) ---
var mass: float = 0.1			# kg
var thrust: float = 5.0			# N, constant for now
var burn_time: float = 1.0		# s, how long the motor burns

# Moves the simulation forward by one time step of dt seconds.
func step(dt: float) -> void:
	# Once the flight is over, nothing changes.
	if is_finished():
		return
	
	# 1. Forces: thrust only while the motor is burning, weight always.
	var f_thrust: float = thrust if t < burn_time else 0.0
	var weight: float = mass * G
	var f_net: float = f_thrust - weight
	
	# on the pad, the ground holds the rocket up. It only lifts off
	# once the net force points up, or if it starts in the air.
	if not has_lifted_off:
		if f_net > 0.0 or altitude > 0.0:
			has_lifted_off = true
		else:
			acceleration = 0.0
			t += dt
			return
	
	# 2. Acceleration from Netwon's second law.
	acceleration = f_net / mass
	
	# 3. Update velocity first, then use the New velocity for altitude.
	velocity += acceleration * dt
	altitude += velocity * dt
	max_altitude = maxf(max_altitude, altitude)
	
	# 4. Move the clock forward
	t += dt
	
	# reaching the ground after liftoff means it landed.
	if altitude <= 0.0:
		landing_speed = absf(velocity)
		landing_time = t
		altitude = 0.0
		velocity = 0.0
		has_landed = true
		
# true when the flight is over, either because it landed or because
# the motor burned out without ever lifting the rocket off the pad.
func is_finished() -> bool:
	if has_landed:
		return true
	return not has_lifted_off and altitude <= 0.0 and t >= burn_time
	
# runs a whole flight instantly. Used by tests now, and later for
# running thousands of flights.
func run_until_finished(dt: float, max_time: float = 600.0) -> void:
	while not is_finished() and t < max_time:
		step(dt)
