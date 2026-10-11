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
