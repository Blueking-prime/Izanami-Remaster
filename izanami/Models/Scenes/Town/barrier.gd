extends StaticBody2D

class_name Barrier

@export var collision: CollisionShape2D

@export var states: Dictionary [StateHandler.STATE, bool] = {}
@export var extra_checks: Array[StringName]

func set_state():
	if states.has(Checks.state):
		collision.set_deferred('disabled', states[Checks.state])

		if extra_checks:
			collision.set_deferred('disabled', Checks.check_flags(extra_checks))
