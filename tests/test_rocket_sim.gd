extends GutTest

func test_velocity_after_one_second_of_burn():
	var sim := RocketSim.new()
	for i in 1000:			# 1000 steps of 0.001 s = 1 second
		sim.step(0.001)
	assert_almost_eq(sim.velocity, 40.19, 0.01, "Velocity after 1 s of burn should be about 40.19 m/s")
	
func test_acceleration_after_burnout_is_gravity():
	var sim := RocketSim.new()
	for i in 1500:			# 1.5 seconds: past the 1 s burn
		sim.step(0.001)
	assert_almost_eq(sim.acceleration, -9.81, 0.001, "After burnout, acceleration should equal gravity")
	
func test_stays_on_pad_when_trust_too_low():
	var sim := RocketSim.new()
	sim.thrust = 0.5	# weight is 0.981 N, so this can't lift it
	sim.run_until_finished(0.001)
	assert_eq(sim.altitude, 0.0, "Rocket should never go below or leave the pad")
	assert_false(sim.has_lifted_off, "Rocket should not lift off")
	
func test_full_flight_lands():
	var sim := RocketSim.new()
	sim.run_until_finished(0.001)
	assert_true(sim.has_landed, "Rocket should land")
	assert_eq(sim.altitude, 0.0, "Altitude should be 0 after landing")
	assert_almost_eq(sim.landing_time, 9.67, 0.05, "Should land after about 9.67 s")
