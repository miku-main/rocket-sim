extends GutTest

func test_addition():
	assert_eq(1 + 1, 2, "1 + 1 should equal 2")
	
func test_gravity_constant():
	var g := 9.81
	assert_almost_eq(g, 9.81, 0.001, "Gravity should be 9.81 m/s^2")
