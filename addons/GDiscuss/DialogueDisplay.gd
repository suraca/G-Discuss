extends VBoxContainer
var tick:int=0
var previousButton=null
var imageLocation:String="res://Sprites/CharacterPortraits/"
var shaderLocation:String="res://GDiscuss/"

func clear():for i in %HBoxContainer.get_children():i.queue_free()
func setText(t:String):
	%Label.text = t

func start():
	tick+=1
	%Label.visible_characters=-1
	var temp = tick
	for i in len(%Label.text):if tick==temp:
		%Label.visible_characters+=2
		await get_tree().create_timer(.01).timeout

func addText(t:String):
	%Label.text+=t
	#%Label.add_text(t)

func newLine():
	%Label.text+="\n"

func ac(c:Button):
	%HBoxContainer.add_child(c)
	if previousButton!=null:
		c.focus_next = c.get_path_to(previousButton)
		previousButton.focus_previous = previousButton.get_path_to(c)
	else:c.grab_focus()
	previousButton=c
func getImage(s:String,i:int,side:String = "r",shader:String="",fileType:String="png"):
	if side.to_lower() == "l" or side.to_lower() == "left":%HBoxConsdadwtainer.move_child(%TextureRect,0)
	if side.to_lower() == "r" or side.to_lower() == "right":%HBoxConsdadwtainer.move_child(%TextureRect,1)
	if shader!="":load(shaderLocation+shader+".res")
	%TextureRect.texture = load(imageLocation+s+"_"+str(i)+"."+fileType)
	#print(imageLocation+s+"_"+str(i)+"."+fileType)
