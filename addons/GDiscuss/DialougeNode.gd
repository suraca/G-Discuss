class_name DialougeNode extends Node
signal dialog_signal
func start(dialoge:String="res://GDiscuss/SavedTrees/Tester.res",node=null):
	var i = GDiscussInterpreter.new()
	add_child(i)
	i.start(ResourceLoader.load(dialoge).code,node)
	await i.done
	i.queue_free()
