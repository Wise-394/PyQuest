extends Parent_Dialog

func open_dialog():
	var resource = load("res://dialog/test.dialogue")
	DialogueManager.show_dialogue_balloon(resource, "start")
	
