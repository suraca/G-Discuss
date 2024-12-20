extends Node

var Flags = ["Evidence1"]
var currentName = "John"
var testint:int = 5


func _physics_process(delta):
	if Input.is_action_just_pressed("SAVE"):
		_on_button_2_pressed()

func _on_button_pressed():
	var i = GDiscussInterpreter.new()
	add_child(i)
	i.start_code($TextEdit.text,$D)
	await i.done
	i.queue_free()

func fromFile(filePath:String):
	var i = DialougeNode.new()
	add_child(i)
	await i.start(filePath,$D)
	i.queue_free()


func _on_button_2_pressed():
	if str($LineEdit.text).is_valid_filename():
		var d = DialogueFile.new()
		if str($TextEdit.text).replace(" ","").replace("\t","").replace("\n","").replace("	","")!="":
			d.code = $TextEdit.text
			$TextEdit2.text="Saved"
			ResourceSaver.save(d,"res://addons/GDiscuss/SavedTrees/"+str($LineEdit.text)+".res")
		else:$TextEdit2.text = "No valid code"
	else:$TextEdit2.text = "Not a valid filename"
	

func _on_load_pressed():
	if str($LineEdit.text).is_valid_filename():
		if str("res://addons/GDiscuss/SavedTrees/"+$LineEdit.text+".res").is_absolute_path():
			var d = ResourceLoader.load("res://addons/GDiscuss/SavedTrees/"+$LineEdit.text+".res")
			d = ResourceLoader.load("res://addons/GDiscuss/SavedTrees/docs.res")
			$TextEdit2.text="Failed to load"
			if !d:return
			$TextEdit.text = d.code
			Flags=[]
			$TextEdit2.text="Loaded"
		else:$TextEdit2.text = "Not a valid path"
	else:$TextEdit2.text = "Not a valid filename"
