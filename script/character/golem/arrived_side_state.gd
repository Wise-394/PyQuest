extends State

enum AttackType {
	RANGE,
	LASER,
}

var attack_type: AttackType

func enter():
	attack_type = [AttackType.RANGE, AttackType.LASER].pick_random()

	match attack_type:
		AttackType.RANGE:
			state_machine.change_state("RangeAttackState")
		AttackType.LASER:
			state_machine.change_state("LaserAttackState")
