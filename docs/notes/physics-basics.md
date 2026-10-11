# Physics Basics

Notes from Phase 1, written while learning the physics of motion.

## Position, velocity, and acceleration

- **Position (m):** where the rocket is. For now it only moves up and down, so position is its altitude. 0 is the launch pad.
- **Velocity (m/s):** how fast the position changes. The sign gives the direction: positive means moving up, negative means moving down. At apogee (the highest point), velocity is 0 for an instant.
- **Accleration (m/s^2):** how fast the velocity changes. Gravity gives an acceleration of -9.81 m/s^2, so every second, velocity drops by 9.81 m/s.

Velocity is not the same as acceleration: a rocket can be moving fast with zero acceleration, or be stopped with a large acceleration.

## Sign convention

Positive means up, negative means down. If altitude goes below 0, the rocket has hit the ground.

## Forces

- **Force (N):** a push or a pull. Mass is in kilograms (kg).
- **Thrust:** pushes the rocket up while the motor burns.
- **Weight:** pulls the rocket down, always. weight = mass x 9.81
- **Net force:** all forces combined. Net force = Thrust - Weight

## Newton's second law

net force = mass x acceleration

acceleration = net force / mass

After burnout, thrust is 0, so acceleration = -9.81 m/s^2 no matter the mass.

## Thrust-to-weight ratio

Doubling the mass with the same thrust cuts acceleration by more than half, because weight doubles too. Example with 6 N thrust:
| Mass (kg) | Weight (N) | Net force (N) | Acceleration (m/s²) |
| --- | --- | --- | --- |
| 0.2 | 1.962 | 4.038 | 20.19 |
| 0.4 | 3.924 | 2.076 | 5.19 |

If weight is bigger than thrust, net force is negative and the rocket never leaves the pad.
Model rockets usually need a thrust-to-weight ratio of at least 5 to 1.

## How the simulator steps through time

A simulator moves forward in small slives of time called the time step (dt),
measured in seconds. Each step follows the chain:

1. Acceleration = net force / mass
2. New velocity = old velocity + acceleration x (dt)
3. New altitude = old altitude + new velocity x (dt)

Example: velocity 10 m/s, altitude 50 m, acceleration -9.81 m/s^2, dt = 0.1 s

- new velocity = 10 m/s + (-9.81 m/s^2) x 0.1 s = 9.019 m/s
- new altitude = 50 m + 9.019 m/s x 0.1s = 50.9019 m

A smaller dt gives more accurate results.