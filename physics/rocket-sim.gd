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
var acceleration: float =0.0	# m/s^2, saved so we cam display and graph it
var t: float = 0.0				# s, time since launch

# --- Rocket settings (stay the same during a flight) ---
var mass: float = 0.1			# kg
var thrust: float = 5.0			# N, constant for now
var burn_time: float = 1.0		# s, how long the motor burns

# Moves the simulation forward by one time step of dt seconds.
func step(dt: float) -> void:
	# 1. Forces: thrust only while the motor is burning, weight always.
	var f_thrust: float = thrust if t < burn_time else 0.0
	var weight: float = mass * G
	var f_net: float = f_thrust - weight
	
	# 2. Acceleration from Netwon's second law.
	acceleration = f_net / mass
	
	# 3. Update velocity first, then use the New velocity for altitude.
	velocity += acceleration * dt
	altitude += velocity * dt
	
	# 4. Move the clock forward
	t += dt
