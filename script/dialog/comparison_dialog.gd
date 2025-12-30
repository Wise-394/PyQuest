extends Parent_Dialog

func open_dialog():
	var resource = load("res://dialog/comparison_operator.dialogue")
	DialogueManager.show_dialogue_balloon(resource, "start")
	
