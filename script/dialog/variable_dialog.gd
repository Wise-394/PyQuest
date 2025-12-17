extends Parent_Dialog

func open_dialog():
	var resource = load("res://dialog/variable.dialogue")
	DialogueManager.show_dialogue_balloon(resource, "start")
	
