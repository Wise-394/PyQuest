extends State

enum AttackType { RANGE, LASER }

func enter():
	var attack_type = AttackType.values().pick_random()  # pick one attack
	match attack_type:
		AttackType.RANGE:
			state_machine.change_state("RangeAttackState")
		AttackType.LASER:
			state_machine.change_state("LaserAttackState")
